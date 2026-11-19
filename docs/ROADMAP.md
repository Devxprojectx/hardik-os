# HARDIK OS implementation roadmap

The project is moving from a bare ISO foundation into an integrated desktop. Each feature must be built and tested as a real function, not a visual placeholder.

| Area | Current state | Remaining work |
|---|---|---|
| Build pipeline | Ubuntu Noble live-build, explicit Noble security archive, failure-log artifact | Successful build, ISO boot test, automated smoke tests |
| Desktop | XFCE, Thunar, Plank, Picom, dark theme packages | Custom shell, panel, widgets, notifications and polished settings |
| HARDIK Center | Launcher and runtime security report | System information, update UI, backup and recovery controls |
| Security | UFW policy, AppArmor and unattended-upgrades enabled in image | Runtime verification, threat model, hardening and tests for each layer |
| Encryption | cryptsetup tools included | Installer-driven LUKS full-disk encryption and recovery-key workflow |
| DEB store | APT/DPKG base | Branded package frontend and safe repository policy |
| EXE support | Not integrated | Wine/Bottles workflow with sandboxing and compatibility checks |
| APK support | Not integrated | Waydroid integration, hardware compatibility and licensing review |
| Keymapper | Not implemented | Waydroid-only input mapping |
| Browser | Firefox not forced into image; Chrome not included | Browser choice and official Chrome integration |
| Installer | Not included | Integrate and test a supported Ubuntu installer |
| Recovery | Not included | Recovery boot, backup validation and restore flow |

## Security engineering rules

1. Never call HARDIK OS unhackable.
2. A package being installed does not prove its service is active.
3. Report observed status as active, inactive, unavailable or unknown.
4. Do not claim root encryption unless the actual root block-device chain is encrypted.
5. Do not claim malware protection from the presence of a scanner alone.
6. Define a threat model and automated test for every security control before counting it as one of the proposed 14 layers.

## Delivery order

1. Make the image build repeatably and preserve diagnostics on failure.
2. Build the desktop control center and real status probes.
3. Add installer and recovery only after the live desktop is stable.
4. Integrate application formats through maintained upstream projects.
5. Run VM smoke tests and publish checksums for every release.
