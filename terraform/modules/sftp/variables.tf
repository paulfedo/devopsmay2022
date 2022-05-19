terraform {
  experiments = [ module_variable_optional_attrs ]
}

variable "name" {
  type = string
  description = ""
  default = ""
}

variable "az" {
  type = string
  description = ""
  default = ""
}

variable "ingress_rules" {
  type = map(map(any))
  description = ""
  default = {}
}

variable "bucket_name" {
  type = string
  description = ""
  default = ""
}

variable "bucket_arn" {
  type = string
  description = ""
  default = ""
}

variable "security_policy_name" {
  type = string
  default = "TransferSecurityPolicy-2020-06"
}

variable "secrets" {
  type = map(string)
  description = ""
  default = {}
}

variable "rest_api_name" {
  type = string
  default = "custom_idp_transfer_server"
}

variable "function_name" {
  type = string

  default = "custom_idp_for_sftp"
}

variable "create_s3_bucket" {
  type = bool
  description = ""
  default = true
}

variable "users" {
  type = map(object({
    HomeDirectory : string
    PublicKey: optional(string)
    AllowFrom: optional(list(string))
    Tags: optional(object({key = string}))
  }))
  default = {}
}

variable "region" {
  type = string
  description = ""
  default = ""
}