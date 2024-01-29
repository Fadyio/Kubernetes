output "t2_medium_spot_price" {
  value = data.aws_ec2_spot_price.t2_medium.spot_price

}

output "control_plane_public_ip" {
  value = aws_spot_instance_request.control_plane.public_ip
}

output "worker_nodes_public_ip" {
  value = aws_spot_instance_request.worker_nodes.public_ip
}

data "aws_ec2_spot_price" "t2_medium" {
  instance_type     = "t2.medium"
  availability_zone = "us-east-1a"

  filter {
    name   = "product-description"
    values = ["Linux/UNIX"]
  }
}
