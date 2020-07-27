
#Creation of Bastion host
resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "n1-standard-1"
  zone         = "us-west1-a"
  project      = var.project_id
  tags = ["bastion"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }
  network_interface {
    network = module.vpc.network_name
    subnetwork = module.vpc.subnets_names[0]
    subnetwork_project = var.project_id
    access_config {
      // Ephemeral IP
    }
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}


#Creation of web host
resource "google_compute_instance" "web" {
  name         = "web"
  machine_type = "n1-standard-1"
  zone         = "us-west1-a"
  project      = var.project_id
  tags = ["web-tier"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = module.vpc.network_name
    subnetwork = module.vpc.subnets_names[1]
    subnetwork_project = var.project_id
    }
  metadata_startup_script = "sudo apt update && sudo apt install apache2 && sudo apt install curl"
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}


#Creation of app host
resource "google_compute_instance" "app" {
  name         = "app"
  machine_type = "n1-standard-1"
  zone         = "us-west1-a"
  project      = var.project_id
  tags = ["app-tier"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = module.vpc.network_name
    subnetwork = module.vpc.subnets_names[2]
    subnetwork_project = var.project_id
    }
  
  metadata_startup_script = "sudo apt update && sudo apt install apache2 && sudo apt install curl"
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
