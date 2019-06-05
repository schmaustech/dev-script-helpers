#!/bin/bash
####################################################
# This script patches 10_deploy_rook.sh            #
####################################################
echo Updating 10_deploy_rook.sh script...
# Set hostNetwork to true 
sed -i '/^oc create -f cluster-modified.yaml/i sed -i '\''s/hostNetwork: false/hostNetwork: true/g\'\'' cluster-modified.yaml' $HOME/dev-scripts/10_deploy_rook.sh
echo Set hostNetwork to true complete!
# Modify creates to apply
sed -i 's/^oc create -f common-modified.yaml/oc apply -f common-modified.yaml/g' $HOME/dev-scripts/10_deploy_rook.sh
sed -i 's/^oc create -f operator-openshift-modified.yaml/oc apply -f operator-openshift-modified.yaml/g' $HOME/dev-scripts/10_deploy_rook.sh
sed -i 's/^oc create -f cluster-modified.yaml/oc apply -f cluster-modified.yaml/g' $HOME/dev-scripts/10_deploy_rook.sh
echo Modified oc creates to oc apply complete!
