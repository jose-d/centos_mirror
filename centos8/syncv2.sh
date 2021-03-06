#!/bin/bash

# bash coloring constants:
cRED='\e[31m'
cGREEN='\e[32m'
cRESET='\e[39m'
cYELLOW='\e[93m'

KO_string="${cRED}KO${cRESET}"
OK_string="${cGREEN}OK${cRESET}"

centos_v="8-stream"

singularity_image_path="/repo/centos8/singularity_images/centos_${centos_v}.sif"
target_path="/repo/centos8/${centos_v}"

trap ctrl_c INT

function ctrl_c() {
  echo -e "${cYELLOW}** Trapped CTRL-C → exit${cRESET}"
  exit 1
}

mkdir -p ${target_path}

# -) reposync latest packages of centos repos
quiet_flag="--quiet"
repos="appstream baseos extras powertools"
for repo in ${repos}; do
  t0=`date +%s`
  result=${KO_string}
  singularity exec -S /var/log -S /var/cache/dnf --bind=${target_path} ${singularity_image_path} dnf reposync --delete ${quiet_flag} --arch=x86_64 --arch=noarch --repoid=${repo} --download-path ${target_path} --download-metadata --downloadcomps && result=${OK_string}
  t1=`date +%s`
  t=$((t1-t0))
  echo -e "sync of repo ${repo} took ${t} s - ${result}"

done

# -) reposync openHPC and openHPC-updates

syncohpc=false
#syncohpc=true

if [ "$syncohpc" = true ]; then

  quiet_flag="--quiet"
  #quiet_flag=""

  repo="OpenHPC"
  t0=`date +%s`
  result=${KO_string}
  singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete ${quiet_flag} -x 'trilinos-*' --repoid=${repo} --download-path /repo/centos8/ohpc8 --download-metadata --downloadcomps && result=${OK_string}
  t1=`date +%s`
  t=$((t1-t0))
  echo -e "sync of repo ${repo} took ${t} s - ${result}"

  repo="OpenHPC-updates"
  t0=`date +%s`
  result=${KO_string}
  singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete ${quiet_flag} --repoid=${repo} --download-path /repo/centos8/ohpc8 --download-metadata && result=${OK_string}
  t1=`date +%s`
  t=$((t1-t0))
  echo -e "sync of repo ${repo} took ${t} s - ${result}"

else
  echo -e "sync of OpenHPC + OpenHPC-updates skipped as requested."
fi

# -) reposync epel and epel-modular

quiet_flag="--quiet"
#quiet_flag=""

repo="epel"
t0=`date +%s`
result=${KO_string}
singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete ${quiet_flag} --repoid=${repo} --download-path /repo/centos8/epel8 --download-metadata --downloadcomps && result=${OK_string}
t1=`date +%s`
t=$((t1-t0))
echo -e "sync of repo ${repo} took ${t} s - ${result}"

repo="epel-modular"
t0=`date +%s`
result=${KO_string}
singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete ${quiet_flag} --repoid=${repo} --download-path /repo/centos8/epel8 --download-metadata --downloadcomps && result=${OK_string}
t1=`date +%s`
t=$((t1-t0))
echo -e "sync of repo ${repo} took ${t} s - ${result}"

# -) reposync ondemand-web and ondemand-compute

syncondemand=false
#syncondemand=true

if [ "$syncondemand" = true ]; then

  quiet_flag="--quiet"
  quiet_flag=""

  repo="ondemand-compute"
  t0=`date +%s`
  result=${KO_string}
  singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete ${quiet_flag} --repoid=${repo} --download-path /repo/centos8/ondemand --download-metadata --downloadcomps && result=${OK_string}
  t1=`date +%s`
  t=$((t1-t0))
  echo -e "sync of repo ${repo} took ${t} s - ${result}"

  repo="ondemand-web"
  t0=`date +%s`
  result=${KO_string}
  singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete ${quiet_flag} --repoid=${repo} --download-path /repo/centos8/ondemand --download-metadata --downloadcomps && result=${OK_string}
  t1=`date +%s`
  t=$((t1-t0))
  echo -e "sync of repo ${repo} took ${t} s - ${result}"
else
  echo -e "sync of ondemand-compute + ondemand-web skipped as requested."
fi


# -) sync postgres

syncpg=false
#syncpg=true

if [ "$syncpg" = true ]; then

  repo="pgdg12"
  t0=`date +%s`
  result=${KO_string}
  singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete --quiet --repoid=${repo} --download-path /repo/centos8 --download-metadata --downloadcomps && result=${OK_string}
  t1=`date +%s`
  t=$((t1-t0))
  echo -e "sync of repo ${repo} took ${t} s - ${result}"

  repo="pgdg-common"
  t0=`date +%s`
  result=${KO_string}
  singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete --quiet --repoid=${repo} --download-path /repo/centos8 --download-metadata --downloadcomps && result=${OK_string}
  t1=`date +%s`
  t=$((t1-t0))
  echo -e "sync of repo ${repo} took ${t} s - ${result}"
else
  echo -e "sync of pgdg12 + pgdg-common skipped as requested."
fi

# -) sync beeGFS

syncbeegfs=false
#syncbeegfs=true

if [ "$syncbeegfs" = true ]; then

  repo="beegfs"
  t0=`date +%s`
  result=${KO_string}
  singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8  ${singularity_image_path} dnf reposync --newest-only --delete --quiet --repoid=${repo} --download-path /repo/centos8 --download-metadata --downloadcomps && result=${OK_string}
  t1=`date +%s`
  t=$((t1-t0))
  echo -e "sync of repo ${repo} took ${t} s - ${result}"
else
  echo -e "sync of beegfs skipped as requested."
fi

# -) sync intel

syncintel=false
#syncintel=true

if [ "$syncintel" = true ]; then

  #oneAPI - only selective packages
  inteldir="/repo/centos8/oneAPI"
  mkdir -p ${inteldir}
  intelpkgs="intel-oneapi-vtune intel-oneapi-advisor"

  for pkg in ${intelpkgs}; do
    result=${KO_string}
    singularity exec -S /var/log -S /var/lib/dnf -S /var/cache/dnf --bind=/repo/centos8/oneAPI ${singularity_image_path} dnf install --quiet --assumeyes --disablerepo="*" --enablerepo="oneAPI" --downloadonly --downloaddir=${inteldir} ${pkg} && result=${OK_string}
    echo -e "pkg: $pkg - ${result}"
  done
  singularity exec -S /var/log -S /var/lib/dnf -S /var/cache/dnf --bind=/repo/centos8/oneAPI ${singularity_image_path} createrepo --quiet ${inteldir}
else
  echo -e "sync of syncintel skipped as requested."
fi


# 2) rsync images for node deployment program

imagesdir="/repo/centos8/${centos_v}/baseos/images"

result=${KO_string}
rsync -r --no-motd rsync://ftp.sh.cvut.cz/centos/${centos_v}/BaseOS/x86_64/os/images/ ${imagesdir} && result=${OK_string}
echo -e "rsync of kernel image - ${result}"

# copy images to shared fs dir (to be used by cluser installer)

cp -u ${imagesdir}/pxeboot/vmlinuz /exports/home/users/sys/installers/c8/vmlinuz
cp -u ${imagesdir}/pxeboot/initrd.img /exports/home/users/sys/installers/c8/initrd.img
