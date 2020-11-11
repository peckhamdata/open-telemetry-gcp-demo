resource "google_pubsub_topic" "verse_two" {
  name = local.GCP_PUBSUB_VERSE_TWO

  labels = {
    role = local.GCP_PUBSUB_VERSE_TWO
  }
}

resource "google_pubsub_subscription" "verse_two" {
  name  = local.GCP_PUBSUB_VERSE_TWO
  topic = google_pubsub_topic.verse_two.name

  labels = {
    role = local.GCP_PUBSUB_VERSE_TWO
  }

  message_retention_duration = "604800s"
  retain_acked_messages      = true

  ack_deadline_seconds = 600

}

resource "google_pubsub_topic_iam_member" "verse_two" {
  topic = google_pubsub_topic.verse_two.name
  role = "roles/owner"
  member = "serviceAccount:${google_service_account.prince_charming.email}"
}

resource "google_pubsub_subscription_iam_member" "verse_two" {
  subscription = google_pubsub_subscription.verse_two.name
  role         = "roles/owner"
  member       = "serviceAccount:${google_service_account.prince_charming.email}"
}

resource "google_cloudfunctions_function" "verse_two" {
  name = "verse_two"
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
    resource = google_pubsub_topic.verse_two.name
    failure_policy {
      retry = false
    }
  }

  environment_variables = {
    COLLECTOR_ENDPOINT = local.collector_endpoint
    CHORUS_FUNCTION = google_cloudfunctions_function.chorus.name
    LOCATION = local.location
    GCP_PROJECT_ID = local.project_id
    GCP_PUBSUB_VERSE_TWO = local.GCP_PUBSUB_VERSE_TWO
  }

  source_repository  {
    url = "https://source.developers.google.com/projects/${local.project_id}/repos/${google_sourcerepo_repository.default.name}/moveable-aliases/main/paths/cloud_functions/verse_two"
  }

}
