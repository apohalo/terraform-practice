# Fill these with provided lab values / environment specific values
aws_region = "us-east-1"


# Example placeholders — replace with lab-provided ids
vpc_id            = "vpc-0f7b8d03f51afc160"
public_subnet_ids = ["subnet-0fbf0cf1f52a5b6b6", "subnet-00afc06ec947bbea6"]


# Security groups provided in the lab
sg_lb   = "sg-0d1ba3f607207f3b2"
sg_http = "sg-0694f148c340198d2"
sg_ssh  = "sg-01853d694d719e43f"


# AMI to use for ubuntu/http server — replace with lab AMI id
ami_id = "ami-0bdd88bd06d16ba03"
instance_type         = "t3.micro"
project_name          = "cmtr-project"
blue_desired_capacity = 1
green_desired_capacity = 1
# optional: override weights here or pass via -var on plan/apply
#blue_weight = 100
#green_weight = 0


# Tags applied to created resources
tags = {
  Project = "blue-green-lab"
  Owner   = "student"
}