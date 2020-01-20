ATM, this script will mirror centos7 into `/repo/centos` using `rsync` from CTU repository.

### Example of usage

```
[root@fe1 centos]# crontab -l
 59    1     *   *    *        /repo/centos/sync.sh
#*     *     *   *    *        command to be executed
#-     -     -   -    -
#|     |     |   |    |
#|     |     |   |    +----- day of week (0 - 6) (Sunday=0)
#|     |     |   +------- month (1 - 12)
#|     |     +--------- day of        month (1 - 31)
#|     +----------- hour (0 - 23)
#+------------- min (0 - 59)
[root@fe1 centos]#
```

### Disk space required ATM:

```
# pwd
/repo/centos
# du -sh ./7
74G     ./7
# du -sh ./8
70G     ./8
# date
Mon Jan 20 12:34:41 CET 2020
#
```

### TODO:
createrepo for centos8
