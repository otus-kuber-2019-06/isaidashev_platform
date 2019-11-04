resource "google_compute_instance" "app" {
  count        = "${var.counts_node}"
  name         = "${var.name}${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["kubernetes"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {
    }
  }

  metadata = {
    #Добавление публичного ключа к инстансу
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}


