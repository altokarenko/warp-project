resource "aws_s3_bucket" "backend" {
  bucket = "${var.project_name}-terraform-backend"
}

resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "${var.project_name}-terraform-backend"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}
