provider "google" {
	credentials= "${file("./creds/serviceaccount.json")}"
	project    = "${var.project_name}"
	region     = "${var.region}"
	zone 	   = "default"
}

