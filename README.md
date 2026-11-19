# HARDIK OS

Experimental Ubuntu 24.04 (Noble) amd64 live ISO.

## Build on GitHub

1. Open [Actions](../../actions/workflows/build-iso.yml).
2. Select **Build HARDIK OS ISO** and run the workflow, or push a change to a build path.
3. Download **hardik-os-0.2.0-iso** after a successful run.
4. Extract the ZIP to get the ISO.

Failed builds also upload **hardik-os-build-diagnostics** when a build log exists.

## Current development features

- Ubuntu 24.04 Noble amd64 live system.
- XFCE desktop, Thunar, Plank dock and Picom compositor.
- HARDIK OS product identity and desktop launcher.
- HARDIK Center with a live security-status report.
- Baseline UFW firewall policy, AppArmor service enablement and unattended security updates.
- APT/DPKG tools, archive utilities and disk-management tools.
- Cryptsetup support for manual encryption workflows.

## Security honesty

HARDIK OS is experimental. Security Center reports observed configuration; it does not certify the machine as secure. UFW, AppArmor and unattended-upgrades must be verified at runtime. ClamAV is an on-demand scanner, not guaranteed real-time protection. Cryptsetup availability does not mean the live or installed root filesystem is encrypted. No system is unhackable, and the requested 14-layer design is not yet complete or certified.

## Not yet implemented

A graphical installer, custom full desktop shell, integrated DEB/EXE/APK stores, Wine/Bottles integration, Waydroid and keymapper, Chrome integration, recovery environment and a complete tested 14-layer security architecture remain future work. Do not install this experimental image on a primary machine.

## Local build

On Ubuntu 24.04 amd64 with the dependencies in the workflow installed:

```bash
sudo -E bash scripts/build-iso.sh
```

Original project files are MIT licensed. Upstream software and trademarks retain their own licenses.
