provider "aws" {
    access_key = "none"                                                  #key#
    secret_key = "none"
    region     = "eu-west-2"                                                             #region from my acc#
}

resource "aws_instance" "test_instance" {
  ami           = "ami-06dc09bb8854cbde3"                                                #Amazon linux#
  instance_type = "t2.micro"
  associate_public_ip_address = true                                                     #enable public ip of ec2#
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su                       
                  yum -y install httpd
                  echo "<p> My test html page </p>" >> /var/www/html/index.html
                  sudo systemctl enable httpd    
                  sudo systemctl start httpd
                  EOF
}

resource "aws_s3_bucket" "s3bucket455723626732267236" {
  bucket = "s3bucket455723626732267236"
  acl    = "private"

versioning {
      enabled = true                                                                     # enable versioning#
   }

lifecycle_rule {
    prefix  = "config/"
    enabled = true
    noncurrent_version_expiration {                                                      #to expire non-current objects after 30days#
      days = 30
    }
  }
}



output "DNS" {
  value = aws_instance.test_instance.public_dns
}
