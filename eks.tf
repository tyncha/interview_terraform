data "aws_eks_cluster" "cluster" {
  name = module.my_cluster.cluster_id 
  }

data "aws_eks_cluster_auth" "cluster" {
  name = module.my_cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}
module "my-clsuter" {
    source = "terraform-aws-module/eks/aws"
    version = "12.0.0"
    cluster_name = "my-cluster"
    cluster_version = "1.14"
    subnets = ["subnet-0b73d0ecff5035baf", "subnet-02e78872a7c64aa30", "subnet-0833b17fce00b87d3"]
    vpc_id =  "vpc-0626f00e3d58f59c1"
    workers_group = [
    {
        instance_type = "t2.small"
        asg_max_size = 3
        asg_min_size = 2
    }
    ]
    
}