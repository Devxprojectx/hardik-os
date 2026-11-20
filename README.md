# HARDIK OS

HARDIK OS is an experimental Debian 13 (Trixie) amd64 live-desktop project.

## Build

GitHub Actions builds inside a Debian Trixie container, validates the package list against Trixie's repositories, and then creates the ISO.

1. Open [GitHub Actions](../../actions/workflows/build-iso.yml).
2. Run **Build HARDIK OS ISO**, or push a change to a build path.
3. Wait for ISO verification to pass.
4. Download the `hardik-os-0.6.0-iso` artifact.

## Desktop (0.6.0 redesign)

- KDE Plasma 6 desktop instead of XFCE or LXQt, using the Plasma X11 session for compatibility with virtual machines and older graphics.
- SDDM graphical login manager.
- Plymouth animated boot splash (spinner theme; custom branded splash still needs visual verification).
- Breeze Dark, Papirus icons, Inter font and HARDIK night-city wallpaper.
- Plank dock, KWin desktop effects and Conky live system monitor.
- Plasma's native clock/calendar popup replaces the old standalone GSimpleCal popup; it can be dismissed with Escape or by clicking outside.
- Dolphin file manager and Konsole terminal.
- HARDIK Center, App Center and Security Center.
- Chrome installation hook.
- Debian APT/DPKG, Discover, Flatpak and Synaptic.
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
