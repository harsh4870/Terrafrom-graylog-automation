variable "gcp_project" {
  description = "The project ID to manage the Cloud SQL resources"
  type        = string
  default     = "project-id"
}

// required
variable "gcp_region" {
  description = "The region of the Cloud SQL resources"
  type        = string
  default     = "us-central1"
}

// required
variable "ssh_file_path" {
  description = "SSH file path"
  type        = string
  default     = "~/.ssh/google_compute_engine"
}

variable "instance_name" {
  description = "GCP instance name"
  default     = "staging-dev-graylog"
}


variable "machine_type" {
  description = "GCP machine type"
  default     = "n1-standard-1"
}

variable "image" {
  description = "image to build instance from in the format: image-family/os. See: https://cloud.google.com/compute/docs/images#os-compute-support"
  default     = "ubuntu-os-cloud/ubuntu-1804-lts"
}


# Optional variables
variable "os_pd_ssd_size" {
  description = "Size of OS disk in GB"
  default     = "10"
}

variable "ssh_public_file_ext" {
  description = "SSH public file extension"
  default     = ".pub"
}

variable "graylog_pd_ssd_size" {
  description = "Size of Graylog disk in GB"
  default     = "30"
}

variable "domain_name" {
  description = "Graylog accessible at or expose to internet"
  default     = "logs.example.io"
}

variable "dns_zone" {
  description = "GCP cloud DNS zone to set A record"
  default     = "zonename"
}