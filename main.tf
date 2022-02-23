

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
  # The next line is useful if not logged in directly to google.
  # credentials = file("credentials.json")
}
