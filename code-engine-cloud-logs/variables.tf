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
  description = "The IBM Cloud region where all resources will be deployed."
  default     = "us-south"
  validation {
    condition     = can(regex("^(us-south|us-east|eu-gb|eu-de|jp-tok|au-syd|ca-tor|br-sao|eu-es|jp-osa)$", var.region))
    error_message = "The region must be a valid IBM Cloud region."
  }
}

variable "prefix" {
  type        = string
  description = "A prefix to add to all resource names to ensure uniqueness."
  default     = "ce-logs"
  validation {
    condition     = can(regex("^[a-z][-a-z0-9]*$", var.prefix))
    error_message = "The prefix must start with a lowercase letter and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "resource_group" {
  type        = string
  description = "The name of an existing resource group to deploy resources into. If not provided, a new resource group will be created using the prefix."
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to all created resources for organization and cost tracking."
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "Optional list of access management tags to control access to resources. Tags must be created before use."
  default     = []
}

########################################################################################################################
# Cloud Logs Configuration
########################################################################################################################

variable "cloud_logs_plan" {
  type        = string
  description = "The pricing plan for the IBM Cloud Logs instance."
  default     = "standard"
  validation {
    condition     = contains(["standard"], var.cloud_logs_plan)
    error_message = "The cloud_logs_plan must be 'standard'."
  }
}

variable "retention_period" {
  type        = number
  description = "The number of days IBM Cloud Logs will retain the logs data in Priority insights."
  default     = 7
  validation {
    condition     = contains([7, 14, 30, 60, 90], var.retention_period)
    error_message = "The retention_period must be one of: 7, 14, 30, 60, or 90 days."
  }
}

variable "service_endpoints" {
  type        = string
  description = "The type of service endpoint for the IBM Cloud Logs instance."
  default     = "public-and-private"
  validation {
    condition     = contains(["public-and-private"], var.service_endpoints)
    error_message = "The service_endpoints must be 'public-and-private'."
  }
}

variable "enable_platform_logs" {
  type        = bool
  description = "Enable platform logs routing to send Code Engine logs to Cloud Logs. When enabled, a log routing tenant will be created in the specified region."
  default     = true
}

########################################################################################################################
# Context-Based Restrictions (CBR) Configuration
########################################################################################################################

variable "enable_cbr_rules" {
  type        = bool
  description = "Enable Context-Based Restrictions (CBR) rules to restrict access to Code Engine and Cloud Logs instances."
  default     = false
}

variable "cbr_enforcement_mode" {
  type        = string
  description = "The enforcement mode for CBR rules. Use 'enabled' for production, 'report' for testing."
  default     = "report"
  validation {
    condition     = contains(["enabled", "disabled", "report"], var.cbr_enforcement_mode)
    error_message = "The cbr_enforcement_mode must be one of: enabled, disabled, or report."
  }
}

variable "cbr_allowed_ip_range" {
  type        = string
  description = "The IP range allowed to access resources when CBR is enabled. Format: 'startIP-endIP' (e.g., '192.168.1.0-192.168.1.255')."
  default     = "0.0.0.0-255.255.255.255"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}-([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.cbr_allowed_ip_range))
    error_message = "The cbr_allowed_ip_range must be in the format 'startIP-endIP'."
  }
}