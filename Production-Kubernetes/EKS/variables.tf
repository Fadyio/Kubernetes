variable "environment" {
  type    = string
  default = "production"
}

variable "eksIAMRole" {
  type = string
  default = "prod-EKS-Cluster"
}

variable "EKSClusterName" {
  type = string
  default = "prod-EKS"
}

variable "k8sVersion" {
  type = string
  default = "1.29"
}

variable "workerNodeIAM" {
  type = string
  default = "prodWorkerNodes"
}

variable "max_size" {
  type = string
  default = 3
}

variable "desired_size" {
  type = string
  default = 1
}
variable "min_size" {
  type = string
  default = 1
}

variable "instanceType" {
  type = list
  default = ["t3.medium"]
}