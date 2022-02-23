resource "google_service_account" "workload-identity-user-sa" {
  account_id   = "workload-identity-sa"
  display_name = "Service Account For Workload Identity"
}

resource "google_project_iam_member" "storage-role" {
  project = var.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.workload-identity-user-sa.email}"
}

resource "google_project_iam_member" "bigquery-role" {
  project = var.project
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.workload-identity-user-sa.email}"
}

resource "google_project_iam_member" "workload_identity-role" {
  project = var.project
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${var.project}.svc.id.goog[default/default]"
}
