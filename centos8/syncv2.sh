#!/bin/bash

centos_v="8-stream"

singularity_image_path="/repo/centos8/singularity_images/centos_${centos_v}.sif"
target_path="/repo/centos8/${centos_v}"

mkdir -p ${target_path}

# 1) reposync latest packages of repos

repos="appstream baseos extras powertools"
for repo in ${repos}; do

  singularity exec -S /var/log -S /var/cache/dnf --bind=${target_path} ${singularity_image_path} dnf reposync --delete --quiet --arch=x86_64 --arch=noarch --repoid=${repo} --download-path ${target_path} --download-metadata --downloadcomps && echo "sync of $repo done"

done

repo="pgdg12"
singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete --quiet --arch=x86_64 --arch=noarch --repoid=${repo} --download-path /repo/centos8 --download-metadata --downloadcomps && echo "sync of $repo done"

# 2) rsync images for installation

rsync -rv rsync://ftp.sh.cvut.cz/centos/${centos_v}/BaseOS/x86_64/os/images/ /repo/centos8/${centos_v}/baseos/images

# copy images to shared fs dir:

cp -u /repo/centos8/8-stream/baseos/images/pxeboot/vmlinuz /exports/home/users/sys/installers/c8/vmlinuz
cp -u /repo/centos8/8-stream/baseos/images/pxeboot/initrd.img /exports/home/users/sys/installers/c8/initrd.img
