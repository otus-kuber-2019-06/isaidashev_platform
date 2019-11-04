# Google provider settings
provider "google" {
  version = "~> 2.5"
  credentials = "${file("~/upheld-garage-255412-f5492c9b0f7c.json")}"
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source          = "../modules/node"
  name            = "${var.name}"
  counts_node     = "${var.counts_node}"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  disk_image      = "${var.disk_image}"
}
