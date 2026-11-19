# HARDIK OS

Experimental Ubuntu 24.04 (Noble) amd64 live ISO build pipeline.

## Build on GitHub
1. Open Actions, select Build HARDIK OS ISO, then Run workflow.
2. Wait for the build to finish.
3. Download the hardik-os-iso artifact from the run summary.
4. Extract the ZIP to get the ISO.

A push to main that changes config/, scripts/, this workflow, or README also starts a build.

## Current milestone
XFCE desktop, Thunar, Plank dock, Picom compositor, cyan/dark branding and selected system tools. The ISO is experimental and must be boot-tested in a VM before physical use.

## Not yet implemented
This is not yet the full master specification. The graphical installer, custom desktop shell, complete store integrations, Waydroid keymapper, Chrome, Security Center, verified 14-layer security implementation and recovery environment remain future work. No fake security statuses or unhackable claims.

## Runner storage
GitHub-hosted runner disk capacity is a constraint for building full desktop images. The workflow attempts cleanup but may still fail from insufficient disk space.

## Local build
On Ubuntu 24.04 amd64 with live-build dependencies installed, run: sudo bash scripts/build-iso.sh

Original project files are MIT licensed. Upstream software and trademarks retain their own licenses.
