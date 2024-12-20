terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  # Opcional: Configurar backend para estado remoto
  # backend "gcs" {
  #   bucket = "mi-bucket-terraform-estado"
  #   prefix = "terraform/state"
  # }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Red VPC
resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.vpc_network.id
  region        = var.region
}

# Reglas de firewall
resource "google_compute_firewall" "allow_web" {
  name    = "allow-web"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
  description   = "Allow HTTP and HTTPS traffic"
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
  description   = "Allow SSH access"
}

# Instancias
resource "google_compute_instance" "vm_instances" {
  for_each = { for idx, instance in var.instances : instance.name => instance }

  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = var.zone

  dynamic "scheduling" {
    for_each = each.value.scheduling != null ? [each.value.scheduling] : []
    content {
      preemptible       = scheduling.value.preemptible
      automatic_restart = scheduling.value.automatic_restart
      on_host_maintenance = scheduling.value.on_host_maintenance
    }
  }

  boot_disk {
    initialize_params {
      image = each.value.boot_disk.image
      size  = each.value.boot_disk.size_gb
      type  = each.value.boot_disk.type
    }
  }

  dynamic "attached_disk" {
    for_each = each.value.additional_disks != null ? each.value.additional_disks : []
    content {
      source = google_compute_disk.additional["${each.key}-${attached_disk.value.name}"].self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      // Ephemeral public IP
    }
  }

  dynamic "service_account" {
    for_each = each.value.service_account != null ? [each.value.service_account] : []
    content {
      email  = service_account.value.email
      scopes = service_account.value.scopes
    }
  }

  metadata = each.value.metadata
  labels   = each.value.labels != null ? each.value.labels : {}
  tags     = each.value.tags

  allow_stopping_for_update = true
}

# Discos adicionales
resource "google_compute_disk" "additional" {
  for_each = {
    for disk in flatten([
      for instance in var.instances : [
        for disk in(instance.additional_disks != null ? instance.additional_disks : []) : {
          key = "${instance.name}-${disk.name}"
          value = merge(disk, {
            instance_name = instance.name
          })
        }
      ]
    ]) : disk.key => disk.value
  }

  name = each.value.name
  type = each.value.type
  size = each.value.size_gb
  zone = var.zone
} 