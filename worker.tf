data "template_file" "user_data_worker1" {
	template = file("cloud-init/cloud_worker.cfg")
}

resource "libvirt_cloudinit_disk" "commoninitworker1" {
               	name           = "commoninitworker1.iso"
		user_data      = data.template_file.user_data_worker1.rendered
		pool = "images"
}

resource "libvirt_domain" "worker1_domain" {
	name = "worker1_kubernetes_automation"
		boot_device { dev = ["hd" ] }
	cloudinit = libvirt_cloudinit_disk.commoninitworker1.id
		vcpu   = 2
		memory = 2048
		cpu {
			mode = "host-passthrough"
		}
	autostart = false
		graphics{
			type="vnc"
				listen_type="address"
				listen_address="127.0.0.1"
		}
	network_interface {
		macvtap = "enp4s0.4"
			mac            = "52:54:00:d7:58:ba"
			wait_for_lease = false
	}
	disk {
		volume_id = libvirt_volume.worker1.id
	}

}

# volumes to attach to the "workers" domains as main disk
resource "libvirt_volume" "worker1" {
	name           = "worker_automation.qcow2"
		base_volume_id = libvirt_volume.automationqcowexample.id
		pool = "images"
}
