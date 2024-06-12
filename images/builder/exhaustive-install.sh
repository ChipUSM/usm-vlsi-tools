#!/bin/bash

set -ex

# Setup Sources and Bootstrap APT

echo "[INFO] Updating, upgrading and installing packages with APT"

apt -y update
apt -y upgrade
apt -y install \
	ant \
	autoconf \
	automake \
	autotools-dev \
	bc \
	binutils-gold \
	bison \
	build-essential \
	bzip2 \
	ca-certificates \
	cargo \
	clang-15 \
	clang-tools-15 \
	cmake \
	csh \
	curl \
	cython3 \
	debhelper \
	default-jre \
	desktop-file-utils \
	devscripts \
	doxygen \
	expat \
	flex \
	g++ \
	gawk \
	gcc \
	gdb \
	gettext \
	gfortran \
	ghostscript \
	git \
	gnat \
	gnupg2 \
	google-perftools \
	gperf \
	gpg \
	graphviz \
	gtk2-engines-pixbuf \
	help2man \
	language-pack-en-base \
	lcov \
	libasound2-dev \
	libblas-dev \
	libbz2-dev \
	libc6-dev \
	libcairo2-dev \
	libclang-common-15-dev \
	libcurl4-openssl-dev \
	libdw-dev \
	libedit-dev \
	libeigen3-dev \
	libexpat1-dev \
	libffi-dev \
	libfftw3-dev \
	libfindbin-libs-perl \
	libfl-dev \
	libgcc-11-dev \
	libgettextpo-dev \
	libgirepository1.0-dev \
	libgit2-dev \
	libglu1-mesa-dev \
	libgmp-dev \
	libgomp1 \
	libgoogle-perftools-dev \
	libgtk-3-dev \
	libgtk2.0-dev \
	libjpeg-dev \
	libjudy-dev \
	liblapack-dev \
	liblemon-dev \
	liblzma-dev \
	libmng-dev \
	libmpc-dev \
	libmpfr-dev \
	libncurses-dev \
	libnss-wrapper \
	libomp-dev \
	libopenmpi-dev \
	libpcre2-dev \
	libpcre3-dev \
	libqhull-dev \
	libqt5multimediawidgets5 \
	libqt5svg5-dev \
	libqt5xmlpatterns5-dev \
	libre2-dev \
	libreadline-dev \
	libsm-dev \
	libspdlog-dev \
	libsqlite3-dev \
	libssl-dev \
	libstdc++-11-dev \
	libsuitesparse-dev \
	libtcl \
	libtool \
	libx11-dev \
	libx11-xcb-dev \
	libxaw7-dev \
	libxcb1-dev \
	libxext-dev \
	libxft-dev \
	libxml2-dev \
	libxpm-dev \
	libxrender-dev \
	libxslt-dev \
	libyaml-dev \
	libz-dev \
	libz3-dev \
	libzip-dev \
	libzstd-dev \
	lld-15 \
	llvm-15 \
	llvm-15-dev \
	make \
	ninja-build \
	nodejs \
	npm \
	openmpi-bin \
	openssl \
	patch \
	patchutils \
	pciutils \
	pkg-config \
	python3 \
	ruby \
	ruby-dev \
	ruby-irb \
	ruby-rubygems \
	rustc \
	strace \
	swig \
	tcl \
	tcl-dev \
	tcl-tclreadline \
	tcllib \
	tclsh \
	texinfo \
	time \
	tk-dev \
	tzdata \
	unzip \
	uuid \
	uuid-dev \
	wget \
	xdot \
	xvfb \
	zip \
	zlib1g-dev \
	python3-numpy \
	python3-pip

# qt5-image-formats-plugins \
# qt5-qmake \
# qtbase5-dev \
# qtbase5-dev-tools \
# qtchooser \
# qtmultimedia5-dev \
# qttools5-dev \

