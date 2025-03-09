terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

provider "libvirt" {
  # Configuration options
}

data "template_file" "user_data" {
  template = file("cloud-init/cloud_master.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = data.template_file.user_data.rendered
  pool      = "images"
}

resource "libvirt_domain" "master_domain" {
  name = "master_kubernetes_automation"
  boot_device { dev = ["hd"] }
  cloudinit = libvirt_cloudinit_disk.commoninit.id
  vcpu      = 2
  memory    = 8098
  cpu {
    mode = "host-passthrough"
  }
  autostart = false
  graphics {
    type           = "vnc"
    listen_type    = "address"
    listen_address = "127.0.0.1"
  }
  network_interface {
    macvtap        = "enp4s0.4"
    mac            = "52:54:00:d7:58:b8"
    wait_for_lease = false
  }
  #disk {
  #  volume_id = libvirt_volume.master_kubernetes_automation.id
  #}
  disk {
    volume_id = libvirt_volume.master.id
  }

}

resource "libvirt_volume" "automationqcowexample" {
  name   = "AutomationQCOW"
  source = "./32e29d7c-c452-4100-9175-e63cf4531939-disk.qcow2"
  pool   = "images"
}


resource "libvirt_volume" "master" {
  name           = "master_automation.qcow2"
  base_volume_id = libvirt_volume.automationqcowexample.id
  pool           = "images"
}

# volumes to attach to the "workers" domains as main disk
resource "libvirt_volume" "worker" {
  name           = "worker_automation.qcow2"
  base_volume_id = libvirt_volume.automationqcowexample.id
  pool           = "images"
}

#resource "libvirt_volume" "master_kubernetes_automation" {
#         name = "master_automation"
#         pool = "disk1"
#         size = "54687091200"
#}
