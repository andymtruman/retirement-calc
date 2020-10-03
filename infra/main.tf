resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "amt-retirement-calc"
  acl    = "public-read"


  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "null_resource" "deploy-site" {
  provisioner "local-exec" {
    command  = "aws s3 cp ../code/ s3://${aws_s3_bucket.bucket.id}/ --recursive"
  }
}


resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
     "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
      "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
      ]
    }
  ]
}
POLICY
}