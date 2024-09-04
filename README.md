# Chip USM Docker Environment for IC Design and Implementation

Docker image for open source integrated circuit development.

This work is based on:

- [Johannes Kepler University (JKU) Docker Image](https://github.com/iic-jku/IIC-OSIC-TOOLS/tree/main)
- [GoCD NGSpice Agents for CICD VLSI Verification](https://github.com/akiles-esta-usado/bouquet-basic-ngspice)
- [Open Source Integrated Circuits Docker Stacks](https://github.com/ChipUSM/osic-stacks)

## Installed Tools / PDKs

| **Tool**   | **Description**                                  |
| ---------- | ------------------------------------------------ |
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

The image also contains `sky130A`, `gf180mcuD` and `ihp-sg13g2` pdks, to change between pdks use the `set_pdk` command. i.e. `set_pdk sky130A`. IHP PDK requires the compilation of OSDI files, which is performed when starting a `bash` terminal. If the compilation fails, just open another bash terminal.

Versions and commits are specified on the `Dockerfile`.

## Host Required Tools

Some of the tools are installed using terminal commands. Windows users should use Powershell.

### ***Docker***

Docker on Windows and Mac is installed with [Docker Desktop](https://www.docker.com/products/docker-desktop/). On Linux it requires a bunch of steps listed on [this website](https://docs.docker.com/desktop/install/linux-install/).

**IMPORTANT!!** Docker Desktop **should be running** while using the environment, if not, the docker commands fails with a pipe error. The app can run on background without the window opened.

![alt text](image_docker_running.png)


### ***Visual Studio Code***

One of the ways in which docker container can be used is through [Visual Studio Code](https://code.visualstudio.com/) and the [devcontainer](https://code.visualstudio.com/docs/devcontainers/containers) extension. VsCode website has an installer for the editor.

The extension can be installed with the **extension explorer** (Ctrl-Shift X), or with the following command:

~~~bash
code --install-extension ms-vscode-remote.remote-containers
~~~

### ***Git Installation***

Most important tool on any project: Control version system. A powershell command to install it is provided.

~~~powershell
winget install --id Git.Git -e --source winget
~~~

### ***Makefile Windows Installation***

Use winget to install Make from the `ezwinports` project.

~~~powershell
winget install ezwinports.make
~~~

### ***XServer Installation***

Programs that uses graphical user interfaces (xschem, magic, ngspice plots, klayout) requires an X Server running on the host machine. Linux desktops already have one. Windows and Mac requires an external server.

* On Windows: [VcXsrv](https://github.com/marchaesen/vcxsrv)
* On Mac: [XQuartz](https://www.xquartz.org/)

To install `vcxsrv` goto `releases` page and install the [21.1.10](https://github.com/marchaesen/vcxsrv/releases/tag/21.1.10) release ([direct link to 21.1.10 the installer](https://github.com/marchaesen/vcxsrv/releases/download/21.1.10/vcxsrv-64.21.1.10.0.installer.exe)).
Since a component of 21.1.13 release is [targeted as a virus](https://github.com/marchaesen/vcxsrv/issues/26) we are not going to use that version.

**IMPORTANT!!**: Add installation directory to `Path`. This allows the use of `vcxsrv` from terminal.

1. Open Control Panel and search for environment variables
2. Select the option that modifies current account
3. On **User Variables**, add the directory to `Path` user variable.
4. Reopen each terminal to reload the path.

![alt text](image_env_variables.png)

-------------
$~$
-------------

## USM VLSI Tools Usage

To clone the repo, use this command:

~~~bash
git clone --recurse --depth=1 https://github.com/ChipUSM/usm-vlsi-tools.git
~~~

Inside it, there's a `Makefile` used as a command line interface (CLI) to run programs and start the environment.


- `make start`: Starts a shell. More shells can be opened with `xterm &`
- `make start-notebook`: Start jupyter lab instance accesible from the browser. Multiple terminals could be open as tabs.
- `make start-devcontainer`: Open Visual Studio Code. Inside the editor click on `reopen in container` button, or `Ctrl-Shift-P` and then search the command.


**IMPORTANT!!** Docker Desktop **should be running** while using the environment, if not, the docker commands fails with a pipe error. The app can run on background without the window opened.

![alt text](image_docker_running.png)

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
