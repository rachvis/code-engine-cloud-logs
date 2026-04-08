########################################################################################################################
# Basic Example - Code Engine with Cloud Logs
########################################################################################################################

# This example demonstrates the simplest deployment of Code Engine with Cloud Logs integration.
# It uses default values for most settings and creates all required resources.

module "code_engine_cloud_logs" {
  source = "../.."

  # Required: IBM Cloud API key for authentication
  ibmcloud_api_key = var.ibmcloud_api_key

  # Basic configuration
  region         = var.region
  prefix         = var.prefix
  resource_group = var.resource_group

  # Optional: Add tags for organization
  resource_tags = var.resource_tags

  # Use default values for:
  # - cloud_logs_plan = "standard"
  # - retention_period = 7 days
  # - service_endpoints = "public-and-private"
  # - enable_platform_logs = true (automatic log routing)
  # - enable_cbr_rules = false (no CBR restrictions)
}

########################################################################################################################
# Outputs
########################################################################################################################

output "code_engine_project_id" {
  description = "The ID of the Code Engine project. Use this to deploy applications and jobs."
  value       = module.code_engine_cloud_logs.code_engine_project_id
}

output "code_engine_project_name" {
  description = "The name of the Code Engine project."
  value       = module.code_engine_cloud_logs.code_engine_project_name
}

output "cloud_logs_instance_name" {
  description = "The name of the Cloud Logs instance where logs are stored."
  value       = module.code_engine_cloud_logs.cloud_logs_name
}

output "cloud_logs_ingress_endpoint" {
  description = "The public endpoint for accessing Cloud Logs."
  value       = module.code_engine_cloud_logs.cloud_logs_ingress_endpoint
}

output "logs_bucket_name" {
  description = "The name of the COS bucket storing logs data."
  value       = module.code_engine_cloud_logs.logs_bucket_name
}

output "resource_group_name" {
  description = "The name of the resource group containing all resources."
  value       = module.code_engine_cloud_logs.resource_group_name
}