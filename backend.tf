terraform {
  backend "s3" {
    bucket         = "talent-academy-manoj-lab-tfstate"
    key            = "talent-academy/demo-dev/terraform.tfstates"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock"
  }
}