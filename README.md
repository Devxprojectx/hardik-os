# HARDIK OS

HARDIK OS is an experimental Debian 13 (Trixie) amd64 live-desktop project.

## Build
GitHub Actions builds inside a Debian Trixie container, validates the package list against Trixie's repositories, and then creates the ISO.

1. Open [GitHub Actions](../../actions/workflows/build-iso.yml).
2. Run **Build HARDIK OS ISO**, or push a change to a build path.
3. Wait for ISO verification to pass.
4. Download the `hardik-os-0.5.0-iso` artifact (artifact naming will be updated with the next release).

## Desktop (0.6.0 redesign)
- LXQt desktop instead of XFCE, with PCManFM-Qt and QTerminal.
- SDDM graphical login manager.
- Plymouth animated boot splash using the spinner theme.
- Dark Arc GTK theme, Papirus icons, Inter font and HARDIK night-city wallpaper.
- Plank dock, Picom window effects and Conky live system monitor.
- HARDIK Center, App Center and Security Center.
- Chrome installation hook.
- Debian APT/DPKG, Flatpak, GNOME Software and Synaptic.
- Wine/Winetricks and optional Waydroid setup (compatibility varies).
- UFW, AppArmor, unattended-upgrades, ClamAV, Firejail, auditd and disk utilities.

## Status
This is an experimental live image. A successful ISO build does not prove all hardware, desktop effects, Wi-Fi firmware, application compatibility or installation workflows work on every PC. Test in a virtual machine first.

The ISO currently boots a live session; a finished graphical installer, automatic full-disk encryption, recovery wizard and AI assistant are not yet implemented. cryptsetup being installed does not mean a disk is encrypted, ClamAV is an on-demand scanner, and no operating system is unhackable.

## Local build
On Debian 13 amd64 with workflow dependencies installed:

```bash
sudo bash scripts/build-iso.sh
```
