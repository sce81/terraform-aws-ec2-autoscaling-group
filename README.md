# aws-tf-module-autoscaling-group
Terraform module for standardised AWS Autoscaling Group using Terraform v15.1


## Getting Started

This module is intended to create a number of resources necessary for an EC2 instance to operate within an Autoscaling Group and Network Load Balancer. future version will implement switch for ALB. 

Resources
- aws_launch_configuration
- aws_autoscaling_group
- aws_lb
    - aws_lb_target_group
    - aws_lb_listener
- aws_security_group "instance"
    - aws_security_group_rule "instance_ingress_sg"
    - aws_security_group_rule "instance_ingress_cidr"
    - aws_security_group_rule "instance_egress"
- aws_security_group "load_balancer"
    - aws_security_group_rule "load_balancer_ingress"
    - aws_security_group_rule "load_balancer_egress"
- aws_route_53_record
- aws_instance_profile
- aws_iam_role
    - aws_iam_role_policy
    - aws_iam_role_policy_attachment


### Prerequisites

```
Terraform ~> 0.15.1
AWS ~> 3.37.0
```

### Installing
This module should be called by a terraform environment configuration
```  
    source                          = "git@github.com:sce81/aws-tf-module-autoscaling-group.git"
    name                            = "service"
    env                             = "environment"
    project                         = "project"
    managedby                       = "team1"
    vpc_id                          = data.terraform_remote_state.infra.outputs.vpc_id
    subnet_ids                      = data.terraform_remote_state.infra.outputs.secondary_subnet_ids
    lb_subnet_ids                   = data.terraform_remote_state.infra.outputs.primary_subnet_ids
    instance_ami                    = data.aws_ami.ami.id
    instance_userdata               = data.template_file.userdata.rendered
    instance_ssh_key                = module.ssh_key.key_name
```

### Usage

This is a large module with a significant number of option resources built in. Optional resources are built with flags to enable or disable them utilising the count function. 
This module has a number of mandatory variables it expects to be passed into it.  

```
name
env
project
managedby
vpc_id
subnet_ids
lb_subnet_ids
instance_ami
instance_userdata
instance_ssh_key
````

The remaining variables are configured with sane defaults which can be overwritten by the parent.  
Security group rules should be passed in as a list and it will scale for each rule that is passed into it (max 1000)  / nb: function to be converted to map in later version. 



