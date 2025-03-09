Simple solution for deploying kubernetes on Rocky 9.5.
With 1 master, 2 workers.
Please create an SSH key get the pub key and put it on the cloud init files.
Please also change the ip and interface to your desired.should work.

Create just a standard QCOW2 deployment on your Rocky 9.5 using composer-cli. for the qcow2 .

Example blueprint file:

name = "cloud-init-blueprint"
description = "LONG FORM DESCRIPTION TEXT"
version = "0.0.1"
modules = []
groups = []
distro = ""

[[customizations.user]]
name = "admin"
password = "admin"
groups = ["users", "wheel"]

[[customization.disk.partitions]]
type = "plain"
label = "root"
mountpoint = "/"
fs_type = "xfs"
minsize = "50 GiB"


Research this link:

https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/composing_a_customized_rhel_system_image/creating-system-images-with-composer-command-line-interface_composing-a-customized-rhel-system-image

