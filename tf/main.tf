
resource "aws_instance" "cluster-instances" {
    count = 1
    instance_type = "t2.micro"
    ami = "ami-0b0dcb5067f052a63"
    tags = {
        Name = "terraform-crossplane-${format("instance-%03d", count.index + 1)}"
    
  }
}
