variable "aws_account" {
  description = "The AWS Account"
}

variable "aws_region" {
  description = "The AWS Region"
  default     = "us-east-1"
}

variable "environment" {
  description = "The Operational Environment, e.g. dev, stage, prod"
  type        = string
}