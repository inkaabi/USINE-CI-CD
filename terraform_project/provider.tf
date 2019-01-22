provider "google" {
	credentials= "${file("./creds/serviceaccount.json")}"
	project    = "ines-228218"
	region     = "europe-north1-a"
}

