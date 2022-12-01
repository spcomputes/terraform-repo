resource "aws_s3_bucket" "paas-cp" {
  bucket = "paas-cp-cspc1s3"
  tags = {
    Name        = "arun"
    Environment = "Dev"
  }
}

resource "aws_instance" "test" {
  ami           = ami-0b0dcb5067f052a63
  instance_type = "t2.micro"

  tags = {
    Name = "testcrossplane"
  }
}
