module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.21.0"
  cluster_name                    = "eks-module"
  cluster_version                 = "1.27"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  enable_irsa                     = true
  eks_managed_node_group_defaults = {
    disk_size = 20
  }
  eks_managed_node_groups = {
    general = {
      desired_capacity = 1
      max_capacity     = 5
      min_capacity     = 1
      instance_type    = "t3.small"
      capacity_type    = "SPOT"
      disk_size        = 20
      labels = {
        "lifecycle" = "Spot"
      }
    }
    tags = {
      Environment = "dev"
    }
  }
}