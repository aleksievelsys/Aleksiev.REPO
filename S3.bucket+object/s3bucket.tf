provider "aws" {
    access_key = ""                                                  #key#
    secret_key = ""
    region     = "eu-west-2"                                                             #region from my acc#
}

resource "aws_s3_bucket" "aleksiev_s3_bucket" {
  bucket = "aleksiev-s3-bucket"
  acl    = "private"

versioning {
      enabled = true                                                                     # enable versioning#
   }

lifecycle_rule {
    prefix  = "/"                                                                         #all directories
    enabled = true
    noncurrent_version_expiration {                                                      #to expire non-current objects after 30days#
      days = 30
    }
  }
}
  resource "aws_s3_bucket_object" "object" {                                        
  bucket = aws_s3_bucket.aleksiev_s3_bucket.id
  key    = "index.html"                                                             #file name to file in bucket
  source = "index2.html"                                                              #source file from pc
}
