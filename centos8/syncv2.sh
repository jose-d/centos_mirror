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

repo="OpenHPC"
singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete -x 'trilinos-*' --repoid=${repo} --download-path /repo/centos8/ohpc8 --download-metadata && echo "sync of $repo done"

repo="OpenHPC-updates"
singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete --repoid=${repo} --download-path /repo/centos8/ohpc8 --download-metadata && echo "sync of $repo done"

repo="pgdg12"
singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete --quiet --repoid=${repo} --download-path /repo/centos8 --download-metadata --downloadcomps && echo "sync of $repo done"

repo="pgdg-common"
singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete --quiet --repoid=${repo} --download-path /repo/centos8 --download-metadata --downloadcomps && echo "sync of $repo done"

repo="beegfs"
singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete --quiet --repoid=${repo} --download-path /repo/centos8 --download-metadata --downloadcomps && echo "sync of $repo done"

#oneAPI - only selective packages
inteldir="/repo/centos8/oneAPI"
mkdir -p ${inteldir}
intelpkgs="intel-oneapi-vtune intel-oneapi-advisor"

for pkg in ${intelpkgs}; do
  echo "pkg: $pkg"
  singularity exec -S /var/log -S /var/lib/dnf -S /var/cache/dnf --bind=/repo/centos8/oneAPI ${singularity_image_path} dnf install --assumeyes --disablerepo="*" --enablerepo="oneAPI" --downloadonly --downloaddir=${inteldir} ${pkg}
done
singularity exec -S /var/log -S /var/lib/dnf -S /var/cache/dnf --bind=/repo/centos8/oneAPI ${singularity_image_path} createrepo /repo/centos8/oneAPI



# 2) rsync images for installation

rsync -rv rsync://ftp.sh.cvut.cz/centos/${centos_v}/BaseOS/x86_64/os/images/ /repo/centos8/${centos_v}/baseos/images

# copy images to shared fs dir:

cp -u /repo/centos8/8-stream/baseos/images/pxeboot/vmlinuz /exports/home/users/sys/installers/c8/vmlinuz
cp -u /repo/centos8/8-stream/baseos/images/pxeboot/initrd.img /exports/home/users/sys/installers/c8/initrd.img
