#!/bin/bash

set -e

usermod -u $USER_ID designer
usermod -g $USER_GROUP designer

#/bin/bash --rcfile /home/designer/.bashrc
#/bin/bash --login

if [ "$1" != "" ]; then
    /bin/bash -c $1
else
    /bin/bash
fi