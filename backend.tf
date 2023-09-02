terraform {
  backend "s3" {
    bucket = "ic-webapp"
    key    = "state"
    region = "eu-west-3"
  }
}
