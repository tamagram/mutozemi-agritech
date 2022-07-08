resource "aws_s3_bucket" "grow_bucket" {
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.grow_bucket.id
  acl    = "private"
}
