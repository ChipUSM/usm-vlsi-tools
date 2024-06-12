#!/bin/bash

set -ex

# Setup Sources and Bootstrap APT

echo "[INFO] Updating, upgrading and installing packages with APT"

apt -y update
apt -y upgrade
apt -y install \
	ant \
	bc \
	binutils-gold \
	bison \
	build-essential \
	bzip2 \
	ca-certificates \
	cmake \
	csh \
	curl \
	doxygen \
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
	strace \
	tcl \
	tcl-tclreadline \
	tcllib \
	tclsh \
	texinfo \
	time \
	tzdata \
	unzip \
	wget \
	zip \
	python3-numpy \
	python3-pip

update-alternatives --install /usr/bin/python python /usr/bin/python3 0	

# cd /usr/lib/llvm-15/bin
# for f in *; do rm -f /usr/bin/"$f"; \
#     ln -s ../lib/llvm-15/bin/"$f" /usr/bin/"$f"
# done

echo "[INFO] Cleaning up caches"
rm -rf /tmp/*
apt -y autoremove --purge
apt -y clean
