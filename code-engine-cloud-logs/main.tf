########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.7"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

########################################################################################################################
# Cloud Object Storage Instance and Buckets
########################################################################################################################

module "cos" {
  source            = "terraform-ibm-modules/cos/ibm"
  version           = "10.12.0"
  resource_group_id = module.resource_group.resource_group_id
  cos_instance_name = "${var.prefix}-cos"
  cos_tags          = var.resource_tags
  create_cos_bucket = false
}

locals {
  logs_bucket_name    = "${var.prefix}-logs-data"
  metrics_bucket_name = "${var.prefix}-metrics-data"
}

module "cos_buckets" {
  source  = "terraform-ibm-modules/cos/ibm//modules/buckets"
  version = "10.12.0"
  bucket_configs = [
    {
      bucket_name            = local.logs_bucket_name
      kms_encryption_enabled = false
      region_location        = var.region
      resource_instance_id   = module.cos.cos_instance_id
      resource_group_id      = module.resource_group.resource_group_id
    },
    {
      bucket_name            = local.metrics_bucket_name
      kms_encryption_enabled = false
      region_location        = var.region
      resource_instance_id   = module.cos.cos_instance_id
      resource_group_id      = module.resource_group.resource_group_id
    }
  ]
}

########################################################################################################################
# IBM Cloud Logs Instance
########################################################################################################################

module "cloud_logs" {
  source            = "terraform-ibm-modules/cloud-logs/ibm"
  version           = "1.11.0"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  instance_name     = "${var.prefix}-cloud-logs"
  plan              = var.cloud_logs_plan
  resource_tags     = var.resource_tags
  access_tags       = var.access_tags
  retention_period  = var.retention_period
  service_endpoints = var.service_endpoints

  # Configure data storage with COS buckets
  data_storage = {
    logs_data = {
      enabled         = true
      bucket_crn      = module.cos_buckets.buckets[local.logs_bucket_name].bucket_crn
      bucket_endpoint = module.cos_buckets.buckets[local.logs_bucket_name].s3_endpoint_direct
    }
    metrics_data = {
      enabled         = true
      bucket_crn      = module.cos_buckets.buckets[local.metrics_bucket_name].bucket_crn
      bucket_endpoint = module.cos_buckets.buckets[local.metrics_bucket_name].s3_endpoint_direct
    }
  }

  # Enable platform logs routing if specified
  logs_routing_tenant_regions = var.enable_platform_logs ? [var.region] : []

  # Optional CBR rules
  cbr_rules = var.enable_cbr_rules ? [
    {
      description      = "${var.prefix}-cloud-logs-cbr-rule"
      enforcement_mode = var.cbr_enforcement_mode
      account_id       = data.ibm_iam_account_settings.iam_account_settings.account_id
      rule_contexts = [
        {
          attributes = [
            {
              name  = "endpointType"
              value = "public"
            },
            {
              name  = "networkZoneId"
              value = module.cbr_zone[0].zone_id
            }
          ]
        }
      ]
      operations = [
        {
          api_types = [
            {
              api_type_id = "crn:v1:bluemix:public:context-based-restrictions::::platform-api-type:"
            }
          ]
        }
      ]
    }
  ] : []
}

########################################################################################################################
# Code Engine Project
########################################################################################################################

module "code_engine" {
  source            = "terraform-ibm-modules/code-engine/ibm"
  version           = "4.7.26"
  resource_group_id = module.resource_group.resource_group_id
  project_name      = "${var.prefix}-code-engine-project"

  # Optional CBR rules for Code Engine
  cbr_rules = var.enable_cbr_rules ? [
    {
      description      = "${var.prefix}-code-engine-cbr-rule"
      enforcement_mode = var.cbr_enforcement_mode
      account_id       = data.ibm_iam_account_settings.iam_account_settings.account_id
      rule_contexts = [
        {
          attributes = [
            {
              name  = "endpointType"
              value = "public"
            },
            {
              name  = "networkZoneId"
              value = module.cbr_zone[0].zone_id
            }
          ]
        }
      ]
      operations = [
        {
          api_types = [
            {
              api_type_id = "crn:v1:bluemix:public:context-based-restrictions::::platform-api-type:"
            }
          ]
        }
      ]
    }
  ] : []
}

########################################################################################################################
# Context-Based Restrictions (Optional)
########################################################################################################################

data "ibm_iam_account_settings" "iam_account_settings" {
}

# Create a CBR zone if CBR is enabled
module "cbr_zone" {
  count            = var.enable_cbr_rules ? 1 : 0
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module"
  version          = "1.35.13"
  name             = "${var.prefix}-cbr-zone"
  zone_description = "CBR zone for Code Engine and Cloud Logs"
  account_id       = data.ibm_iam_account_settings.iam_account_settings.account_id
  addresses = [
    {
      type = "ipRange"
      value = var.cbr_allowed_ip_range
    }
  ]
}