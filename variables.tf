#============  network ===================#

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_db_subnet_cidrs" {
  default = ["10.0.4.0/24", "10.0.5.0/24"]
  
}

#============ ENV ========================#

variable "env" {
  default = "dev"
}

variable "project" {
  default = "testcasepd"
}

variable "region" {
  default = "eu-central-1"
}

#============ ECS ========================#
 #---------- TASK DEFINITION ------------#
variable "container-port-definitions" {
  default = "80"
}

variable "host-port-definitions" {
  default = "80"
}

variable "cpu-definitions" {
  default = "256"
}

variable "memory-definitions" {
  default = "512"
}

variable "networkMode-definitions" {
  default = "awsvpc"
}

variable "requires_compatibilities" {
  default = "FARGATE"
}

variable "networkMode" {
  default = "awsvpc"
}

variable "memory" {
  default = "512"
}

variable "cpu" {
  default = "256"
}
 #------------- SERVICE -----------------#
variable "launch_type" {
  default = "FARGATE"
}

variable "scheduling_strategy" {
  default = "REPLICA"
}

variable "force_new_deployment" {
  default = "true"
}

variable "desired_count" {
  default = "1"
}

variable "assign_public_ip" {
  default = "false"
}

variable "container-port" {
  default = "80"
}
#============ ALB ========================#

variable "internal" {
  default = false
}

variable "load_balancer_type" {
  default = "application"
}
