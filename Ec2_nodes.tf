resource "aws_instance" "control_plane" {
  ami                         = var.ami
  instance_type               = "t2.medium"
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

resource "aws_instance" "worker_nodes" {
  ami                         = var.ami
  instance_type               = "t2.medium"
  key_name                    = var.ssh-key
  vpc_security_group_ids      = [aws_security_group.CKA_sg_wn.id]
  subnet_id                   = module.vpc.public_subnets[1]
  associate_public_ip_address = true
  depends_on = [
    aws_instance.control_plane,
    aws_security_group.CKA_sg_wn
  ]
  tags = {
    Name        = "CKA-Cluster-Worker-Node"
    Terraform   = "true"
    Environment = "dev"
  }
}