#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

[[ "$(dpkg --print-architecture)" == "amd64" ]] || {
  echo "HARDIK OS currently targets amd64 only."
  exit 1
}

for cmd in lb xorriso mksquashfs debootstrap; do
  command -v "$cmd" >/dev/null || { echo "Missing required command: $cmd"; exit 1; }
done

mkdir -p output
rm -f output/*.iso output/SHA256SUMS output/build-info.txt output/build.log
exec > >(tee -a output/build.log) 2>&1

echo "=== HARDIK OS integrated image build ==="
date -u
df -h /
lb clean --purge || true

# Configure live-build once, with all Ubuntu Noble options together.
lb config \
  --mode ubuntu \
  --distribution noble \
  --parent-distribution noble \
  --initramfs casper \
  --bootstrap-keyring ubuntu-keyring \
  --bootstrap-flavour minimal \
  --architectures amd64 \
  --linux-flavours generic \
  --binary-images iso-hybrid \
  --bootloader syslinux \
  --syslinux-theme live-build \
  --archive-areas "main universe multiverse restricted" \
  --parent-archive-areas "main universe multiverse restricted" \
  --mirror-bootstrap https://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot https://archive.ubuntu.com/ubuntu/ \
  --mirror-binary https://archive.ubuntu.com/ubuntu/ \
  --security false \
  --bootappend-live "boot=casper quiet splash username=hardik hostname=hardik-os" \
  --apt-recommends false

# These overlays are copied into the chroot before the binary/bootloader stage.
GFXBOOT_ARCHIVE="config/includes.chroot/usr/share/gfxboot-theme-ubuntu/bootlogo.tar.gz"
test -s "$GFXBOOT_ARCHIVE"
tar -tzf "$GFXBOOT_ARCHIVE" >/dev/null

test -s config/archives/ubuntu-security.list.chroot
test -s config/archives/ubuntu-security.list.binary

# Ubuntu Noble's bundled ISOLINUX theme has stale Syslinux links. Stage a
# local copy and repair only the two links using files from Noble packages.
THEME_SOURCE="/usr/share/live/build/bootloaders/isolinux"
THEME_TARGET="config/bootloaders/isolinux"
test -d "$THEME_SOURCE"
test -e /usr/lib/ISOLINUX/isolinux.bin
test -e /usr/lib/syslinux/modules/bios/vesamenu.c32
rm -rf "$THEME_TARGET"
mkdir -p "$(dirname "$THEME_TARGET")"
cp -a "$THEME_SOURCE" "$THEME_TARGET"
ln -sfn /usr/lib/ISOLINUX/isolinux.bin "$THEME_TARGET/isolinux.bin"
ln -sfn /usr/lib/syslinux/modules/bios/vesamenu.c32 "$THEME_TARGET/vesamenu.c32"
test -L "$THEME_TARGET/isolinux.bin"
test -L "$THEME_TARGET/vesamenu.c32"

# Ubuntu's Noble live-build runs local chroot hooks from config/hooks/*.chroot.
# Keep the hook at that exact level (not in the newer normal/ subdirectory).
test -x config/hooks/0100-hardik-branding.hook.chroot
bash -n config/hooks/0100-hardik-branding.hook.chroot

# Guard against Debian-mode package and security-suite leakage.
if grep -R -nE 'linux-image-amd64|noble/updates' config/chroot config/common config/bootstrap config/binary 2>/dev/null; then
  echo "Invalid Debian-mode package or security suite leaked into Ubuntu config."
  exit 1
fi

echo "=== Build configuration ==="
grep -R -nE 'noble-security|linux-image-generic' config/archives config/package-lists
echo "=== Building image ==="
lb build

ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
[[ -n "$ISO" ]] || { echo "No ISO produced; inspect output/build.log"; exit 1; }

cp "$ISO" output/hardik-os-0.3.0-amd64.iso
{
  echo "HARDIK OS integrated development build"
  echo "Version: 0.3.0"
  echo "Base: Ubuntu 24.04 LTS (Noble)"
  echo "Architecture: amd64"
  echo "Build UTC: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  echo "Source commit: ${GITHUB_SHA:-local}"
  echo "Status: experimental; requires BIOS/UEFI and VM validation."
  echo "Security: baseline controls only; no unhackable or certification claim."
} > output/build-info.txt

sha256sum output/*.iso | tee output/SHA256SUMS
ls -lh output/
