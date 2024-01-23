resource "aws_spot_instance_request" "control_plane" {
  ami                         = var.ami
  instance_type               = "t2.medium"
  spot_type                   = "one-time"
  wait_for_fulfillment        = "true"
  spot_price                  = data.aws_ec2_spot_price.t2_medium.spot_price
  key_name                    = var.ssh-key
  vpc_security_group_ids      = [aws_security_group.CKA_sg_cp.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  tags = {
    Name        = "CKA-Cluster-Control-Plane"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_spot_instance_request" "worker_nodes" {
  ami                         = var.ami
  instance_type               = "t2.medium"
  key_name                    = var.ssh-key
  spot_type                   = "one-time"
  wait_for_fulfillment        = "true"
  spot_price                  = data.aws_ec2_spot_price.t2_medium.spot_price
  vpc_security_group_ids      = [aws_security_group.CKA_sg_wn.id]
  subnet_id                   = module.vpc.public_subnets[1]
  associate_public_ip_address = true
  depends_on = [
    aws_spot_instance_request.control_plane,
    aws_security_group.CKA_sg_wn
  ]
  tags = {
    Name        = "CKA-Cluster-Worker-Node"
    Terraform   = "true"
    Environment = "dev"
  }
}