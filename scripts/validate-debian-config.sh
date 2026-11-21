#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."
while IFS= read -r -d '' file;do bash -n "$file";done < <(find scripts config/hooks -type f \( -name '*.sh' -o -name '*.hook.chroot' \) -print0)
python3 - <<'PY'
import ast,pathlib,xml.etree.ElementTree as ET
for p in pathlib.Path("config/includes.chroot/usr/local/bin").iterdir():
 if p.is_file() and p.read_text(errors="ignore").startswith("#!/usr/bin/python3"):ast.parse(p.read_text(),filename=str(p))
ET.parse("config/includes.chroot/usr/share/backgrounds/hardik-wallpaper.svg");ET.parse("config/includes.chroot/usr/share/backgrounds/hardik-logo.svg")
print("Python and SVG syntax checks passed")
PY
awk 'NF && $1 !~ /^[a-z0-9][a-z0-9+.-]*(:[a-z0-9]+)?$/ {print "Invalid package line " NR ": " $0;bad=1} END {exit bad}' config/package-lists/hardik.list.chroot
for p in live-boot live-config-systemd plasma-desktop plasma-workspace kwin-wayland sddm calamares calamares-settings-debian wine64 waydroid lxc nftables python3-gbinder python3-pyqt6 qemu-system-x86 qemu-utils qemu-user qemu-user-binfmt virt-manager dosbox zram-tools;do grep -qx "$p" config/package-lists/hardik.list.chroot||{ echo "Required package missing: $p";exit 1;};done
! grep -q 'hardik-startup' config/hooks/live/0100-hardik-branding.hook.chroot
! grep -q 'Qt.WindowType.Dock' config/includes.chroot/usr/local/bin/hardik-shell
test -x config/hooks/live/0100-hardik-branding.hook.chroot
test -x config/hooks/live/0120-hardik-plymouth-fix.hook.chroot
test -x config/hooks/live/0150-hardik-installer-and-finishing.hook.chroot
grep -q 'polkit-kde-agent-1' config/package-lists/hardik.list.chroot
grep -q 'Name=Install HARDIK OS' config/hooks/live/0150-hardik-installer-and-finishing.hook.chroot
echo "HARDIK repository validation passed"
