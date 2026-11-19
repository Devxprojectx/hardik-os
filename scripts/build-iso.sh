#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
[[ "$(dpkg --print-architecture)" == "amd64" ]] || { echo "amd64 only"; exit 1; }
for cmd in lb xorriso mksquashfs debootstrap; do command -v "$cmd" >/dev/null || { echo "Missing: $cmd"; exit 1; }; done
mkdir -p output
rm -f output/*.iso output/SHA256SUMS output/build-info.txt
lb clean --purge || true
lb config \
  --mode ubuntu \
  --distribution noble \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --archive-areas "main universe multiverse restricted" \
  --mirror-bootstrap http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot http://archive.ubuntu.com/ubuntu/ \
  --mirror-chroot-security http://security.ubuntu.com/ubuntu/ \
  --mirror-binary http://archive.ubuntu.com/ubuntu/ \
  --bootappend-live "boot=casper quiet splash username=hardik hostname=hardik-os" \
  --apt-recommends false
lb build 2>&1 | tee output/build.log
ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
[[ -n "$ISO" ]] || { echo "No ISO produced; inspect output/build.log"; exit 1; }
cp "$ISO" output/hardik-os-0.1.0-amd64.iso
{
  echo "HARDIK OS experimental development build"
  echo "Base: Ubuntu 24.04 LTS (Noble)"
  echo "Architecture: amd64"
  echo "Build UTC: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  echo "Source commit: ${GITHUB_SHA:-local}"
  echo "Not a finished installer or security certification."
} > output/build-info.txt
ls -lh output/
