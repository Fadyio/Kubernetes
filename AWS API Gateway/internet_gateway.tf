resource "aws_internet_gateway" "appmesh_igw" {
  vpc_id = aws_vpc.appmesh-vpc.id
  tags = {
    Name = "appmesh-igw"
  }
}
