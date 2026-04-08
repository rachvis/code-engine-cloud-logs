# IBM Code Engine with IBM Cloud Logs - Deployable Architecture

This Terraform module creates a complete infrastructure for IBM Code Engine with integrated IBM Cloud Logs for centralized logging and monitoring.

## Architecture Overview

This deployable architecture provisions:

- **IBM Code Engine Project**: A serverless container platform ready for deploying applications and jobs
- **IBM Cloud Logs Instance**: A centralized logging service for collecting and analyzing logs
- **Cloud Object Storage**: Two buckets for storing logs data and metrics data
- **Log Routing**: Automatic platform logs routing from Code Engine to Cloud Logs
- **Optional CBR Rules**: Context-Based Restrictions for enhanced security

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    IBM Cloud Account                         │
│                                                              │
│  ┌────────────────────┐         ┌─────────────────────┐    │
│  │  Code Engine       │         │  IBM Cloud Logs     │    │
│  │  Project           │────────▶│  Instance           │    │
│  │                    │  Logs   │                     │    │
│  └────────────────────┘         └──────────┬──────────┘    │
│                                             │                │
│                                             │                │
│                                             ▼                │
│                                  ┌─────────────────────┐    │
│                                  │  Cloud Object       │    │
│                                  │  Storage            │    │
│                                  │  ┌───────────────┐  │    │
│                                  │  │ Logs Bucket   │  │    │
│                                  │  └───────────────┘  │    │
│                                  │  ┌───────────────┐  │    │
│                                  │  │ Metrics Bucket│  │    │
│                                  │  └───────────────┘  │    │
│                                  └─────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## How It Works

### Automatic Log Integration

When you deploy this architecture:

1. **Code Engine Project** is created in your specified region
2. **Cloud Logs Instance** is provisioned with data storage configured
3. **Log Routing Tenant** is automatically created in the same region
4. **Platform Logs** from Code Engine are automatically routed to Cloud Logs

**No additional configuration needed!** Code Engine applications, jobs, and builds will automatically send their logs to the Cloud Logs instance through IBM Cloud's platform logging infrastructure.

### What Gets Logged

Code Engine automatically sends the following logs to Cloud Logs:

- **Application logs**: stdout/stderr from running containers
- **Job logs**: Execution logs from batch jobs
- **Build logs**: Container image build output
- **System logs**: Platform events and status changes

## Prerequisites

- IBM Cloud account with appropriate permissions
- IBM Cloud API key with the following access:
  - Editor role on Resource Group
  - Editor role on Code Engine service
  - Editor role on Cloud Logs service
  - Editor role on Cloud Object Storage service
  - Editor role on IAM Access Groups (if using CBR)
- Terraform >= 1.9.0
- IBM Cloud Terraform Provider >= 1.80.0

## Usage

### Basic Example

```hcl
module "code_engine_cloud_logs" {
  source = "./code-engine-cloud-logs"

  ibmcloud_api_key = var.ibmcloud_api_key
  region           = "us-south"
  prefix           = "my-app"
  resource_group   = "default"
}
```

### Complete Example with All Options

```hcl
module "code_engine_cloud_logs" {
  source = "./code-engine-cloud-logs"

  # Required
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = "us-south"
  
  # Resource naming and organization
  prefix         = "my-app"
  resource_group = "my-resource-group"
  resource_tags  = ["env:production", "team:platform"]
  access_tags    = ["project:myapp"]
  
  # Cloud Logs configuration
  cloud_logs_plan    = "standard"
  retention_period   = 30
  service_endpoints  = "public-and-private"
  enable_platform_logs = true
  
  # Security (optional)
  enable_cbr_rules      = true
  cbr_enforcement_mode  = "enabled"
  cbr_allowed_ip_range  = "10.0.0.0-10.255.255.255"
}
```

## Input Variables

### Required Variables

| Name | Type | Description |
|------|------|-------------|
| `ibmcloud_api_key` | string | IBM Cloud API key for authentication |

### Optional Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `region` | string | `"us-south"` | IBM Cloud region for deployment |
| `prefix` | string | `"ce-logs"` | Prefix for resource names |
| `resource_group` | string | `null` | Existing resource group name (creates new if null) |
| `resource_tags` | list(string) | `[]` | Tags for cost tracking and organization |
| `access_tags` | list(string) | `[]` | Access management tags |
| `cloud_logs_plan` | string | `"standard"` | Cloud Logs pricing plan |
| `retention_period` | number | `7` | Log retention in days (7, 14, 30, 60, 90) |
| `service_endpoints` | string | `"public-and-private"` | Service endpoint type |
| `enable_platform_logs` | bool | `true` | Enable automatic log routing |
| `enable_cbr_rules` | bool | `false` | Enable Context-Based Restrictions |
| `cbr_enforcement_mode` | string | `"report"` | CBR enforcement mode (enabled/disabled/report) |
| `cbr_allowed_ip_range` | string | `"0.0.0.0-255.255.255.255"` | Allowed IP range for CBR |

## Outputs

### Code Engine Outputs

| Name | Description |
|------|-------------|
| `code_engine_project_id` | The ID of the Code Engine project |
| `code_engine_project_name` | The name of the Code Engine project |
| `code_engine_project_region` | The region where Code Engine is deployed |

### Cloud Logs Outputs

| Name | Description |
|------|-------------|
| `cloud_logs_crn` | The CRN of the Cloud Logs instance |
| `cloud_logs_guid` | The GUID of the Cloud Logs instance |
| `cloud_logs_name` | The name of the Cloud Logs instance |
| `cloud_logs_ingress_endpoint` | Public ingress endpoint |
| `cloud_logs_ingress_private_endpoint` | Private ingress endpoint |

