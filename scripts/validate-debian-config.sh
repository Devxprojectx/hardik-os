#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."
while IFS= read -r -d '' file; do bash -n "$file"; done < <(find scripts config/hooks config/includes.chroot/usr/local/bin -type f -print0)
awk 'NF && $1 !~ /^[a-z0-9][a-z0-9+.-]*$/ { print "Invalid package at line " NR ": " $0; bad=1 } END { exit bad }' config/package-lists/hardik.list.chroot
# Search only target configuration files: the validator itself contains these
# forbidden tokens as its detection rules, and the build script checks them too.
if grep -R -nE 'noble|casper|ubuntu-security|gfxboot-theme-ubuntu|linux-image-generic' config; then
 echo "Ubuntu-specific reference remains in configuration."; exit 1
fi
grep -q '^live-boot$' config/package-lists/hardik.list.chroot
grep -q '^live-config-systemd$' config/package-lists/hardik.list.chroot
grep -q '^firmware-linux$' config/package-lists/hardik.list.chroot
python3 - <<'PY'
import xml.etree.ElementTree as ET
ET.parse("config/includes.chroot/usr/share/backgrounds/hardik-wallpaper.svg")
print("Wallpaper SVG is valid.")
PY
echo "Repository-level Debian checks passed."
