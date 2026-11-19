# HARDIK OS

HARDIK OS is an experimental Ubuntu 24.04 LTS (Noble) amd64 desktop operating-system project, targeting one integrated release.

## Build on GitHub

1. Open [Actions](../../actions/workflows/build-iso.yml).
2. Run **Build HARDIK OS ISO**, or push a change to a build path.
3. After a successful run, download **hardik-os-0.3.0-iso**.
4. Extract the ZIP to get the ISO.

The workflow validates shell syntax, the Ubuntu package list, the security repository, the ISOLINUX inputs and the embedded legacy gfxboot archive before building. Failed runs upload **hardik-os-build-diagnostics** when logs exist.

## Current implemented foundation

- Ubuntu 24.04 Noble amd64 live-system build configuration.
- XFCE desktop, Thunar, Plank dock and Picom compositor.
- HARDIK OS 0.3.0 branding, desktop launcher and HARDIK Center.
- Security-status reporting, UFW baseline policy, AppArmor enablement and unattended security-update configuration.
- APT/DPKG, archive and disk-management tools.
- cryptsetup utilities for manual encryption workflows.

## Important status

The repository is still an experimental live-system foundation. A successful ISO build does not by itself prove that BIOS/UEFI boot, the live desktop or installation works on every PC.

The graphical installer, integrated app center, Wine/Bottles, Waydroid, recovery environment, custom shell and AI assistant are not yet implemented. They remain part of the integrated release target, not features to assume are present.

Security status is reported from the running system and is not a certification. ClamAV is an on-demand scanner. cryptsetup being installed does not mean the root disk is encrypted. No operating system is unhackable.

Do not install experimental builds on a primary machine. Validate them in a virtual machine first.

## Local build

On Ubuntu 24.04 amd64 with the dependencies listed in the workflow:

```bash
sudo -E bash scripts/build-iso.sh
```

Original project files are MIT licensed. Upstream software and trademarks retain their own licenses.
