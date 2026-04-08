########################################################################################################################
# Input Variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key required to deploy resources."
  sensitive   = true
}

variable "region" {
  type        = string
  description = "The IBM Cloud region where resources will be deployed."
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "A prefix to add to all resource names."
  default     = "ce-logs-basic"
}

variable "resource_group" {
  type        = string
  description = "The name of an existing resource group. If not provided, a new one will be created."
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags for cost tracking and organization."
  default     = ["example:basic", "terraform:true"]
}