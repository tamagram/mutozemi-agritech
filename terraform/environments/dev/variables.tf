# Input variable definitions\


variable "aws_region" {
  description = "AWS project region."

  type    = string
  default = "ap-northeast-1"
}

variable "project_name" {
  description = "Project name for all resources."

  type    = string
  default = "mutozemi-agritech"
}

variable "owner" {
  description = "Owner name for all resources."

  type    = string
  default = "masahiro-tajima"
}

variable "environment" {
  description = "Environment name for all resources."

  type    = string
  default = "development"
}

