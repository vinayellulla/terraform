resource "aws_s3_bucket" "my-bucket" { # This is using list
  count  = 2
  bucket = var.bucket_names[count.index]
}

resource "aws_s3_bucket" "my-bucket2" { # This is using for each
  for_each = var.bucket_names_set
  bucket   = each.value

  depends_on = [aws_s3_bucket.my-bucket]
}


