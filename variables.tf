variable "cluster-name" {
  default = "demo-cluster"
  type    = "string"
}

variable "aws-access-key" {
  type = "string"
}

variable "aws-secret-key" {
  type = "string"
}

variable "aws-region" {
  type = "string"
}

variable "local-office" {
  type        = "string"
  description = "CIDR block for local office"
}

variable "min-workers" {
  default = 1
}

variable "max-workers" {
  default = 2
}

variable "desired-workers" {
  default = 2
}
