#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)";cd "$ROOT"
VERSION="0.8.1"
[[ "$(dpkg --print-architecture)" == amd64 ]] || { echo "HARDIK OS targets amd64.";exit 1; }
grep -q '^VERSION_CODENAME=trixie$' /etc/os-release || { echo "Build host must be Debian 13 Trixie.";exit 1; }
for cmd in lb xorriso mksquashfs debootstrap python3 rsvg-convert;do command -v "$cmd" >/dev/null||{ echo "Missing command: $cmd";exit 1;};done
mkdir -p output;rm -f output/*.iso output/SHA256SUMS output/build-info.txt output/build.log
exec > >(tee -a output/build.log) 2>&1
echo "=== HARDIK OS $VERSION / Debian 13 Trixie / KDE Plasma ===";date -u;cat /etc/os-release
lb clean --purge || true;rm -rf config/binary config/bootstrap config/chroot config/common config/source
lb config --ignore-system-defaults --mode debian --distribution trixie --parent-distribution trixie --architectures amd64 --linux-flavours amd64 --binary-images iso-hybrid --bootloaders "syslinux grub-efi" --initramfs live-boot --archive-areas "main contrib non-free non-free-firmware" --parent-archive-areas "main contrib non-free non-free-firmware" --mirror-bootstrap http://deb.debian.org/debian/ --mirror-chroot http://deb.debian.org/debian/ --mirror-binary https://deb.debian.org/debian/ --mirror-chroot-security http://security.debian.org/debian-security/ --mirror-binary-security https://security.debian.org/debian-security/ --security true --updates true --firmware-chroot true --firmware-binary true --uefi-secure-boot auto --image-name "hardik-os-$VERSION" --iso-volume HARDIK_OS_080 --iso-application "HARDIK OS $VERSION Debian 13 KDE Plasma Wayland" --bootappend-live "boot=live components username=hardik hostname=hardik-os splash " --apt-recommends true --debian-installer none
bash scripts/validate-debian-config.sh
lb build
ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)";[[ -n "$ISO" ]]||{ echo "No ISO produced";exit 1;}
cp "$ISO" "output/hardik-os-$VERSION-amd64.iso"
{ echo "HARDIK OS $VERSION";echo "Base: Debian 13 Trixie";echo "Desktop: Standard KDE Plasma desktop (Wayland/X11 sessions)";echo "Waydroid: required installed system; skipped in live session";echo "Compatibility: DEB; EXE/MSI via Wine32+64; APK via Waydroid; DMG/PKG extraction; optional experimental Darling; QEMU/DOSBox";echo "Build UTC: $(date -u +%FT%TZ)";echo "Source commit: $(git rev-parse HEAD)";echo "Status: experimental; VM and hardware validation required";} > output/build-info.txt
sha256sum "output/hardik-os-$VERSION-amd64.iso" | tee output/SHA256SUMS
ls -lh output/
