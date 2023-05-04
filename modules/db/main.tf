resource "aws_dynamodb_table" "tf_dk_table" {
  name = "TODO"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "Id"
    type = "S"
  }
  hash_key = "Id"
}
