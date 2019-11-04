variable project {
  description = "Project ID"
  default     = "upheld-garage-255412"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable "name" {
  description = "name nodes"
}

variable "counts_node" {
  description = "counts nods"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
  default     = "~/.ssh/appuser.pub"
}

variable disk_image {
  description = "Disk image"
  default     = "ubuntu-1804-lts"
}

variable private_key {
  description = "Path to private key for provisioner"
}

variable "user" {
  default = "appuser"
}

variable zone {
  description = "Zone"
  default     = "us-west1-c"
}
