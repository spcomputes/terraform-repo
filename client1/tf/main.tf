
resource "aws_instance" "cluster-instances" {
    count = var.desired_cluster_size
    instance_type = "${var.aws_instance_type}"
    ami = "ami-0b0dcb5067f052a63"
    tags = {
        Name = "terraform-crossplane-${format("instance-%03d", count.index + 1)}"
    
  }
}

output "ec2-public-dns" {
  count = var.desired_cluster_size
  description = "Details about ec2 provisioned"
  value       = "${element(aws_instance.cluster-instances.*.public_dns, count.index)}"
}
output "ec2-private-dns" {
  count = var.desired_cluster_size
  description = "Details about ec2 provisioned"
  value       = "${element(aws_instance.cluster-instances.*.private_dns, count.index)}"
}
output "ec2-arn" {
  count = var.desired_cluster_size
  description = "Details about ec2 provisioned"
  value       = "${element(aws_instance.cluster-instances.*.arn, count.index)}"
}

