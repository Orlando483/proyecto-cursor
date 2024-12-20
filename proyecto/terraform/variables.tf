variable "project_id" {
  description = "ID del proyecto GCP"
  type        = string
}

variable "region" {
  description = "Región de GCP"
  type        = string
}

variable "zone" {
  description = "Zona de GCP"
  type        = string
}

variable "network_name" {
  description = "Nombre de la VPC"
  type        = string
}

variable "subnet_name" {
  description = "Nombre de la subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR de la subnet"
  type        = string
}

variable "instances" {
  description = "Configuración de instancias"
  type = list(object({
    name         = string
    machine_type = string
    scheduling   = optional(object({
      preemptible          = bool
      automatic_restart    = bool
      on_host_maintenance = string
    }))
    boot_disk = object({
      image    = string
      size_gb  = number
      type     = string
    })
    additional_disks = optional(list(object({
      name     = string
      size_gb  = number
      type     = string
    })))
    service_account = optional(object({
      email  = string
      scopes = list(string)
    }))
    labels = optional(map(string))
    tags   = list(string)
    metadata = map(string)
  }))
} 