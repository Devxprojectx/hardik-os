# HARDIK OS — Integrated release target

The project is being developed toward one integrated release rather than asking the user to install or validate separate phase builds. Engineering still uses internal checkpoints so failures can be isolated; these are not separate user-facing releases.

## Target experience

- Ubuntu 24.04 LTS amd64 foundation with a branded, dark XFCE desktop and a consistent HARDIK visual identity.
- HARDIK Center for system settings, security status, updates, storage, diagnostics and maintenance.
- Graphical installer with guided disk selection, user creation, bootloader setup and optional LUKS full-disk encryption.
- Application center using trusted APT and Flatpak sources, with clear publisher/source information.
- Windows application compatibility through Wine/Bottles where supported; compatibility is not guaranteed for every EXE or game.
- Android app support through Waydroid only on supported hardware/kernel configurations; APK support is not promised on every PC.
- Recovery environment with boot repair and verified backup/restore workflows.
- Browser and daily-use utilities.
- Advanced desktop shell elements, control center, notifications, widgets and performance profiles.
- Security architecture based on measurable controls, threat modelling and automated verification.

## Implementation status

| Component | Current repository state |
|---|---|
| Ubuntu live image | Build pipeline under repair; no verified ISO yet |
| Desktop | XFCE, Thunar, Plank, Picom and dark theme defaults |
| HARDIK Center | Zenity launcher with security report, settings, file manager and terminal |
| Firewall | UFW policy configured in image; runtime activation must be verified |
| AppArmor / updates | Enablement and unattended-upgrades configuration included; runtime checks required |
| Malware scanning | ClamAV on-demand scanner package; not real-time protection |
| Encryption | cryptsetup tools included; root encryption not yet provisioned by an installer |
| Installer | Not implemented |
| App center | Not implemented |
| Wine / Waydroid | Not integrated |
| Recovery | Not implemented |
| Custom shell / AI | Not implemented |

## Security rules

1. Never describe the OS as unhackable.
2. Count a security layer only when it has a defined threat, implementation, test and observable status.
3. Distinguish installed, configured, active, inactive and unknown states.
4. Do not claim full-disk encryption unless the installed root device is actually encrypted.
5. Do not describe an on-demand scanner as real-time antivirus.
6. Do not silently add third-party repositories or run untrusted EXE/APK files as root.

## Release acceptance

A release is not called complete until the ISO is generated, checksums verify, BIOS and UEFI boot are checked, live desktop smoke tests pass, installer and recovery flows are tested, and security reports match the actual running system. VM testing remains necessary before installing on a physical PC.
