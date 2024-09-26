#!/bin/bash

set -ex

apt -y update
apt install -y  --no-install-recommends locales apt-utils
sed -i -e "s/# $LC_ALL UTF-8/$LC_ALL UTF-8/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=$LANG

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
	meson \
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
	librsvg2-2 \
	librsvg2-common \
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
	libqt5charts5-dev \
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
	python3-pip \
	qt5-qmake \
	qtbase5-dev \
	qtbase5-dev-tools \
	qtchooser \
	qttools5-dev


update-alternatives --install /usr/bin/python python /usr/bin/python3 0	

# cd /usr/lib/llvm-15/bin
# for f in *; do rm -f /usr/bin/"$f"; \
#     ln -s ../lib/llvm-15/bin/"$f" /usr/bin/"$f"
# done

rm -rf /tmp/*
apt -y autoremove --purge
apt -y clean

pip install uv

uv pip install --system --strict --compile-bytecode --no-cache \
	"numpy<2" \
	volare==0.18.1 \
	docopt \
	click