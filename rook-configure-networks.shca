#!/bin/bash
############################################################################
# This script gets networks and updates rook-config-override.yaml map file #
############################################################################
export KUBECONFIG=$HOME/dev-scripts/ocp/auth/kubeconfig
# Reset rook-config-override.yaml
echo Reset Rook Config Override...
cp -f $HOME/rook-config-override.yaml.orig $HOME/rook-config-override.yaml
# Get Network interface information on bootstrap host
echo Determining Network Interfaces Networks...
PRONET=`/usr/bin/ipcalc -n "$(/usr/sbin/ip -o addr show|grep provisioning|grep -v inet6|awk {'print $4'})"|cut -f2 -d=`
PROCIDR=`/usr/bin/ipcalc -p "$(/usr/sbin/ip -o addr show|grep provisioning|grep -v inet6|awk {'print $4'})"|cut -f2 -d=`
BARNET=`/usr/bin/ipcalc -n "$(/usr/sbin/ip -o addr show|grep baremetal|grep -v inet6|awk {'print $4'})"|cut -f2 -d=`
BARCIDR=`/usr/bin/ipcalc -p "$(/usr/sbin/ip -o addr show|grep baremetal|grep -v inet6|awk {'print $4'})"|cut -f2 -d=`
PUBLIC=$BARNET/$BARCIDR
CLUSTER=$PRONET/$PROCIDR
echo Public Net: $PUBLIC 
echo Cluster Net: $CLUSTER
echo Change rook-config-override to correct nets in $HOME/rook-config-override.yaml...
#Adjust rook-config-override.yaml public and cluster networks based on above information
sed -i "s+0.0.0.0+${PUBLIC}+g" $HOME/rook-config-override.yaml
sed -i "s+1.1.1.1+${CLUSTER}+g" $HOME/rook-config-override.yaml
echo -------------------------------------------------------------
cat $HOME/rook-config-override.yaml
echo -------------------------------------------------------------
echo Completed Update of $HOME/rook-config-override.yaml...
echo
echo Create in OCP Rook Config Override...
oc create namespace openshift-storage
oc create -f $HOME/rook-config-override.yaml
echo Creates completed!
echo Validate Rook Override In Place...
oc get configmap -n openshift-storage
oc describe configmap -n openshift-storage
echo All tasks complete!!!
