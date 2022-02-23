variable "cluster_version" {
  default = "1.21"
}
resource "google_container_cluster" "cluster" {
  name               = "cluster-1"
  location           = var.zone
  min_master_version = var.cluster_version
  project            = var.project
  lifecycle {
    ignore_changes = [
      # Ignore changes to min-master-version as that gets changed
      # after deployment to minimum precise version Google has
      min_master_version,
    ]
  }
  # We can't create a cluster with no node pool defined, but
  # we want to only use separately managed node pools. So we
  # create the smallest possible default node pool and
  # immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }
}

resource "google_service_account" "cluster-serviceaccount" {
  account_id   = "cluster-serviceaccount"
  display_name = "Service Account For Terraform to"
}

# The following allows the nodes to pull containers from gcr.io
resource "google_project_iam_member" "allow-container-pull" {
  project = var.project
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cluster-serviceaccount.email}"
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "preempt-medium"
  location   = var.zone
  project    = var.project
  cluster    = google_container_cluster.cluster.name
  node_count = 1
  autoscaling {
    min_node_count = 1
    max_node_count = 15
  }
  version = var.cluster_version
  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    # Google recommends custom service accounts that have cloud-platform scope and
    # permissions granted via IAM Roles.
    service_account = google_service_account.cluster-serviceaccount.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to node_count, initial_node_count and version
      # otherwise node pool will be recreated if there is drift between what 
      # terraform expects and what it sees
      initial_node_count,
      node_count,
      version
    ]
  }
}
