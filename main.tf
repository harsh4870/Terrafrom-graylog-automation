
data "google_compute_zones" "available" {
  region  = var.gcp_region
  project = var.gcp_project
}

#Add A record to DNS zones
#resource "google_dns_record_set" "a" {
#  name         = var.domain_name
#  managed_zone = var.dns_zone
#  type         = "A"
#  ttl          = 30

#  rrdatas = google_compute_instance.graylog[*].network_interface[0].access_config[0].nat_ip
#}

#Create boot disk
resource "google_compute_disk" "os-disk" {
  name   = format("os-disk-%s", var.instance_name)
  type   = "pd-ssd"
  image  = var.image
  size   = var.os_pd_ssd_size
  zone   = "us-central1-c"
}

#Create attached disk to instance size 30 GB
resource "google_compute_disk" "graylog-disk" {
  name   = format("graylog-disk-%s", var.instance_name)
  type   = "pd-ssd"
  size   = var.graylog_pd_ssd_size
  zone   = "us-central1-c"
}

#Attached additional disk to instance 
resource "google_compute_attached_disk" "default" {
  disk     = google_compute_disk.graylog-disk.id
  instance = google_compute_instance.graylog.id
}

#Main Graylog instance
resource "google_compute_instance" "graylog" {
  name         = var.instance_name
  machine_type = var.machine_type
  tags = ["http-server", "https-server"]
  zone         = "us-central1-c"

  
  boot_disk {
    source = google_compute_disk.os-disk.name
    auto_delete = false
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

 
  lifecycle {
    ignore_changes = [attached_disk]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user = "ubuntu"
      host        = self.network_interface[0].access_config[0].nat_ip
      timeout     = "500s"
      private_key = file(var.ssh_file_path)
    }
    source      = "./scripts/"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user = "ubuntu"
      host        = self.network_interface[0].access_config[0].nat_ip
      timeout     = "500s"
      private_key = file("~/.ssh/google_compute_engine")
    }
    inline = [
      "sudo chmod +x /tmp/webapp.sh",
      "/tmp/webapp.sh",
    ]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(format("%s%s", var.ssh_file_path, var.ssh_public_file_ext))}"
  }


}




