

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

variable "user" {
  default = "appuser"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-d"
}
