#!/bin/bash
########################################################################################################
# This script resets networking on bootstrap node for RHEL8 where make clean fails to correctly cleanup#
########################################################################################################
# Remove provisioning and baremetal interfaces
echo Removing Provisioning Interface...
rm -r -f /etc/sysconfig/network-scripts/ifcfg-provisioning
echo Removing Baremetal Interface...
rm -r -f /etc/sysconfig/network-scripts/ifcfg-baremetal

# Find Primary Interface
echo Finding primary network interface...
PRIMINT=`grep baremetal /etc/sysconfig/network-scripts/*|grep BRIDGE|cut -f1 -d:`
echo Found: $PRIMINT

# Fix Primary Interface
echo Fixing primary network interface...
sed -i 's/BRIDGE=baremetal/BOOTPROTO=dhcp/g' $PRIMINT
sed -i 's/NM_CONTROLLED=no//g' $PRIMINT
cat $PRIMINT
