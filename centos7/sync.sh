#!/bin/bash

#source_centos7="rsync://ftp.sh.cvut.cz/centos/7" #bad and old?
source_centos7="rsync://mirror.it4i.cz/centos/7"
dest_centos7="/repo/centos/"

formatted_date() {
 /usr/bin/date "+%F, %T"
}

fix_perm() {
  find -L ${1} -type d -exec chmod 755 {} +
  find -L ${1} -type f -exec chmod 644 {} +
}

echo "******************************************"
echo -n "* script started at "
formatted_date

# * sync(s) with remote rsync servers

#rsync_opts="-rltzv"	# if you're curious, uncomment this..
rsync_opts="-rtzL"

echo -n "* centos/7 rsync started at "
formatted_date

# do The Sync - centos7
mkdir -p ${dest_centos7}
cmd="/usr/bin/rsync -4 ${rsync_opts} --delete --exclude='.repodata' --exclude '*~tmp~*' --exclude 'atomic' --exclude 'repodata' ${source_centos7} ${dest_centos7}"
echo ${cmd}
eval ${cmd}

echo "* updating repofiles for repo os "
cleanedpath=$(readlink -m ${dest_centos7}/7/os/x86_64/)
# we need to specify the -g to have kickstart installs working!
createrepo --update -g /repo/centos/comps7.xml ${cleanedpath}

repos="centosplus cloud configmanagement cr dotnet extras fasttrack nfv opstools paas rt sclo storage updates virt"

for repo in ${repos}; do
  echo "* updating repofiles for repo ${repo} "
  cleanedpath=$(readlink -m ${dest_centos7}/7/${repo}/x86_64/ )
  echo " cleaned path: $cleanedpath"
  createrepo --update ${cleanedpath}
done

# fix permissions aka give read to nginx..
fix_perm '/repo/centos/7'

echo -n "* script finished at "
formatted_date
