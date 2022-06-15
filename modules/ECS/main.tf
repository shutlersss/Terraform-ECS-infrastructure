#=================================   CLUSTER  =====================================#
resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "${var.project}-${var.env}-cluster"
  tags = {
    Name        = "${var.project}-ecs"
    Environment = var.env
  }
}

data "template_file" "env_vars" {
  template = file("env_vars.json")
}

#=============================   TASK DEFINITION  =================================#

resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${var.project}-task"

  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.project}-${var.env}-container",
      "image": "${var.url_repo}:latest",
      "entryPoint": [],
      "environment": [${data.template_file.env_vars.rendered}],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.logs-group}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "${var.project}-${var.env}"
        }
      },
      "portMappings": [
        {
          "containerPort": ${var.container-port-definitions},
          "hostPort": ${var.host-port-definitions}
        }
      ],
      "cpu": ${var.cpu-definitions},
      "memory": ${var.memory-definitions},
      "networkMode": "${var.networkMode-definitions}"
    }
  ]
  DEFINITION

  requires_compatibilities = ["${var.requires_compatibilities}"]
  network_mode             = "${var.networkMode}"
  memory                   = "${var.memory}"
  cpu                      = "${var.cpu}"
  execution_role_arn       = "${var.IAM}"
  task_role_arn            = "${var.IAM}"

  tags = {
    Name        = "${var.project}-ecs-td"
    Environment = "${var.env}"
  }
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.aws-ecs-task.family
}

#=================================   SERVICE  ==================================#

resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${var.project}-${var.env}-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = "${aws_ecs_task_definition.aws-ecs-task.family}:${max(aws_ecs_task_definition.aws-ecs-task.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type          = "${var.launch_type}"
  scheduling_strategy  = "${var.scheduling_strategy}"
  desired_count        = var.desired_count
  force_new_deployment = var.force_new_deployment

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = var.assign_public_ip
    security_groups = [
      var.sg_id,
      var.sg_alb_id
    ]
  }

  load_balancer {
    target_group_arn = "${var.tg-arn}"
    container_name   = "${var.project}-${var.env}-container"
    container_port   = "${var.container-port}"
  }

  depends_on = [var.lb-listner]
}