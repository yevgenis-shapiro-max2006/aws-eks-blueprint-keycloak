
terraform {
  backend "s3" {
    bucket = "apps-terraform-clusters"
    key    = "eks-keycloak/terraform.tfstate"
    region = "eu-central-1"
  }
}
