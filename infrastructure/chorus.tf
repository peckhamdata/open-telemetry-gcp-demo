resource "google_service_account" "prince_charming" {
  account_id   = "prince-charming"
  display_name = "Update Child Record"
}

resource "google_pubsub_topic" "verse_one" {
  name = local.GCP_PUBSUB_VERSE_ONE

  labels = {
    role = local.GCP_PUBSUB_VERSE_ONE
  }
}

resource "google_pubsub_subscription" "verse_one" {
  name  = local.GCP_PUBSUB_VERSE_ONE
  topic = google_pubsub_topic.verse_one.name

  labels = {
    role = local.GCP_PUBSUB_VERSE_ONE
  }

  message_retention_duration = "604800s"
  retain_acked_messages      = true

  ack_deadline_seconds = 600

}

resource "google_pubsub_topic_iam_member" "verse_one" {
  topic = google_pubsub_topic.verse_one.name
  role = "roles/owner"
  member = "serviceAccount:${google_service_account.prince_charming.email}"
}

resource "google_pubsub_subscription_iam_member" "verse_one" {
  subscription = google_pubsub_subscription.verse_one.name
  role         = "roles/owner"
  member       = "serviceAccount:${google_service_account.prince_charming.email}"
}

resource "google_cloudfunctions_function" "verse_one" {
  name = "verse_one"
  timeout = 500
  service_account_email = google_service_account.prince_charming.email
  ingress_settings = "ALLOW_ALL"
  available_memory_mb = 256
  runtime = "python37"
  region = local.location
  entry_point = "entry_point"
  vpc_connector = google_vpc_access_connector.connector.id
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource = google_pubsub_topic.verse_one.name
    failure_policy {
      retry = false
    }
  }

  environment_variables = {
    COLLECTOR_ENDPOINT = local.collector_endpoint
  }

  source_repository  {
    url = "https://source.developers.google.com/projects/${local.project_id}/repos/${google_sourcerepo_repository.default.name}/moveable-aliases/main/paths/cloud_functions/verse_one"
  }

}

resource "google_sourcerepo_repository" "default" {
  name = local.project_id
}