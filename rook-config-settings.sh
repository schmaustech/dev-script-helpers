#!/bin/bash
###########################################################################################
# This script pulls down rook rpm and configures and installs into existing OCP 4 cluster #
###########################################################################################
#Adjustable Variables #####################################################################
export ROOK_DIRECTORY="/home/bschmaus/rook"
export CNV_DIRECTORY="/home/bschmaus/cnv"
export ROOK_URL="https://people.redhat.com/~kdreyer/rhceph4-dev/x86_64"
export CIRROS_LATEST="http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img"
export SUB_ROOK_PATH="/etc/rook/ceph"
# End of Adjustable Variables #############################################################

echo Cleaning up old $ROOK_DIRECTORY...
rm -r -f $ROOK_DIRECTORY

echo Make Rook Directory: $ROOK_DIRECTORY
mkdir -p ${ROOK_DIRECTORY}/
ROOK_RPM=$(curl -s ${ROOK_URL}/ | sed -n 's/.*href="\([^"]*\).*/\1/p' | grep rook-ceph | sort | tail -n1)

echo Pull Rook RPM: $ROOK_RPM
/usr/bin/curl -sL ${ROOK_URL}/${ROOK_RPM} -o ${ROOK_DIRECTORY}/${ROOK_RPM}
cd ${ROOK_DIRECTORY}

echo Extract Rook RPM to $ROOK_DIRECTORY
/usr/bin/rpm2cpio ${ROOK_RPM} | /usr/bin/cpio -idmv

echo Set ROOK_ALLOW_MULTIPLE_FILESYSTEMS to true in $ROOK_DIRECTORY$SUB_ROOK_PATH/operator.yaml
sed -i -r -e '/ROOK_ALLOW_MULTIPLE_FILESYSTEMS/ { n ; s/false/true/ }' $ROOK_DIRECTORY$SUB_ROOK_PATH/operator.yaml

echo Set ROOK_HOSTPATH_REQUIRES_PRIVILEGED to true in $ROOK_DIRECTORY$SUB_ROOK_PATH/operator.yaml
sed -i -r -e '/ROOK_HOSTPATH_REQUIRES_PRIVILEGED/ { n ; s/false/true/ }' $ROOK_DIRECTORY$SUB_ROOK_PATH/operator.yaml

echo Set FLEXVOLUME_DIR_PATH to /etc/kubernetes/kubelet-plugins/volume/exec in $ROOK_DIRECTORY$SUB_ROOK_PATH/operator.yaml
sed -i -r -e '/FLEXVOLUME_DIR_PATH/ { s/# // }' $ROOK_DIRECTORY$SUB_ROOK_PATH/operator.yaml
sed -i -r -e '/PathToFlexVolumes/ { s/# // }' $ROOK_DIRECTORY$SUB_ROOK_PATH/operator.yaml
sed -i -r -e '/FLEXVOLUME_DIR_PATH/ { n ; s+<PathToFlexVolumes>+/etc/kubernetes/kubelet-plugins/volume/exec+ }' $ROOK_DIRECTORY$SUB_ROOK_PATH/operator.yaml


echo Set downstream image to quay.io/rhceph-dev/rook in $ROOK_DIRECTORY$SUB_ROOK_PATH/operator.yaml
sed -i 's+image: rook/ceph:master+image: quay.io/rhceph-dev/rook+g' $ROOK_DIRECTORY$SUB_ROOK_PATH/operator.yaml

echo Set downstream image to quay.io/rhceph-dev/rook in $ROOK_DIRECTORY$SUB_ROOK_PATH/toolbox.yaml
sed -i 's+image: rook/ceph:master+image: quay.io/rhceph-dev/rook+g' $ROOK_DIRECTORY$SUB_ROOK_PATH/toolbox.yaml

echo Set allowUnsupported to true in $ROOK_DIRECTORY$SUB_ROOK_PATH/cluster.yaml
sed -i 's/allowUnsupported: false/allowUnsupported: true/g' $ROOK_DIRECTORY$SUB_ROOK_PATH/cluster.yaml

echo Set hostNetwork to true in $ROOK_DIRECTORY$SUB_ROOK_PATH/cluster.yaml
sed -i 's/hostNetwork: false/hostNetwork: true/g' $ROOK_DIRECTORY$SUB_ROOK_PATH/cluster.yaml

echo Set downstream image to quay.io/rhceph-dev/rhceph-4.0-rhel-8 in $ROOK_DIRECTORY$SUB_ROOK_PATH/cluster.yaml
sed -i 's+image: ceph/ceph:v14.2.1-20190430+image: quay.io/rhceph-dev/rhceph-4.0-rhel-8+g' $ROOK_DIRECTORY$SUB_ROOK_PATH/cluster.yaml
