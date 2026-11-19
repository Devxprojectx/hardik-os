#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

[[ "$(dpkg --print-architecture)" == "amd64" ]] || {
  echo "HARDIK OS currently supports amd64 only."
  exit 1
}

for cmd in lb xorriso mksquashfs debootstrap; do
  command -v "$cmd" >/dev/null || {
    echo "Missing required build command: $cmd"
    exit 1
  }
done

mkdir -p output
rm -f output/*.iso output/SHA256SUMS output/build-info.txt output/build.log
exec > >(tee -a output/build.log) 2>&1

echo "=== HARDIK OS build starting ==="
date -u
df -h /
lb clean --purge || true

# Debian mode avoids obsolete Ubuntu 11.10 syslinux theme packages.
# Ubuntu Noble security updates are added explicitly below because
# Debian-mode live-build constructs the wrong noble/updates suite name.
lb config \
  --mode debian \
  --distribution noble \
  --initramfs casper \
  --bootstrap-keyring ubuntu-keyring \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --archive-areas "main universe multiverse restricted" \
  --mirror-bootstrap https://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot https://archive.ubuntu.com/ubuntu/ \
  --mirror-binary https://archive.ubuntu.com/ubuntu/ \
  --security false \
  --bootappend-live "boot=casper quiet splash username=hardik hostname=hardik-os" \
  --apt-recommends false

test -s config/archives/ubuntu-security.list.chroot
test -s config/archives/ubuntu-security.list.binary

# live-build local hooks must be executable to run inside the target root.
chmod 0755 config/hooks/normal/*.hook.chroot

if grep -R "noble/updates" config/chroot config/common config/bootstrap 2>/dev/null; then
  echo "Invalid Debian-style security suite found in generated config."
  exit 1
fi

echo "=== Generated APT configuration ==="
grep -R "noble-security" config/archives
echo "=== Building live image ==="
lb build

ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
[[ -n "$ISO" ]] || {
  echo "No ISO produced; inspect output/build.log"
  exit 1
}

cp "$ISO" output/hardik-os-0.2.0-amd64.iso

{
  echo "HARDIK OS experimental development build"
  echo "Version: 0.2.0"
  echo "Base: Ubuntu 24.04 LTS (Noble)"
  echo "Architecture: amd64"
  echo "Build UTC: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  echo "Source commit: ${GITHUB_SHA:-local}"
  echo "Security status: baseline configuration; not a certification."
  echo "Not a finished installer or security certification."
} > output/build-info.txt

sha256sum output/*.iso | tee output/SHA256SUMS
echo "=== Build output ==="
ls -lh output/
