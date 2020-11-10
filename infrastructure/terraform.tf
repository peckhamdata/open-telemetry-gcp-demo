terraform {
  backend "gcs" {
    bucket  = "otel-prince-charming-tfstate"
    prefix  = "terraform/state"
    credentials = "~/gcloud/otel-prince-charming.json"
  }
}

