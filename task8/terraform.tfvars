region                = "us-east-1"
ssh_key_name          = "cmtr-7d8d3336-keypair"
instance_profile_name = "cmtr-7d8d3336-instance_profile"
ami_id                = "ami-0bdd88bd06d16ba03"

# Provide the actual VPC / subnet / SG IDs from your lab environment:
vpc_id             = "vpc-0b9937c452976f468"
public_subnet_ids  = ["subnet-047f3eddd29584c01", "subnet-006139d3e176366dd"]
private_subnet_ids = ["subnet-0e9bc8e37af35c2ba", "subnet-05c88085935c6a088"]

ec2_sg_id  = "sg-0151e4842d5e0727a"
http_sg_id = "sg-0632d257c80ce67eb"
lb_sg_id   = "sg-04b122bf3bf5995e9"

# The bucket where the instance's startup script will upload the generated file.
s3_bucket_name = "my-lab-cloud-object-storage-bucket"