# python3-aiohttp \
# python3-aiosignal \
# python3-aiosqlite \
# python3-altair \
# python3-antlr4 \
# python3-anyio \
# python3-argon2 \
# python3-arrow \
# python3-asttokens \
# python3-babel \
# python3-bleach \
# python3-cachetools \
# python3-cffi \
# python3-charset-normalizer \
# python3-click \
# python3-cmd2 \
# python3-commonmark \
# python3-coverage \
# python3-cvxopt \
# python3-defusedxml \
# python3-deprecated \
# python3-dev \
# python3-distro \
# python3-executing \
# python3-fastjsonschema \
# python3-flask \
# python3-frozenlist \
# python3-fsspec \
# python3-gdspy \
# python3-gitdb \
# python3-graphviz \
# python3-greenlet \
# python3-h11 \
# python3-httpcore \
# python3-httpx \
# python3-immutabledict \
# python3-ipykernel \
# python3-ipython \
# python3-ipywidgets \
# python3-iso8601 \
# python3-isodate \
# python3-jedi \
# python3-joblib \
# python3-json5 \
# python3-jsonschema \
# python3-jupyter-client \
# python3-jupyter-console \
# python3-jupyter-core \
# python3-jupyter-server \
# python3-jupyterlab-server \
# python3-linecache2 \
# python3-loguru \
# python3-lxml \
# python3-matplotlib \
# python3-matplotlib-inline \
# python3-mistune \
# python3-mpi4py \
# python3-nbclient \
# python3-nbconvert \
# python3-nbformat \
# python3-nest-asyncio \
# python3-netifaces \
# python3-networkx \
# python3-notebook \
# python3-numpy \
# python3-orderedmultidict \
# python3-pandas \
# python3-pandocfilters \
# python3-parso \
# python3-pexpect \
# python3-pickleshare \
# python3-pip \
# python3-plotly \
# python3-prettytable \
# python3-prometheus-client \
# python3-prompt-toolkit \
# python3-protobuf \
# python3-psutil \
# python3-ptyprocess \
# python3-pure-eval \
# python3-pybind11 \
# python3-pycparser \
# python3-pydantic \
# python3-pygame \
# python3-pyperclip \
# python3-pyqt5 \
# python3-pyqtgraph \
# python3-pytest \
# python3-qrcode \
# python3-qtconsole \
# python3-qtpy \
# python3-rdflib \
# python3-requests \
# python3-rich \
# python3-rtree \
# python3-scipy \
# python3-send2trash \
# python3-setuptools \
# python3-setuptools-rust \
# python3-shapely \
# python3-smmap \
# python3-sniffio \
# python3-stack-data \
# python3-streamlink \
# python3-tabulate \
# python3-tenacity \
# python3-terminado \
# python3-testtools \
# python3-threadpoolctl \
# python3-tinycss2 \
# python3-tk \
# python3-toolz \
# python3-tomli \
# python3-torch \
# python3-tornado \
# python3-tqdm \
# python3-traitlets \
# python3-typer \
# python3-typing-extensions \
# python3-tzlocal \
# python3-unittest2 \
# python3-uritemplate \
# python3-validators \
# python3-venv \
# python3-virtualenv \
# python3-voluptuous \
# python3-watchdog \
# python3-wcwidth \
# python3-webcolors \
# python3-wheel \
# python3-widgetsnbextension \
# python3-wrapt \
# python3-xlsxwriter \
# python3-xmltodict \
# python3-yarl \


# libgconf2-dev \
# libpcre++-dev \
# libpython3.10 \
# libwxgtk3.0-gtk3-dev \


update-alternatives --install /usr/bin/python python /usr/bin/python3 0	

# cd /usr/lib/llvm-15/bin
# for f in *; do rm -f /usr/bin/"$f"; \
#     ln -s ../lib/llvm-15/bin/"$f" /usr/bin/"$f"
# done

echo "[INFO] Cleaning up caches"
rm -rf /tmp/*
apt -y autoremove --purge
apt -y clean
