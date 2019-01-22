
variable "controller_instance"{
	type = "string"
	description = "name of VM instance"
	default = "controller-4"
}
variable "zone"{
	type = "string"
	default = "europe-north1-a"
}
variable "address"{
	type = "string"
	default = "10.240.0.13"
}
