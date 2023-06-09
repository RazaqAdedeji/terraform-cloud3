# resource "aws_s3_bucket" "terraform_state" {
#  bucket = "thriveonmg-dev-terraform-bucket"
  #   # Enable versioning so we can see the full revision history of our state files
#  versioning {
#    enabled = true
#  }
  #   # Enable server-side encryption by default
#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        sse_algorithm = "AES256"
#      }
#    }
#  }
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#  name         = "terraform-locks"
#  billing_mode = "PAY_PER_REQUEST"
#  hash_key     = "LockID"
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
# }


#S3 backend configuration

#terraform {
#  backend "s3" {
#    bucket         = "thriveonmg-dev-terraform-bucket"
#    key            = "global/s3/terraform.tfstate"
#    region         = "us-east-1"
#    dynamodb_table = "terraform-locks"
#    encrypt        = true
#  }
#}

terraform {
  backend "remote" {
    organization = "RazaqDevOps"

    workspaces {
      name = "terraform-cloud"
    }
  }
}
