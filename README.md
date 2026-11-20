# HARDIK OS

HARDIK OS is an experimental Debian 13 (Trixie) amd64 live desktop project. The current redesign targets KDE Plasma 6 on X11 and the HARDIK black / electric-cyan visual identity.

## Build

GitHub Actions builds the ISO inside a privileged Debian Trixie container. The workflow validates shell and Python sources, checks the package list against Debian repositories, builds the live image, checks its boot catalogue and SquashFS payload, and verifies the SHA-256 checksum.

1. Open [GitHub Actions](../../actions/workflows/build-iso.yml).
2. Open the latest **Build HARDIK OS ISO** run.
3. Wait for the ISO verification step to pass.
4. Download hardik-os-0.7.0-iso.

## Desktop design

- KDE Plasma 6 with the X11 session and SDDM.
- HARDIK shield-H identity, black OLED-inspired wallpaper and electric-cyan accents.
- Custom Plymouth theme with the H logo and pulsing energy ring.
- Floating HARDIK top status bar and full-screen searchable application launcher.
- Plank floating dock and minimal Conky desktop widgets.
- KWin blur, shadows and transitions; effects can be reduced for older hardware.
- Dolphin, Kate, Okular, Gwenview, KCalc, Ark, Spectacle and MPV.
- HARDIK Control Center, HARDIK Store and HARDIK Security Centre.
- Chrome is installed by the Google Chrome hook.
- Calamares uses Debian's maintained installer modules and bootloader integration with a HARDIK dark stylesheet. Its Users page creates the account during installation.
- The live USB uses the hardik live account and automatic live login. A first-boot guard removes the live autologin configuration from an installed system before SDDM starts, so installed systems show the login screen.

## Three application package formats

- .deb: Native Debian APT/DPKG installation, including local .deb files.
- .exe / .msi: Wine compatibility layer, with 32-bit Wine support included. Windows applications, drivers, anti-cheat systems and games are not guaranteed to work.
- .apk: Optional Waydroid Android container setup from Debian Trixie backports. It requires a compatible Linux Binder kernel interface and working graphics support. Waydroid is not preinstalled because those requirements vary by hardware.

HARDIK Store also opens KDE Discover for repository and Flatpak applications. Installing a package always requires user confirmation and administrator authorization where appropriate.

## Security

The Security Centre reports actual service state for UFW, AppArmor, auditd and unattended upgrades, and offers on-demand ClamAV scans. cryptsetup is available for encryption setup, but the ISO does not silently encrypt disks. No operating system is unhackable.

## Important test status

A successful GitHub Actions build proves that the ISO was produced and passed structural checks. It does not prove that every machine boots, that Calamares installs correctly on every disk layout, that all KDE effects work with every GPU, or that every Windows/Android application is compatible. Test the ISO in a virtual machine first, then on hardware. Back up important files before attempting installation.
