# HARDIK OS implementation roadmap

This first milestone is an experimental Ubuntu 24.04 live-image pipeline, not the complete OS specification.

| Area | Current state | Next milestone |
|---|---|---|
| Boot | live-build ISO pipeline | Boot-test in QEMU and on test USB |
| Desktop | XFCE, Plank, Picom, themes | Custom launcher, widgets, notifications and window behavior |
| File manager | Thunar | Hardik-branded workflows and installer dispatch |
| DEB store | APT/DPKG tools | Branded frontend |
| EXE store | Not integrated | Bottles/Wine prefixes and installer UI |
| APK store | Not integrated | Waydroid integration and licensing review |
| Keymapper | Not implemented | Waydroid-only input mapping |
| Chrome | Not included yet | Official Google distribution integration |
| Security Center | Not implemented | Runtime probes and honest status reporting |
| 14 security layers | Not complete/certified | Threat model, implementation and tests per layer |
| Installer | Not included yet | Integrate and test Ubuntu installer |
| Recovery | Not included yet | Recovery boot and restore flow |

A package being installed does not prove its protection is active. Installing UFW does not enable the firewall, and installing cryptsetup does not encrypt the root filesystem. Never claim the OS is unhackable.
