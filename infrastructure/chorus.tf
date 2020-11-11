resource "google_cloudfunctions_function" "chorus" {
  name = "chorus"
  timeout = 500
  service_account_email = google_service_account.prince_charming.email
  ingress_settings = "ALLOW_ALL"
  available_memory_mb = 256
  runtime = "python37"
  region = local.location
  entry_point = "entry_point"
  vpc_connector = google_vpc_access_connector.connector.id
  trigger_http = true

  environment_variables = {
    COLLECTOR_ENDPOINT = local.collector_endpoint
  }

  source_repository  {
    url = "https://source.developers.google.com/projects/${local.project_id}/repos/${google_sourcerepo_repository.default.name}/moveable-aliases/main/paths/cloud_functions/chorus"
  }

}

resource "google_cloudfunctions_function_iam_member" "call_chorus" {
  cloud_function = google_cloudfunctions_function.chorus.name
  region = google_cloudfunctions_function.chorus.region
  role = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.prince_charming.email}"
}
