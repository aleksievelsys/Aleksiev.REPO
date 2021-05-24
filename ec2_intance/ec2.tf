provider "aws" {
    access_key = ""                                                  #key#
    secret_key = ""
    region     = "eu-west-2"                                                             #region from my acc#
}

resource "aws_instance" "test_instance" {
  ami           = "ami-06dc09bb8854cbde3"                                                #Amazon linux#
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.myec2_profile.name                     # to use iam role(role will gain access to s3)
  associate_public_ip_address = true                                                     #enable public ip of ec2#
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su                       
                  yum -y install httpd
                  aws s3 cp s3://aleksiev-s3-bucket/index.html /var/www/html/index.html   
                  sudo systemctl enable httpd    
                  sudo systemctl start httpd
                  EOF
                
}

resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = <<EOF                                                                      #okazva che rolqta shte se polzva ot ec2 usluga#
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "myec2_profile" {
  name = "myec2_profile"
  role = aws_iam_role.test_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  role       = aws_iam_role.test_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

output "DNS1" {
  value = aws_instance.test_instance.public_dns                                             #Print public DNS
}