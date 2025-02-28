//
variable "enable_route53_zone" {
  description = "When true, creates Route53 hosted zone."
  type        = bool
  default     = true
}

variable "enable_cert_validation" {
  description = "When true, creates all resources for website hosting. When false, only creates Route53 hosted zone."
  type        = bool
  default     = true
}

variable "website_name" {
  description = "The name of the website"
  type        = string
  default     = "exampledomain.com"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}



// terraform plan -var='enable_cert_validation=false' -var='enable_route53_zone=false'