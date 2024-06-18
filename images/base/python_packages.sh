#!/bin/bash

set -ex

pip install uv

python -m uv pip install --system --strict --compile-bytecode --no-cache \
    "numpy<2" \
    gdsfactory \
    glayout \
    cace \
    pandas \
    ojson \
    networkx \
    pytest \
    scipy \
    gdstk \
    gdspy \
    pyspice \
    volare \
    spyci \
    siliconcompiler \
    jupyter \
    jupyterlab \
    ipython \
    ipykernel \
    ipywidgets