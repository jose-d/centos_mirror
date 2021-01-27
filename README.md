ATM, this script will mirror centos7 into `/repo/centos` using `rsync` from CTU repository.

## Example usage

### Crontab line 

```
# crontab -l
 59    1     *   *    *        /repo/centos/sync.sh
#*     *     *   *    *        command to be executed
#-     -     -   -    -
#|     |     |   |    |
#|     |     |   |    +----- day of week (0 - 6) (Sunday=0)
#|     |     |   +------- month (1 - 12)
#|     |     +--------- day of        month (1 - 31)
#|     +----------- hour (0 - 23)
#+------------- min (0 - 59)
#
```

### Nginx snippet

```
    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /repo;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
            autoindex on;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
```

## Disk space required ATM:

### centos7

```
[root@fe1 centos]# du -sh ./7
84G     ./7
[root@fe1 centos]#
```

## TODO:
createrepo for centos8
