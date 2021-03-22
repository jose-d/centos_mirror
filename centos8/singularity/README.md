## build

`sudo singularity build c8stream.sif container.def`

## run

(to get centos8 shell with working dnf & friends)

`singularity exec -S /var/log -S /var/cache/dnf --bind=/repo/centos8/8.3.2011 /repo/centos8/singularity_images/centos_8.3.2011.sif bash`

