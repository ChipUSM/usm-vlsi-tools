# usm-vlsi-tools

Docker image for open source integrated circuit development.

This work is based on:

- [Johannes Kepler University (JKU) Docker Image](https://github.com/iic-jku/IIC-OSIC-TOOLS/tree/main)
- [GoCD NGSpice Agents for CICD VLSI Verification](https://github.com/akiles-esta-usado/bouquet-basic-ngspice)
- [Open Source Integrated Circuits Docker Stacks](https://github.com/ChipUSM/osic-stacks)

## Setup

More work is required to check all the possible uses cases of this docker image, since it's currently validated with 

## VSCode DevContainer

The developer's favorite. This has been tested on windows.

### Dependencies

- WSL: A linux virtual machine optimized for windows interoperability.
- Ubuntu Distro: It has support for X11 graphical interfaces.
- Docker Desktop: Graphical User Interface to handle docker resources.


### Procedure

1. Verify that Docker Desktop is running
2. Clone the repo 
3. Go to shared directory
4. Open Vscode 
5. Install Devcontainer extension if it's not installed and run the command `Dev Containers: Reopen in Container.`. Use `Ctrl+Shift+P` to open Command Palette.

~~~bash
git clone --depth=1 https://github.com/ChipUSM/usm-vlsi-tools.git
cd usm-vlsi-tools/shared
code .
# Install DevContainer Extension
# Ctrl-Shift-p > Dev Containers: Reopen in Container
~~~

This devcontainer configuration uses the X11 interface that some wsl distros have.

### Troubleshoot

> Fails to reopen on container

The first time the devcontainer is run, it executes the script "set-wsl-distro.ps1" which updates the environment variables with WSL_DISTRO.

I have not figured out how to make windows reload those variables, so for now the only solution is to **restart the system**. Then it should work fine.

**Suggestions for cleaner ways to use x11 capabilities of WSL are accepted.**
