
## NAMING
variable "env" {
  description = "Environment name for resource naming and tagging purposes"
  type        = string
  default     = "dev"
}
variable "project" {
  description = "Project name for resource naming and tagging purposes"
  type        = string
}
variable "name" {
  description = "Service name for resource naming and tagging purposes"
  type        = string
}
variable "managedby" {
  description = "Tag name for resource naming and tagging purposes"
  type        = string
}


## LAUNCH TEMPLATE                                                                       
variable "vpc_id" {
  description = "VPC ID to deploy resources into"
  type        = string
}
variable "instance_ami" {
  description = "AMI ID to be used by the launch template"
  type        = string
}
variable "instance_userdata" {
  description = "Userdata to be executed on instance startup"
  type        = string
}
variable "iam_role_policy" {
  description = "AWS IAM Policies to be assigned to the Launch Template"
  type        = list(any)
  default     = []
}
variable "managed_iam_policy" {
  description = "AWS IAM Policies to be assigned to the Launch Template"
  type        = list(string)
  default     = []
}
variable "instance_ssh_key" {
  description = "SSH Key Pair to be assigned to the Launch Template"
  type        = string
}
variable "stickiness_enabled" {
  description = "Load Balancer Stickiness"
  type        = bool
  default     = false
}
variable "stickiness_type" {
  description = "Load Balancer Stickiness Type"
  type        = string
  default     = "source_ip"
}
variable "healthcheck_protocol" {
  description = "Proto to be used by the healthcheck"
  type        = string
  default     = "TCP"
}
variable "disable_api_termination" {
  description = "Whether API Termination should be enabled"
  type        = bool
  default     = false
}
variable "ebs_optimized" {
  description = "EBS optimized "
  type        = bool
  default     = true
}
variable "associate_public_ip_address" {
  description = "Whether instances should be assigned public IP addresses"
  type        = bool
  default     = false
}
variable "network_interface_id" {
  description = "ARN of Network Interface to be assigned to Launch Configuration"
  type        = string
  default     = null
}
variable "instance_type" {
  description = "Instance size for deployment"
  type        = string
  default     = "m5.large"
}
variable "detailed_monitoring" {
  description = "Bool flag to enable detailed monitoring"
  type        = bool
  default     = true
}
variable "launch_template_version" {
  description = "Override for Launch Template Version"
  type        = string  
  default     = "$Latest"
}
variable "bool_lb_internal" {
  description = "Enables public availability for the Load Balancer"
  type        = bool
  default     = false
}
variable "instance_additional_sgs" {
  type    = list(any)
  default = []
}
variable "common_tags" {
  type    = map(any)
  default = {}
}
variable "extra_tags" {
  type    = map(any)
  default = {}
}
variable "availability_zones" {
  type    = list(any)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
variable "lb_subnet_ids" {
  description = "Subnet IDs to deploy the Load Balancer to"
  type        = list(string)
}
variable "subnet_ids" {
  description = "Subnet IDs to deploy instances to"
  type        = list(string)
}
variable "instance_desired_cap" {
  description = "Desired Capacity for the Autoscaling Group"
  type        = number
  default     = 3
}
variable "instance_max_cap" {
  description = "Maximum capacity for Autoscaling"
  type        = number
  default     = 3
}
variable "instance_min_cap" {
  description = "Minimum capacity for autoscaling"
  type        = number
  default     = 3
}
variable "placement_strategy" {
  description = "Instance placement strategy"
  type        = string
  default     = "spread"
}

## LOAD BALANCER CONFIG                                                                   
variable "lb_type" {
  description = "What type of Load Balancer to deploy"
  type        = string
  default     = "network"
}
variable "health_check_type" {
  description = "Controls how the Load Balancer performs health checks"
  type        = string
  default     = "EC2"
}
variable "lb_idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 300
}
variable "bucket_logs_enabled" {
  description = "Enable access logging"
  type        = bool
  default     = true
}
variable "lb_target_group_proto" {
  description = "Backend protocol for Load Balancer"
  type        = string
  default     = "TCP"
}
variable "lb_target_group_port" {
  description = "Backend Port for Load Balancer"
  type        = number
  default     = 80
}
variable "target_type" {
  description = "Type of target that you must specify when registering targets with this target group"
  type        = string
  default     = "instance"
}
variable "healthcheck_path" {
  description = "Destination for the health check request. Required for HTTP/HTTPS ALB and HTTP NLB. Only applies to HTTP/HTTPS."
  type        = string
  default     = null
}
variable "lb_listener_port" {
  description = "Load Balancer port to be exposed to client traffic"
  type        = list(number)
  default     = [443]
}
variable "lb_listener_protocol" {
  description = "Protocol to be exposed to client traffic"
  type        = list(string)
  default     = ["TCP"]
}
variable "lb_ssl_security_policy" {
  description = "Name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS"
  type        = list(string)
  default     = [null]
}
variable "lb_certificate_arn" {
  description = "ARN of ACM Certificate for use on the load balancer"
  type        = list(string)
  default     = [null]
}



## SECURITY GROUPS
variable "instance_ingress_source_sg" {
  description = "Source Security Group ID for instance ingress"
  type        = list(any)
  default     = []
}
variable "instance_ingress_sg_from_port" {
  description = "From Port on the Source Security Group ID for instance ingress"
  type        = list(any)
  default     = null
}
variable "instance_ingress_sg_rule_description" {
  description = "Description Label on the Source Security Group ID for instance ingress"
  type        = list(any)
  default     = [null]
}
variable "instance_ingress_sg_to_port" {
  description = "To Port on the Source Security Group ID for instance ingress"
  type        = list(any)
  default     = [null]
}
variable "instance_ingress_sg_proto" {
  description = "Protocol for the Source Security Group ID for instance ingress"
  type        = list(any)
  default     = [null]
}
variable "instance_ingress_cidr_rule_description" {
  description = "Desription Label on the Source CIDR for instance ingress"
  type        = list(any)
  default     = []
}
variable "instance_ingress_cidr_from_port" {
  description = "From Port on the Source CIDR for instance ingress"
  type        = list(any)
  default     = [8080]
}
variable "instance_ingress_cidr_to_port" {
  description = "To Port on the Source CIDR for instance ingress"
  type        = list(any)
  default     = [8080]
}
variable "instance_ingress_cidr_proto" {
  description = "Protocol for the Source CIDR for instance ingress"
  type        = list(any)
  default     = ["-1"]
}
variable "instance_ingress_cidrblock" {
  description = "CIDR for Instance Ingress Security Group Rule"
  type        = list(any)
  default     = []
}
variable "instance_egress_rule_description" {
  description = "Description for Instance Egress CIDR Security Group Rule"
  type        = list(any)
  default     = ["default egress rule for instances"]
}
variable "instance_egress_from_port" {
  description = "CIDR for Instance Egress Security Group Rule"
  type        = list(any)
  default     = [0]
}
variable "instance_egress_to_port" {
  description = "To Port for Instance Egress Security Group Rule"
  type        = list(any)
  default     = [0]
}
variable "instance_egress_proto" {
  description = "Protocol for Instance Egress Security Group Rule"
  type        = list(any)
  default     = ["-1"]
}
variable "instance_egress_cidrblock" {
  description = "CIDR for Instance Egress Security Group Rule"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

## ROUTE 53
variable "zone_id" {
  description = "ZoneID for Route53 Record"
  type        = string
  default     = ""
}
variable "r53_record_type" {
  description = "Record type for Route53 record"
  type        = string
  default     = "CNAME"
}
variable "r53_ttl" {
  description = "TTL for Route53 record"
  type        = number
  default     = 86400
}

