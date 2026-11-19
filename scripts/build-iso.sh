#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
[[ "$(dpkg --print-architecture)" == amd64 ]] || { echo "HARDIK OS targets amd64."; exit 1; }
grep -q '^VERSION_CODENAME=trixie$' /etc/os-release || { echo "Build host must be Debian 13 Trixie."; exit 1; }
for cmd in lb xorriso mksquashfs debootstrap python3; do command -v "$cmd" >/dev/null || { echo "Missing command: $cmd"; exit 1; }; done
mkdir -p output
rm -f output/*.iso output/SHA256SUMS output/build-info.txt output/build.log
exec > >(tee -a output/build.log) 2>&1
echo "=== HARDIK OS 0.5.0 / Debian 13 Trixie ==="
date -u
cat /etc/os-release
dpkg-query -W live-build debootstrap xorriso squashfs-tools
lb clean --purge || true
rm -rf config/binary config/bootstrap config/chroot config/common config/source
lb config \
 --ignore-system-defaults \
 --mode debian --distribution trixie --parent-distribution trixie \
 --architectures amd64 --linux-flavours amd64 \
 --binary-images iso-hybrid --bootloaders "syslinux grub-efi" --initramfs live-boot \
 --archive-areas "main contrib non-free non-free-firmware" \
 --parent-archive-areas "main contrib non-free non-free-firmware" \
 --mirror-bootstrap https://deb.debian.org/debian/ \
 --mirror-chroot https://deb.debian.org/debian/ \
 --mirror-binary https://deb.debian.org/debian/ \
 --mirror-chroot-security https://security.debian.org/debian-security/ \
 --mirror-binary-security https://security.debian.org/debian-security/ \
 --security true --updates true --firmware-chroot true --firmware-binary true \
 --uefi-secure-boot auto --image-name hardik-os-0.5.0 \
 --iso-volume HARDIK_OS_050 --iso-application "HARDIK OS 0.5.0 Debian 13" \
 --bootappend-live "boot=live components username=hardik hostname=hardik-os quiet splash" \
 --apt-recommends true --debian-installer none
grep -R -q 'LB_MODE="debian"' config
grep -R -q 'LB_DISTRIBUTION="trixie"' config
grep -R -q 'LB_INITRAMFS="live-boot"' config
if grep -R -nE 'noble|casper|ubuntu-security|gfxboot-theme-ubuntu' config; then echo "Ubuntu-specific configuration detected."; exit 1; fi
lb build
ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
[[ -n "$ISO" ]] || { echo "No ISO produced."; exit 1; }
cp "$ISO" output/hardik-os-0.5.0-amd64.iso
{
 echo "HARDIK OS 0.5.0 — Development Build"
 echo "Base: Debian 13 Trixie"
 echo "Architecture: amd64"
 echo "Build UTC: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
 echo "Source commit: $(git rev-parse HEAD)"
 echo "Status: experimental live image; installer and hardware validation remain separate acceptance checks."
 echo "Security: baseline controls only; no unhackable or certification claim."
} > output/build-info.txt
sha256sum output/*.iso | tee output/SHA256SUMS
ls -lh output/
