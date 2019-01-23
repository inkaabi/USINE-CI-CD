
variable "controller_instance"{
	type = "string"
	description = "name of VM instance"
	default = "controller-5"
}
variable "worker_instance"{
	type = "string"
	description = "name of worker node"
	default = "worker-5"
}
variable "zone"{
	type = "string"
	default = "europe-north1-a"
}
variable "address"{
	type = "string"
	default = "10.240.0.13"
}
variable "machine_type"{
	type = "string"
	default = "n1-standard-1"
}
variable "image-boot"{
	type = "string"
	default = "ubuntu-1804-bionic-v20181222"
}
variable "project_name"{
	type = "string"
	default = "ines-228218"
}
variable "region"{
	type = "string"
	default = "europe-north1-a"
}
