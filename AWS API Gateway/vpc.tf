resource "aws_vpc" "appmesh-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "appmesh-vpc"
  }
}