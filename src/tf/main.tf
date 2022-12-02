
resource "aws_instance" "cluster-instances" {
    count = var.desired_cluster_size
    instance_type = "${var.aws_instance_type}"
    ami = "ami-0b0dcb5067f052a63"
    tags = {
        Name = "terraform-crossplane-${format("instance-%03d", count.index + 1)}"
    
  }
}
