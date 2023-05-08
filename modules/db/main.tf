resource "aws_dynamodb_table" "tf_dk_table" {
  name = "tf-dk-table"
  billing_mode = "PROVISIONED"
  read_capacity= "30"
  write_capacity= "30"
  attribute {
    name = "noteId"
    type = "S"
  }
  hash_key = "noteId"
}
