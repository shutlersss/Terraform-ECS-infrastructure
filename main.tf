provider "aws" {
  region     = var.region
}

#================================= S3 Bucket ===================================#
terraform {
    backend "s3" {
        bucket = "testcasepd-terraform-tfstate-bucket"
        key = "terraform.tfstate"
        region = "eu-central-1"
    }
}

#================================= Network =====================================#
module "network" {
    source = "./modules/network"
    vpc_cidr             = var.vpc_cidr
    public_subnet_cidrs  = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs

    env     = var.env
    project = var.project
}

#=================================   SG    =====================================#
module "SG" {
  source           = "./modules/SG"
  vpc_id           = module.network.vpc_id
  vpc_cidr         = var.vpc_cidr

  env     = var.env
  project = var.project
}

#=================================   ECR  =====================================#

module "ECR" {
  source                  = "./modules/ECR"

  env     = var.env
  project = var.project
}

#=================================   IAM  =====================================#

module "IAM" {
  source                  = "./modules/IAM"

  env     = var.env
  project = var.project
}

#=================================   ECS  =====================================#

module "ECS" {
  source                     = "./modules/ECS"
  logs-group                 = module.CW.logs-group
  url_repo                   = module.ECR.url_repo
  IAM                        = module.IAM.IAM
  private_subnet_ids         = module.network.private_subnet_ids
  tg-arn                     = module.ALB.tg-arn
  lb-listner                 = module.ALB.lb-listner
  container-port-definitions = var.container-port-definitions
  host-port-definitions      = var.host-port-definitions
  cpu-definitions            = var.cpu-definitions
  memory-definitions         = var.memory-definitions
  networkMode-definitions    = var.networkMode-definitions
  requires_compatibilities   = var.requires_compatibilities
  networkMode                = var.networkMode
  memory                     = var.memory
  cpu                        = var.cpu
  launch_type                = var.launch_type
  container-port             = var.container-port
  scheduling_strategy        = var.scheduling_strategy
  force_new_deployment       = var.force_new_deployment
  desired_count              = var.desired_count
  assign_public_ip           = var.assign_public_ip
  sg_id                      = module.SG.sg_id
  sg_alb_id                  = module.SG.sg_alb_id

  env     = var.env
  project = var.project
  region  = var.region
}

#=================================   CW  =====================================#

module "CW" {
  source                  = "./modules/CW"

  env     = var.env
  project = var.project
}

#=================================   ALB  =====================================#

module "ALB" {
  source                  = "./modules/ALB"
  vpc_id                  = module.network.vpc_id
  sg_alb_id               = module.SG.sg_alb_id
  internal                = var.internal
  load_balancer_type      = var.load_balancer_type
  public_subnet_ids       = module.network.public_subnet_ids

  env     = var.env
  project = var.project
}

#=================================   ASG  =====================================#

module "ASG" {
  source                  = "./modules/ASG"
  cluster-name     = module.ECS.cluster-name
  service-name     = module.ECS.service-name

  env     = var.env
  project = var.project
}