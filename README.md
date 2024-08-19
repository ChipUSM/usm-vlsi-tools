# Chip USM Docker Environment for IC Design and Implementation

Docker image for open source integrated circuit development.

This work is based on:

- [Johannes Kepler University (JKU) Docker Image](https://github.com/iic-jku/IIC-OSIC-TOOLS/tree/main)
- [GoCD NGSpice Agents for CICD VLSI Verification](https://github.com/akiles-esta-usado/bouquet-basic-ngspice)
- [Open Source Integrated Circuits Docker Stacks](https://github.com/ChipUSM/osic-stacks)

## Installed Tools / PDKs

| **Tool** | **Description** |
|--|--|
| ngspice    | SPICE analog and mixed-signal simulator          |
| xschem     | Schematic Editor                                 |
| magic      | Layout editor with DRC/Extraction capabilities   |
| klayout    | Layout viewer and editor for GDS                 |
| netgen     | Netlist Comparison                               |
| cvc        | Circuit validity checker                         |
| cace       | Circuit Characterization engine                  |
| gdsfactory | Python module for gds generation                 |
| glayout    | Python module for pdk-agnostic layout automation |
| pygmid     | Python module for systematic circuit sizing      |
| openvaf    | Verilog-A to OSDI compiler                       |

The image also contains `sky130A`, `gf180mcuD` and `ihp-sg13g2` pdks. The latter requires the compilation of OSDI files, which is compiled when starting a `bash` terminal.

Versions and commits are specified on the `Dockerfile`.

## Host Required Tools

### ***Makefile Windows Installation***

Use winget to install Make from the `ezwinports` project.

~~~powershell
winget install ezwinports.make
~~~

### ***XServer Installation***

This step is required to open graphical user interfaces (xschem, magic, ngspice plots, klayout).
Is tested only with [VcXsrv](https://github.com/marchaesen/vcxsrv) on Windows.

**IMPORTANT!!** is to add the installation to environment PATH to enables the use of `vcxsrv` program directly from terminal.
See [this guide](https://docs.oracle.com/cd/E83411_01/OREAD/creating-and-modifying-environment-variables-on-windows.htm#OREAD158)

1. Press Windows key and search for edit environment variable.
2. Click on `Environment Variables...`.
3. On **User Variables**, add to `Path` the installation directory as another entry.

-------------
$~$
-------------

## Makefile usage

This options opens a terminal that can be used to:

- Open GUI's from programs like xschem or klayout
- Start a Jupyter notebook/lab instance accessible from a web browser

~~~bash
# (Windows) Start the X server, this is run automatically
make xserver

# Start a shell
make start

# Start jupyter lab
# Multiple terminals could be open as tabs
make start-notebook

# Open devcontainer
# Relies on VSCode capabilities to have multiple terminals
make start-devcontainer
~~~

-------------
$~$
-------------

## DevContainer with External XServer

This should work on Windows, Linux and Mac, but it's only tested on windows.

1. Verify that Docker Desktop is running
1. Open the directory `<PROJ>/shared_xserver` with Visual Studio Code.
1. Install Devcontainer extension if it's not installed
1. Open the command palette (Use `Ctrl+Shift+P`) and run the command `Dev Containers: Reopen in Container.`.


~~~bash
# Open devcontainer
make start-devcontainer
~~~


This workflow allows the use of Visual Studio Code to interact with the container, use the git capabilities, install extensions and instantiate multiple terminals.

***Note:*** PyCharm supports devcontainers, but it seems to have troubles with graphical user interfaces. VSCode is recommended until someone takes care of PyCharm support.

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
