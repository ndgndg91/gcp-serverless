provider "google" {
  project = "serverless-practice-350606"
  region  = "asia-northeast3"
}

terraform {
  backend "gcs" {
    bucket = "ndgndg91-terraform-state"
    prefix = "terraform/state"
  }
}

locals {
  root_dir = abspath("./functions")
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = local.root_dir
  output_path = var.hello_http_output_path
}

# Add the zipped file to the bucket.
resource "google_storage_bucket_object" "archive" {
  # Use an MD5 here. If there's no changes to the source code, this won't change either.
  # We can avoid unnecessary redeployments by validating the code is unchanged, and forcing
  # a redeployment when it has!
  name   = "${data.archive_file.source.output_md5}.zip"
  bucket = var.archive_bucket_name
  source = data.archive_file.source.output_path
}

resource "google_cloudfunctions_function" "function" {
  name        = var.hello_http_function_name
  description = var.hello_http_function_description
  runtime     = var.hello_http_function_runtime

  available_memory_mb   = 128
  source_archive_bucket = "ndgndg91-terraform-state"
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = var.hello_http_function_entry_point
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
