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

# Use Ubuntu mode so live-build selects Ubuntu's generic kernel and Noble
# repository conventions. The built-in live-build theme avoids the obsolete
# ubuntu-oneiric theme and its removed gfxboot package.
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
  --package-lists "" \
  --bootappend-live "boot=casper quiet splash username=hardik hostname=hardik-os" \
  --apt-recommends false

test -s config/archives/ubuntu-security.list.chroot
test -s config/archives/ubuntu-security.list.binary
chmod 0755 config/hooks/normal/*.hook.chroot

# Guard against the previous Debian-mode kernel leak before the long build.
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
  echo "Status: experimental; requires VM and hardware validation."
  echo "Security: baseline controls only; no unhackable or certification claim."
} > output/build-info.txt

sha256sum output/*.iso | tee output/SHA256SUMS
ls -lh output/
