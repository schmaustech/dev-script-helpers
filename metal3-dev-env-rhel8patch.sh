#!/bin/bash
################################################################################
#This script patches metal3-dev-env used in script 02 by dev-scripts for RHEL8#
################################################################################
echo Patching script 02_configure_host.sh to use https://github.com/metal3-io/metal3-dev-env/pull/19
 
sed -i '/^sync_repo_and_patch metal3-dev-env https.*/a git config --global user.email "bschmaus@domain.com"\ngit config --global user.name "BJS"\ncd /opt/dev-scripts/metal3-dev-env/\n/usr/bin/curl -
L https://github.com/metal3-io/metal3-dev-env/pull/19.patch | git am\ncd ~/dev-scripts' /home/bschmaus/dev-scripts/02_configure_host.sh
