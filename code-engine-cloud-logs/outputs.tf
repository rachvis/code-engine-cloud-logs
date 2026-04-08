########################################################################################################################
# Outputs
########################################################################################################################

########################################################################################################################
# Resource Group Outputs
########################################################################################################################

output "resource_group_id" {
  description = "The ID of the resource group where all resources are deployed."
  value       = module.resource_group.resource_group_id
}

output "resource_group_name" {
  description = "The name of the resource group where all resources are deployed."
  value       = module.resource_group.resource_group_name
}

########################################################################################################################
# Code Engine Outputs
########################################################################################################################

output "code_engine_project_id" {
  description = "The ID of the Code Engine project."
  value       = module.code_engine.project_id
}

output "code_engine_project_name" {
  description = "The name of the Code Engine project."
  value       = "${var.prefix}-code-engine-project"
}

output "code_engine_project_region" {
  description = "The region where the Code Engine project is deployed."
  value       = var.region
}

########################################################################################################################
# Cloud Logs Outputs
########################################################################################################################

output "cloud_logs_crn" {
  description = "The CRN of the IBM Cloud Logs instance."
  value       = module.cloud_logs.crn
}

output "cloud_logs_guid" {
  description = "The GUID of the IBM Cloud Logs instance."
  value       = module.cloud_logs.guid
}

output "cloud_logs_name" {
  description = "The name of the IBM Cloud Logs instance."
  value       = module.cloud_logs.name
}

output "cloud_logs_ingress_endpoint" {
  description = "The public ingress endpoint of the IBM Cloud Logs instance."
  value       = module.cloud_logs.ingress_endpoint
}

output "cloud_logs_ingress_private_endpoint" {
  description = "The private ingress endpoint of the IBM Cloud Logs instance."
  value       = module.cloud_logs.ingress_private_endpoint
}

output "cloud_logs_region" {
  description = "The region where the Cloud Logs instance is deployed."
  value       = var.region
}

########################################################################################################################
# Cloud Object Storage Outputs
########################################################################################################################

output "cos_instance_id" {
  description = "The ID of the Cloud Object Storage instance."
  value       = module.cos.cos_instance_id
}

output "cos_instance_guid" {
  description = "The GUID of the Cloud Object Storage instance."
  value       = module.cos.cos_instance_guid
}

output "logs_bucket_name" {
  description = "The name of the COS bucket storing logs data."
  value       = local.logs_bucket_name
}

output "logs_bucket_crn" {
  description = "The CRN of the COS bucket storing logs data."
  value       = module.cos_buckets.buckets[local.logs_bucket_name].bucket_crn
}

output "metrics_bucket_name" {
  description = "The name of the COS bucket storing metrics data."
  value       = local.metrics_bucket_name
}

output "metrics_bucket_crn" {
  description = "The CRN of the COS bucket storing metrics data."
  value       = module.cos_buckets.buckets[local.metrics_bucket_name].bucket_crn
}

########################################################################################################################
# Platform Logs Configuration Outputs
########################################################################################################################

output "platform_logs_enabled" {
  description = "Indicates whether platform logs routing is enabled."
  value       = var.enable_platform_logs
}

output "log_routing_tenant_region" {
  description = "The region where the log routing tenant is configured (if platform logs are enabled)."
  value       = var.enable_platform_logs ? var.region : null
}

########################################################################################################################
# CBR Outputs
########################################################################################################################

output "cbr_rules_enabled" {
  description = "Indicates whether Context-Based Restrictions are enabled."
  value       = var.enable_cbr_rules
}

output "cbr_zone_id" {
  description = "The ID of the CBR zone (if CBR is enabled)."
  value       = var.enable_cbr_rules ? module.cbr_zone[0].zone_id : null
}