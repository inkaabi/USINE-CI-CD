resource "google_compute_instance" "VM-INSTANCE"{
	name = "${var.controller_instance}"
	machine_type = "n1-standard-1"
	zone = "${var.zone}"
	boot_disk {
		initialize_params {
			image = "ubuntu-1804-bionic-v20181222"
		}
	}
	network_interface {
		network = "default"
		
	}
}
