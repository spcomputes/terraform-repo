
resource "aws_instance" "cluster-instances" {
    count = var.desired_cluster_size
    instance_type = "${var.aws_instance_type}"
    ami = "ami-0b0dcb5067f052a63"
    tags = {
        Name = "terraform-crossplane-${format("instance-%03d", count.index + 1)}"
    
  }
}

output "ec2-public-dns" {
  description = "Details about ec2 provisioned"
  value       = aws_instance.cluster-instances[0].public_dns
}
output "ec2-private-dns" {

  description = "Details about ec2 provisioned"
  value       = aws_instance.cluster-instances[0].private_dns
}
output "ec2-arn" {
  description = "Details about ec2 provisioned"
  value       = aws_instance.cluster-instances[0].arn
}
terraform {
       backend "s3" {
        bucket = "sai-cdb"
        key    = "s3-test-remote"
        region = "us-west-2"
        shared_credentials_file = "aws-creds.ini"
       }
      }