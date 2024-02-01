terraform {
    source = "../../modules/vpc"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
    env = "dev"
    azs = ["us-east-1a", "us-east-1b"]
    private_subnet = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnet = ["10.0.3.0/24", "10.0.4.0/24"]

    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/dev" = "owned"
    }
    public_subnet_tags = {
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/cluster/dev" = "owned"
    }
}