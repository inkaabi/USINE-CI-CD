resource "google_compute_network" "default"{
  name = "kubernetes-the-easy-way"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default"{
  name = "kubernetes3"
  network = "${google_compute_network.default.name}"
  ip_cidr_range = "10.240.0.0/24"
}
resource "google_compute_firewall" "http-nginx"{
  name = "http-nginx"
  network = "${google_compute_network.default.name}"
  target_tags = ["nginx"]
  source_ranges = ["0.0.0.0/0"] 
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
}
resource "google_compute_firewall" "ssh-nginx" {
  name = "ssh-nginx"
  network = "${google_compute_network.default.name}"
  target_tags = ["nginx"]
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}
resource "google_compute_instance" "vm_instance"{
  name = "terraform-instance-0" 
  machine_type = "n1-standard-1"
  can_ip_forward = true
  tags = ["nginx"]
  metadata_startup_script = "${file("./install-nginx.sh")}"
  zone = "asia-east2-a"
  boot_disk {
    initialize_params{
      image = "ubuntu-1804-bionic-v20181222"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.default.name}"
    network_ip = "10.240.0.10"
    access_config{
      //Ephemeral IP: 
    }
  }
  

}
output "nginx_public_ip"{
  value = "${google_compute_instance.vm_instance.network_interface.0.access_config.0.assigned_nat_ip}"
}

