#!/bin/bash

set -e

# https://ioflood.com/blog/usermod-linux-command/#:~:text=Changing%20a%20User's%20Home%20Directory&text=Here's%20how%20you%20can%20do,new%2Fhome%2Fdir'.
# groupmod -n designer ubuntu
# usermod -l designer ubuntu
# usermod -m -d /home/designer designer

useradd -m designer

echo "designer ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/designer

# usermod -u $USER_ID designer
# usermod -g $USER_GROUP designer

#/bin/bash --rcfile /home/designer/.bashrc
#/bin/bash --login
