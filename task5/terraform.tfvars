region      = "us-east-1"
project_tag = "cmtr-7d8d3336"

vpc_id            = "vpc-0392c60e5d174d72f"
public_subnet_id  = "subnet-027cb52ebaec02889"
private_subnet_id = "subnet-069f8b365b780f768"

public_instance_id  = "i-08d31b28a014956fd"
private_instance_id = "i-002294496dfb15e62"

# Replace YOUR_PUBLIC_IP with your real IP (e.g. 203.0.113.25/32).
# Keep the provided CIDR as one of the allowed ranges per the lab example.
allowed_ip_range = [
  "18.153.146.156/32",
  "178.89.5.34/32"
]
