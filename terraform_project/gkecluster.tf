resource "google_compute_instance" "VM-INSTANCE"{
	name = "${var.controller_instance}"
	machine_type = "${var.machine_type}"
	zone = "${var.zone}"
	boot_disk {
		initialize_params {
			image = "${var.image-boot}"
		}
	}
	network_interface {
		network = "default"
		
	}
}
