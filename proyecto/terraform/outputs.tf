output "instances_details" {
  description = "Detalles de las instancias creadas"
  value = {
    for name, instance in google_compute_instance.vm_instances : name => {
      name           = instance.name
      internal_ip    = instance.network_interface[0].network_ip
      external_ip    = instance.network_interface[0].access_config[0].nat_ip
      machine_type   = instance.machine_type
      zone           = instance.zone
      tags          = instance.tags
      labels        = instance.labels
      disks         = {
        boot_disk     = instance.boot_disk[0].initialize_params[0].image
        attached_disks = [
          for disk in instance.attached_disk : disk.source
        ]
      }
    }
  }
}

output "network_info" {
  description = "Información de la red"
  value = {
    vpc_name    = google_compute_network.vpc_network.name
    vpc_id      = google_compute_network.vpc_network.id
    subnet_name = google_compute_subnetwork.subnet.name
    subnet_cidr = google_compute_subnetwork.subnet.ip_cidr_range
    region      = google_compute_subnetwork.subnet.region
  }
}

output "firewall_rules" {
  description = "Reglas de firewall creadas"
  value = {
    web = {
      name = google_compute_firewall.allow_web.name
      allowed_ports = google_compute_firewall.allow_web.allow[0].ports
    }
    ssh = {
      name = google_compute_firewall.allow_ssh.name
      allowed_ports = google_compute_firewall.allow_ssh.allow[0].ports
    }
  }
} 