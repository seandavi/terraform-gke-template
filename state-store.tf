terraform {
  backend "gcs" {
    bucket = "omicidx-338300"
    prefix = "terraform/state"
  }
}
