#!/bin/bash

# If enabling parallel execution
USE_OPENMPI=(
	--enable-mpi
	CXX=mpicxx
	CC=mpicc
	F77=mpif77
)

../configure \
	CXXFLAGS="-O3" \
	ARCHDIR="/tmp/$XYCE_NAME/xycelibs/parallel" \
	CPPFLAGS="-I/usr/include/suitesparse" \
	--enable-stokhos \
	--enable-amesos2 \
	--enable-user-plugin \
	--enable-admsmodels \
	--enable-shared \
	--enable-xyce-shareable \
	--verbose \
	--prefix="${TOOLS}/${XYCE_NAME}/${REPO_COMMIT_SHORT}"
