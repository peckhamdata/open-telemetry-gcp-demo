resource "google_pubsub_topic" "verse_three" {
  name = local.GCP_PUBSUB_VERSE_THREE

  labels = {
    role = local.GCP_PUBSUB_VERSE_THREE
  }
}

resource "google_pubsub_subscription" "verse_three" {
  name  = local.GCP_PUBSUB_VERSE_THREE
  topic = google_pubsub_topic.verse_three.name

  labels = {
    role = local.GCP_PUBSUB_VERSE_THREE
  }

  message_retention_duration = "604800s"
  retain_acked_messages      = true

  ack_deadline_seconds = 600

}

resource "google_pubsub_topic_iam_member" "verse_three" {
  topic = google_pubsub_topic.verse_three.name
  role = "roles/owner"
  member = "serviceAccount:${google_service_account.prince_charming.email}"
}

resource "google_pubsub_subscription_iam_member" "verse_three" {
  subscription = google_pubsub_subscription.verse_three.name
  role         = "roles/owner"
  member       = "serviceAccount:${google_service_account.prince_charming.email}"
}

resource "google_cloudfunctions_function" "verse_three" {
  name = "verse_three"
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
    resource = google_pubsub_topic.verse_three.name
    failure_policy {
      retry = false
    }
  }

  environment_variables = {
    COLLECTOR_ENDPOINT = local.collector_endpoint
    CHORUS_FUNCTION = google_cloudfunctions_function.chorus.name
    LOCATION = local.location
    GCP_PROJECT_ID = local.project_id
    GCP_PUBSUB_VERSE_THREE = local.GCP_PUBSUB_VERSE_THREE
  }

  source_repository  {
    url = "https://source.developers.google.com/projects/${local.project_id}/repos/${google_sourcerepo_repository.default.name}/moveable-aliases/main/paths/cloud_functions/verse_three"
  }

}
