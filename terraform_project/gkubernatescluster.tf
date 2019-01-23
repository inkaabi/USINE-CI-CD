
resource "google_compute_network" "default"{
	name = "kubernetes-the-easy-way"
	auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "default"{
	name = "kubernetes2"
	network = "${google_compute_network.default.name}"
	ip_cidr_range = "10.240.0.0/24"
}
resource "google_compute_firewall" "internal"{
	name = "kubernetes-the-easy-way-allow-internal-communication"
	network = "${google_compute_network.default.name}"

	allow{
	   protocol = "icmp"
	}
	allow{
	   protocol = "udp"
	}
	allow{
	   protocol = "tcp"
	}
	source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]
}
resource "google_compute_firewall" "external"{
	name = "kubernetes-the-easy-way-allow-external-communication"
	network = "${google_compute_network.default.name}"

	allow{
	   protocol = "icmp"
	}
	allow{
	   protocol = "udp"
	}
	allow{
	   protocol = "tcp"
	   ports = ["22", "6443"]
	}
	source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_address" "default"{
	name = "kubernetes-the-easy-way"
	
}
resource "google_compute_instance" "controller"{
        count = 3
	name = "controller-${count.index}"
	machine_type = "${var.machine_type}"
	zone = "${var.zone}"
	can_ip_forward = true
	tags = ["kubernetes-the-easy-way", "controller"]
	boot_disk {
		initialize_params {
			image = "${var.image-boot}"
		}
	}
	network_interface {
		subnetwork = "${google_compute_subnetwork.default.name}"
		network_ip = "10.240.0.1${count.index}"
		
	}
	service_account{
		scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write","monitoring"]
	}
}
resource "google_compute_instance" "worker"{
	count = 3
	name = "worker-${count.index}"
	machine_type = "${var.machine_type}"
	zone = "${var.zone}"
	can_ip_forward = true
	tags = ["kubernetes-the-easy-way", "worker"]
	boot_disk {
		initialize_params {
			image = "${var.image-boot}"
		}
	}
	network_interface {
		subnetwork = "${google_compute_subnetwork.default.name}"
		network_ip = "10.240.0.2${count.index}"
	}
	service_account{
		scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write","monitoring"]
	}
	metadata = { 
		pod-cidr = "10.200.${count.index}.0/24"	
	}
}
