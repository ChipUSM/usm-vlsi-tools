#!/bin/bash

set -ex

# Setup Sources and Bootstrap APT

echo "[INFO] Updating, upgrading and installing packages with APT"

apt -y update && apt install -y \
	ant \
	bc \
	binutils \
	build-essential \
	bzip2 \
	ca-certificates \
	cmake \
	csh \
	curl \
	gawk \
	gettext \
	git \
	gnupg2 \
	gperf \
	gpg \
	help2man \
	libfftw3-bin \
	libxaw7 \
	libgomp1 \
	libtcl \
	libxft2 \
	make \
	openssl \
	patch \
	patchutils \
	pciutils \
	tcl \
	libtcl8.6 \
	tcl-tclreadline \
	tcllib \
	texinfo \
	time \
	tzdata \
	unzip \
	wget \
	zip \
	python3-pip \
	python3-tk \
	sudo \
	gedit \
	neovim \
	tree \
	less \
	tk \
	libtk8.6 \
	libqt5core5a \
	libqt5dbus5 \
	libqt5designer5 \
	libqt5gui5 \
	libqt5multimedia5 \
	libqt5multimediawidgets5 \
	libqt5network5 \
	libqt5printsupport5 \
	libqt5sql5 \
	libqt5sql5-sqlite \
	libqt5svg5 \
	libqt5widgets5 \
	libqt5xml5 \
	libqt5xmlpatterns5 \
	libruby3.0 \
	libglu1-mesa \
	libqt5opengl5 \
	libgit2-1.1 \
	parallel \
	xterm \
	htop \
	&& rm -rf /var/lib/apt/lists/*

# tigervnc-standalone-server \
# xfce4 \
# xfce4-terminal \

update-alternatives --install /usr/bin/python python /usr/bin/python3 0	

# cd /usr/lib/llvm-15/bin
# for f in *; do rm -f /usr/bin/"$f"; \
#     ln -s ../lib/llvm-15/bin/"$f" /usr/bin/"$f"
# done

echo "[INFO] Cleaning up caches"
rm -rf /tmp/*
apt -y autoremove --purge
apt -y clean
