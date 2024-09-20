#!/bin/bash

set -ex

apt -y update

apt install -y  --no-install-recommends locales
sed -i -e "s/# $LC_ALL UTF-8/$LC_ALL UTF-8/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=$LANG

BUILD_DEPS=(
    binutils
	build-essential
	libpython3-dev
	# patch
	# patchutils
	# automake
	# autoconf
	# pkg-config
)

UTILITY_DEPS=(
	sudo
	git
	xterm
	make
	gawk
	tree
	less
	htop
	parallel
	openssl
	bzip2
	zip
	unzip
	unrar
	curl
	wget
	python3-pip
	neovim
	nano
	gedit
)

XSCHEM_DEPS=(
	libglu1-mesa
	libxpm4
	libtcl8.6
	libtk8.6
	libcairo2
	tcl-tclreadline
)


MAGIC_DEPS=(
	tk
	libglu1-mesa
	libcairo2
)

NGSPICE_DEPS=(
	libfftw3-bin
	libxaw7
	libxft2
)

KLAYOUT_DEPS=(
	libqt5core5a
	libqt5designer5
	libqt5gui5
	libqt5multimedia5
	libqt5multimediawidgets5
	libqt5network5
	libqt5opengl5
	libqt5printsupport5
	libqt5sql5
	libqt5svg5
	libqt5widgets5
	libqt5xml5
	libqt5xmlpatterns5
	libgit2-1.1
	libruby3.0
	libqt5dbus5
)

ORFS_DEPS=(
	time
)

DEPS=(
	"${BUILD_DEPS[@]}"
	"${UTILITY_DEPS[@]}"
	"${XSCHEM_DEPS[@]}"
	"${MAGIC_DEPS[@]}"
	"${NGSPICE_DEPS[@]}"
	"${KLAYOUT_DEPS[@]}"
	"${ORFS_DEPS[@]}"
)

apt install -y --no-install-recommends "${DEPS[@]}"


# Old dependencies
# 	ant \
# 	bc \
# 	ca-certificates \
# 	gettext \
# 	help2man \
# 	libgomp1 \
# 	libtcl \
# 	pciutils \
# 	tcl \
# 	tcllib \
# 	texinfo \
# 	tzdata \
# 	python3-tk \
# 	libqt5sql5-sqlite \
# 	cmake \
# 	csh \
# 	gnupg2 \
# 	gperf \
# 	gpg \
# 	time \
# 	gedit

rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
apt -y autoremove --purge
apt -y clean

# tigervnc-standalone-server \
# xfce4 \
# xfce4-terminal \

update-alternatives --install /usr/bin/python python /usr/bin/python3 0	

# cd /usr/lib/llvm-15/bin
# for f in *; do rm -f /usr/bin/"$f"; \
#     ln -s ../lib/llvm-15/bin/"$f" /usr/bin/"$f"
# done
