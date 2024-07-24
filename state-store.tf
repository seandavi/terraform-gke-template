terraform {
  backend "gcs" {
    bucket = "cdsci-tf-store"
    prefix = "terraform/state"
  }
}
