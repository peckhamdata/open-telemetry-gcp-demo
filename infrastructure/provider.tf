provider "google" {
  credentials = file("~/gcloud/otel-prince-charming.json")
  project     = "otel-prince-charming"
  region      = "europe-west1"
}
