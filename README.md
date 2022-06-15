# Terraform-ECS-infrastructure

Before starting, I want to say that this template can be useful for many devops engineers to create their own infrastructure based on the Amazon cloud. In this code, I resorted to cutting into modules, so that the variables would eventually be available from one file.

And also a kind request to make AWS Configure with your public and private keys.

So, let's begin.
Immediately you have to make your bucket in any availability zone. this is necessary so that we store the .tfstate file in the bucket for our safety, that this file will not disappear. So you will need to go to the main.tf root file and change the bucket data to your own.

In many ways, you don't have to write much to variables, because most variables are the output of modules. You only need to change the variables for ECS based on your needs.

Ater terraform installs all services, you need to wait ~3 min for the target group to pass healthcheck and load balancer to work

Good luck!
