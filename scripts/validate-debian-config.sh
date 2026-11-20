#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."
while IFS= read -r -d '' file; do bash -n "$file"; done < <(
  find scripts config/hooks -type f \( -name '*.sh' -o -name '*.hook.chroot' \) -print0
)
bash -n config/includes.chroot/usr/local/bin/hardik-app-center
bash -n config/includes.chroot/usr/local/bin/hardik-waydroid-setup
awk 'NF && $1 !~ /^[a-z0-9][a-z0-9+.-]*(:[a-z0-9]+)?$/ { print "Invalid package at line " NR ": " $0; bad=1 } END { exit bad }' config/package-lists/hardik.list.chroot
python3 - <<'PY'
import ast, pathlib, xml.etree.ElementTree as ET
for path in pathlib.Path("config/includes.chroot/usr/local/bin").iterdir():
    if path.is_file() and path.read_text(errors="ignore").startswith("#!/usr/bin/python3"):
        ast.parse(path.read_text(), filename=str(path))
ET.parse("config/includes.chroot/usr/share/backgrounds/hardik-wallpaper.svg")
ET.parse("config/includes.chroot/usr/share/backgrounds/hardik-logo.svg")
print("Python sources and SVG assets are syntactically valid.")
PY
if grep -R -nE 'lxqt-config|pcmanfm-qt|qterminal|gsimplecal|noble|casper|ubuntu-security|gfxboot-theme-ubuntu|linux-image-generic' config; then
  echo "Obsolete LXQt or Ubuntu-specific configuration remains."
  exit 1
fi
for package in live-boot live-config-systemd plasma-desktop kwin-x11 sddm calamares calamares-settings-debian python3-pyqt6 wine64; do
  grep -qx "$package" config/package-lists/hardik.list.chroot || { echo "Required package missing: $package"; exit 1; }
done
test -x config/hooks/live/0100-hardik-branding.hook.chroot
test -x config/hooks/live/0105-hardik-wine-multarch.hook.chroot
test -x config/hooks/live/0110-hardik-wallpaper.hook.chroot
test -x config/hooks/live/0115-hardik-login-guard.hook.chroot
test -x config/hooks/live/0120-hardik-plymouth-fix.hook.chroot
test -x config/hooks/live/0125-hardik-display-manager.hook.chroot
test -f config/includes.chroot/usr/local/bin/hardik-shell
test -f config/includes.chroot/usr/local/bin/hardik-store
test -f config/includes.chroot/usr/local/bin/hardik-security-center
echo "Repository-level Debian checks passed."
