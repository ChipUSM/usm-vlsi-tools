# usm-vlsi-tools

Docker image for open source integrated circuit development.

This work is based on:

- [Johannes Kepler University (JKU) Docker Image](https://github.com/iic-jku/IIC-OSIC-TOOLS/tree/main)
- [GoCD NGSpice Agents for CICD VLSI Verification](https://github.com/akiles-esta-usado/bouquet-basic-ngspice)
- [Open Source Integrated Circuits Docker Stacks](https://github.com/ChipUSM/osic-stacks)

## Tool Installation

### ***Makefile Windows Installation***

I don't know how I got it but works. Running `make --version` it says `GNU Make 4.2.1. Built for Windows32`

### ***XServer Installation***

This step is required to open graphical user interfaces as Klayout.
Is tested only with [VcXsrv](https://github.com/marchaesen/vcxsrv) on Windows.

**IMPORTANT!!** is to add the installation to environment PATH to enables the use of `vcxsrv` program directly from terminal.
See [this guide](https://docs.oracle.com/cd/E83411_01/OREAD/creating-and-modifying-environment-variables-on-windows.htm#OREAD158)

1. Press Windows key and search for edit environment variable.
2. Click on `Environment Variables...`.
3. On **User Variables**, add to `Path` the installation directory as another entry.

-------------
$~$
-------------

## DevContainer with External XServer

This should work on Windows, Linux and Mac, but it's only tested on windows.

1. Verify that Docker Desktop is running
1. Open the directory `<PROJ>/shared_xserver` with Visual Studio Code.
1. Install Devcontainer extension if it's not installed
1. Open the command palette (Use `Ctrl+Shift+P`) and run the command `Dev Containers: Reopen in Container.`.


This workflow allows the use of Visual Studio Code to interact with the container, use the git capabilities, install extensions and instantiate multiple terminals.

-------------
$~$
-------------

## Makefile usage

This options opens a terminal that can be used to:

- Open GUI's from programs like xschem or klayout
- Start a Jupyter notebook/lab instance accessible from a web browser

~~~bash
# (Windows) Start the X server
make xserver

# Start a shell
make start

# Start jupyter lab
make start-notebook
~~~

Jupyter lab allows instantiate multiple terminals as tabs

-------------
$~$
-------------

## Windows Only: Using the WSL Ubuntu Xserver instance with DevContainer

This workflow does not require the use of an external Xserver, since it uses the one provided on WSL Ubuntu distributions.

**Not recommended**. This option may have a lot of bugs related with implicit configurations.

1. Verify that Docker Desktop is running
2. Open the directory `<PROJ>/shared_wsl_xserver` with Visual Studio Code
3. Install Devcontainer extension if it's not installed and run the command `Dev Containers: Reopen in Container.`. Use `Ctrl+Shift+P` to open Command Palette
4. This configuration requires to set the global variable `WSL_DISTRO`, this requires restart the system to reload the environment variables. This is only required once

**Suggestions for cleaner ways to use x11 capabilities of WSL are accepted.**
I have not figured out how to make windows reload those variables, so for now the only solution is to **restart the system**. There must be a better way
