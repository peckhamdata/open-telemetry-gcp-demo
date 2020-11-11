locals {
  location = "europe-west1"
  default_zone = "b"
  project_id = "otel-prince-charming"
  GCP_PUBSUB_VERSE_ONE = "verse-one"
  GCP_PUBSUB_VERSE_TWO = "verse-two"
  GCP_PUBSUB_VERSE_THREE = "verse-three"
  collector_endpoint = "http://${google_compute_instance_from_template.jaeger.network_interface.0.network_ip}:14268/api/traces?format=jaeger.thrift"
  connector_cidr_range = "192.168.71.0/28"
}