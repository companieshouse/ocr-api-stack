# ----------------------------------------------------------------------
#  Standard Variables
# ----------------------------------------------------------------------
variable "environment" {
  description = "The name of the environment this cluster is part of e.g. live, staging, dev. etc."
  type        = string
}

# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

#
# ----------------------------------------------------------------------
#  Load Balancer Variables
# ----------------------------------------------------------------------
variable "elb_arn_suffix" {
  type = string
  description = "The Load Balancer ARN suffix for use with CloudWatch Metrics."
}


