# HARDIK OS — Integrated release plan

The user-facing goal is one integrated operating system. Engineering checkpoints are internal validation gates, not separate user releases.

## Target desktop
- Debian 13 Trixie amd64.
- Dark XFCE desktop, custom night-city wallpaper, Arc-Dark and Papirus-Dark.
- Plank dock, Picom, Conky live monitor and GSimpleCal calendar.
- Thunar, XFCE Terminal, Chrome and HARDIK Center.
- APT/DPKG, Synaptic and Flatpak.
- Wine/Winetricks; not every Windows app or game is compatible.
- Optional Waydroid only on supported kernel/hardware.

## Implementation status
| Area | Status |
|---|---|
| Debian live ISO | Being rebuilt; not yet verified |
| Desktop appearance | Theme, wallpaper and widgets included; VM testing required |
| App Center | APT/Flatpak front-end and Synaptic launcher |
| Chrome | Network download/install hook |
| Security baseline | UFW, AppArmor, unattended-upgrades, ClamAV, Firejail and auditd |
| Graphical installer | Not implemented |
| Automatic full-disk encryption | Not implemented |
| Recovery wizard | Not implemented |
| AI assistant | Not implemented |

## Security rules
1. Never describe HARDIK OS as unhackable.
2. Count a protection layer only when threat, implementation, test and observable status are defined.
3. Distinguish installed, configured, active, inactive and unknown.
4. Do not claim full-disk encryption unless the installed root device is encrypted.
5. Do not describe an on-demand scanner as real-time antivirus.
6. Do not run downloaded EXE/APK files as root.

## Release acceptance
The ISO must be generated, checksums must verify, BIOS and UEFI boot must be tested, the live desktop must pass smoke tests, and package sources must point to Debian Trixie. Installer and recovery features require separate tests before being advertised.
