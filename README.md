# This module created EKS on multiple regions

### Copy paste below code

data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id 
  }

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "12.0.0"
  cluster_version = "${var.cluster_version}"
  cluster_name    = "${var.cluster_name}"
  subnets         = "${var.subnets}"
  vpc_id          = "${var.vpc_id}"
  worker_groups = [{
      instance_type = "${var.instance_type}"
      asg_max_size  = "${var.asg_max_size}"
      asg_min_size = "${var.asg_min_size}"
    }
  ]
}

### Ohio tfvars values

cluster_name = "my-cluster"
cluster_version = "1.17"
subnets = ["subnet-0b73d0ecff5035baf", "subnet-02e78872a7c64aa30", "subnet-0833b17fce00b87d3"]
vpc_id = "vpc-0626f00e3d58f59c1"
instance_type = "m4.large"
asg_max_size = 5
asg_min_size = 1
region = "us-east-2"

### variables

variable cluster_name{}
variable cluster_version{}
variable subnets{type= list}
variable vpc_id{}
variable instance_type{}
variable  asg_max_size{}
variable asg_min_size{}
variable region{}
