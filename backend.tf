terraform {
  backend "s3" {
    encrypt = true
    bucket  = "complex-project-070779871"
    key     = "terraform.tfstate"
    region  = "us-east-1"
  }
}
