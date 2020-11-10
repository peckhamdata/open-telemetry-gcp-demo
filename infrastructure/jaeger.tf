data "google_compute_network" "default" {
  name = "default"
}

data "google_compute_subnetwork" "region_default" {
  name   = "default-${local.location}"
  region = local.location
}

resource "google_vpc_access_connector" "connector" {
  name          = "connector"
  region        = local.location
  ip_cidr_range = local.connector_cidr_range
  network       = "default"
  max_throughput = 300
}

resource "google_service_account" "jaeger" {
  account_id   = "${local.project_id}-jaeger"
  display_name = "Jaeger"
}

data "google_compute_image" "jaeger" {
  family  = "ubuntu-minimal-2004-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance_template" "jaeger" {
  name        = "jaeger"
  description = "Jaeger Open Tracing"

  labels = {
    role = "jaeger"
  }

  tags = ["jaeger"]

  instance_description = "jaeger"
  machine_type         = "e2-standard-2"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = data.google_compute_image.jaeger.self_link
    auto_delete  = true
    boot         = true
    type         = "PERSISTENT"
    disk_size_gb = 100
    mode         = "READ_WRITE"
    disk_name    = "jaeger-20200106"
  }

  network_interface {
    network = "default"
    access_config {
      network_tier = "PREMIUM"
    }
  }

  metadata = {
    google-logging-enabled    = "false"
    google-monitoring-enabled = "false"
    enable-oslogin            = "true"
    user-data = templatefile("jaeger-cloud-init.yaml",
    {
      image = "jaegertracing/all-in-one:latest"
    })
  }

  service_account {
    email = google_service_account.jaeger.email
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_secure_boot = "false"
    enable_vtpm = "true"
    enable_integrity_monitoring = "true"
  }
}

resource "google_compute_instance_from_template" "jaeger" {
  name = "jaeger"
  zone  = "${local.location}-${local.default_zone}"

  source_instance_template = google_compute_instance_template.jaeger.id

  network_interface {
    network = data.google_compute_network.default.name
    subnetwork = data.google_compute_subnetwork.region_default.name
    access_config {
      network_tier = "PREMIUM"
    }
  }
}

resource "google_compute_firewall" "jaeger_tcp" {
name        = "jaeger-tcp"
description = "Access to jaeger tracer over tcp"
network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5778", "14268", "14250"]
  }

  source_ranges = [local.connector_cidr_range]
  source_tags = ["api"]
}

resource "google_compute_firewall" "jaeger_udp" {
name        = "jaeger-udp"
description = "Access to jaeger tracer over udp"
network = "default"

  allow {
    protocol = "udp"
    ports    = ["5775", "6831", "6832"]
  }

  source_ranges = [local.connector_cidr_range]
  source_tags = ["api"]

}


resource "google_compute_firewall" "jaeger_ui" {
  name = "jaeger-ui"
  description = "Access to jaeger UI"
  network = "default"

  allow {
    protocol = "tcp"
    ports = [
      "16686"]
  }

  source_ranges = [
    "0.0.0.0/0"]
}