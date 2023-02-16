data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {


  common_tags = tomap({
    Name        = "${var.project}-${var.env}-${var.name}"
    Project     = var.project
    Environment = var.env
    Terraform   = "true"
    ManagedBy   = var.managedby
  })
}