#!/bin/bash

source_centos7="rsync://ftp.sh.cvut.cz/centos/7"
dest_centos7="/repo/centos/"

source_centos8="rsync://ftp.sh.cvut.cz/centos/8"
dest_centos8="/repo/centos/"


logfile="${dest_centos7}/logs/centos_sync.log"
mkdir -p ${dest_centos7}/logs
touch ${logfile}

echo "******************************************" >> ${logfile} 2>&1
echo -n "* script started at " >> ${logfile} 2>&1
date >> ${logfile} 2>&1

#
# * sync(s) with remote rsync servers
#

rsync_opts="-rltz"


echo -n "* centos/7 rsync started at " >> ${logfile} 2>&1
date >> ${logfile} 2>&1

# do The Sync - centos7
/usr/bin/rsync ${rsync_opts} --delete --exclude='repo*' --exclude '*~tmp~*' ${source_centos7} ${dest_centos7} >> ${logfile} 2>&1

echo -n "* centos/8 rsync started at " >> ${logfile} 2>&1
date >> ${logfile} 2>&1

# do The Sync - centos8
/usr/bin/rsync ${rsync_opts} --delete --exclude='repo*' --exclude '*~tmp~*' ${source_centos8} ${dest_centos8} >> ${logfile} 2>&1

# create/update the repo data:

echo "* updating repofiles for repo os " >> ${logfile} 2>&1
createrepo --update -g /repo/centos/comps7.xml ${dest_centos7}/7/os/x86_64/ >> ${logfile} 2>&1

repos="atomic centosplus cloud configmanagement cr dotnet extras fasttrack nfv opstools paas rt sclo storage updates virt"

for repo in ${repos}; do
  echo "* updating repofiles for repo ${repo} " >> ${logfile} 2>&1
  createrepo --update ${dest_centos7}/7/${repo}/x86_64/ >> ${logfile} 2>&1
done

echo -n "* script finished at " >> ${logfile} 2>&1
date >> ${logfile} 2>&1