### Storage Outputs

| Name | Description |
|------|-------------|
| `cos_instance_id` | Cloud Object Storage instance ID |
| `logs_bucket_name` | Name of the logs data bucket |
| `logs_bucket_crn` | CRN of the logs data bucket |
| `metrics_bucket_name` | Name of the metrics data bucket |
| `metrics_bucket_crn` | CRN of the metrics data bucket |

## Deployment Steps

1. **Clone or download this module**

2. **Set your IBM Cloud API key**
   ```bash
   export TF_VAR_ibmcloud_api_key="your-api-key-here"
   ```

3. **Initialize Terraform**
   ```bash
   cd code-engine-cloud-logs
   terraform init
   ```

4. **Review the plan**
   ```bash
   terraform plan
   ```

5. **Apply the configuration**
   ```bash
   terraform apply
   ```

6. **View outputs**
   ```bash
   terraform output
   ```

## Accessing Logs

After deployment, you can access your Code Engine logs in several ways:

### Via IBM Cloud Console

1. Navigate to **Observability** > **Logging** > **IBM Cloud Logs**
2. Select your Cloud Logs instance
3. Use the query interface to search and filter logs
4. Filter by `applicationName` to see Code Engine logs

### Via Cloud Logs API

Use the ingress endpoints from the outputs:
```bash
# Get the endpoint
terraform output cloud_logs_ingress_endpoint

# Query logs using the Cloud Logs API
curl -X POST "https://<endpoint>/v1/logs/query" \
  -H "Authorization: Bearer $IAM_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "applicationName:code-engine"}'
```

### Via IBM Cloud CLI

```bash
# Install the Cloud Logs plugin
ibmcloud plugin install cloud-logs

# Set the target instance
ibmcloud cloud-logs instance-set <instance-guid>

# Query logs
ibmcloud cloud-logs query --query "applicationName:code-engine"
```

## Adding Code Engine Workloads

After deploying this infrastructure, you can add Code Engine applications and jobs:

### Deploy an Application

```hcl
resource "ibm_code_engine_app" "example" {
  project_id      = module.code_engine_cloud_logs.code_engine_project_id
  name            = "my-app"
  image_reference = "icr.io/codeengine/helloworld"
  
  scale_cpu_limit    = "1"
  scale_memory_limit = "4G"
}
```

### Deploy a Job

```hcl
resource "ibm_code_engine_job" "example" {
  project_id      = module.code_engine_cloud_logs.code_engine_project_id
  name            = "my-job"
  image_reference = "icr.io/codeengine/helloworld"
  
  run_mode = "task"
}
```

## Cost Estimation

Approximate monthly costs (US South region):

- **Code Engine Project**: Free (pay only for workload resources)
- **Cloud Logs Standard**: ~$0.50/GB ingested + $0.02/GB stored
- **Cloud Object Storage**: ~$0.023/GB stored
- **Log Routing**: No additional charge

**Example**: For 10GB logs/month with 30-day retention:
- Cloud Logs: ~$5.60/month
- COS Storage: ~$0.23/month
- **Total**: ~$5.83/month

## Security Considerations

### Context-Based Restrictions (CBR)

Enable CBR for production environments:

```hcl
enable_cbr_rules     = true
cbr_enforcement_mode = "enabled"
cbr_allowed_ip_range = "10.0.0.0-10.255.255.255"
```

### Service Endpoints

Use private endpoints for enhanced security:

```hcl
service_endpoints = "public-and-private"
```

Then configure your Code Engine apps to use private endpoints.

### Access Management

Use access tags to control who can view logs:

```hcl
access_tags = ["project:myapp", "env:production"]
```

## Troubleshooting

### Logs Not Appearing in Cloud Logs

1. **Check log routing tenant**: Verify it's created in the correct region
   ```bash
   ibmcloud logs-router tenant ls
   ```

2. **Verify Code Engine is generating logs**: Check in Code Engine console

3. **Check IAM permissions**: Ensure proper authorization policies exist

4. **Wait for propagation**: Logs may take 5-10 minutes to appear initially

### CBR Blocking Access

If CBR rules are too restrictive:

1. Temporarily set enforcement mode to `report`:
   ```hcl
   cbr_enforcement_mode = "report"
   ```

2. Review CBR logs to identify blocked requests

3. Adjust IP ranges or add additional zones

## Module Dependencies

This module uses the following IBM Terraform modules:

- [terraform-ibm-modules/resource-group/ibm](https://github.com/terraform-ibm-modules/terraform-ibm-resource-group) v1.4.7
- [terraform-ibm-modules/cos/ibm](https://github.com/terraform-ibm-modules/terraform-ibm-cos) v10.12.0
- [terraform-ibm-modules/cloud-logs/ibm](https://github.com/terraform-ibm-modules/terraform-ibm-cloud-logs) v1.11.0
- [terraform-ibm-modules/code-engine/ibm](https://github.com/terraform-ibm-modules/terraform-ibm-code-engine) v4.7.26
- [terraform-ibm-modules/cbr/ibm](https://github.com/terraform-ibm-modules/terraform-ibm-cbr) v1.35.13

## Support

For issues and questions:

- **IBM Cloud Logs**: [Documentation](https://cloud.ibm.com/docs/cloud-logs)
- **Code Engine**: [Documentation](https://cloud.ibm.com/docs/codeengine)
- **Terraform IBM Modules**: [GitHub](https://github.com/terraform-ibm-modules)

## License

Apache License 2.0

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.