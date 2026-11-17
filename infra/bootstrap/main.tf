provider "aws"{
    region = "ap-south-1"   
}

#1 here we are creating bucker
resource "aws_s3_bucket" "tf_state" {
    bucket = "civic-platform-tfstate-lucky"

    lifecycle {
      prevent_destroy = true
    }
}

#2 here we r doing enabling versioning so if statefile got corrupt we can rollback
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
    bucket = aws_s3_bucket.tf_state.id
    versioning_configuration {
      status = "Enabled"
    }
  
}

#3 encrypting the file (server side encryption) for safty
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
    bucket = aws_s3_bucket.tf_state.id

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  
}

#4 for preventing two people to access this we use DynamoDB for state lock
resource "aws_dynamodb_table" "tf_lock" {
    name = "civic-platform-tf-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
  
}

output "s3_bucket_name" {
    value = aws_s3_bucket.tf_state.bucket
}
output "dynamodb_tabel_name" {
    value = aws_dynamodb_table.tf_lock.name
}