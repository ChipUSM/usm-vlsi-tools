# usm-vlsi-tools

Docker image for vlsi work


This work is based on:

- [Johannes Kepler University (JKU) Docker Image](https://github.com/iic-jku/IIC-OSIC-TOOLS/tree/main)
- [GoCD NGSpice Agents for CICD VLSI Verification](https://github.com/akiles-esta-usado/bouquet-basic-ngspice)
- [Open Source Integrated Circuits Docker Stacks](https://github.com/ChipUSM/osic-stacks)

## Why

The existing docker images for, mostly analog, integrated circuit design has a lot of overhead

- IIC OSIC TOOLS is "the" solution which has all the open source tools available. The problem is that requires a lot of space (<15GB) and most of the tools are not used, also the tools are not the latest versions.
- GoCD NgSpice Agent is limited to ngspice.

