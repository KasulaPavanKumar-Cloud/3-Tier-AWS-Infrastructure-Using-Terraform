#my backend configuration that uses S3 for state storage and DynamoDB for state locking
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-3tier-pavan-20250929" 
    key            = "3tier/dev/terraform.tfstate"
    region         = "us-east-1"                               
    dynamodb_table = "terraform-lock-3tier-pavan"              
    encrypt        = true
  }
}
