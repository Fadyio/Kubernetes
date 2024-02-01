module "allow_eks_cluster_to_assume_role" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version       = "5.3.1"
  name          = "eks_assume_role"
  create_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "eks:DescribeCluster"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

module "eks_admin_iam_role" {
  source                  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version                 = "5.3.1"
  role_name               = "eks_admin_role"
  create_role             = true
  role_requires_mfa       = false
  custom_role_policy_arns = [module.allow_eks_cluster_to_assume_role.arn]
  trusted_role_arns = [
    "arn:aws:iam::${module.vpc.vpc_owner_id}:root"
  ]
}

module "admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-user"
  version                       = "5.3.1"
  name                          = "admin"
  create_iam_access_key         = false
  create_iam_user_login_profile = false
  force_destroy                 = true

}

module "allow_assume_eks_admins_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.3.1"

  name          = "allow-assume-eks-admin-iam-role"
  create_policy = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = module.eks_admin_iam_role
      },
    ]
  })
}

module "eks_admins_iam_group" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.3.1"

  name                              = "eks-admin"
  attach_iam_self_management_policy = false
  create_group                      = true
  group_users                       = [module.admin.iam_user_name]
  custom_group_policy_arns          = [module.allow_assume_eks_admins_iam_policy.arn]
}