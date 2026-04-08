# IBM Cloud Private Catalog Import Instructions

## Overview
This package contains a deployable architecture for **IBM Code Engine with IBM Cloud Logs** that can be imported into IBM Cloud Private Catalog.

## Package Contents
- **code-engine-cloud-logs.tar.gz** - The deployable architecture package (11KB)
- All Terraform configuration files (main.tf, variables.tf, outputs.tf, etc.)
- IBM Catalog metadata (ibm_catalog.json)
- Documentation (README.md)
- Example configurations (examples/basic/)

## Import Steps

### 1. Access IBM Cloud Private Catalog
1. Log in to [IBM Cloud Console](https://cloud.ibm.com)
2. Navigate to **Manage** > **Catalogs** > **Private catalogs**
3. Select your private catalog or create a new one

### 2. Import the Offering
1. Click **Private products** tab
2. Click **Add** button
3. Select **Import from .tgz**
4. Upload the **code-engine-cloud-logs.tar.gz** file
5. Click **Add product**

### 3. Configure the Offering
The import process will automatically:
- Extract the Terraform configuration
- Parse the `ibm_catalog.json` metadata
- Configure input variables and outputs
- Set up IAM permissions requirements

### 4. Validate the Offering
1. After import, click on the offering
2. Go to **Validate** tab
3. Configure required variables:
   - `ibmcloud_api_key` - Your IBM Cloud API key
   - `region` - Target deployment region (default: us-south)
   - `prefix` - Resource name prefix (default: ce-logs)
4. Click **Validate** to test deployment
5. Review validation results

### 5. Publish to Catalog
1. Once validation succeeds, go to **Actions** menu
2. Click **Publish to account**
3. The offering will be available to authorized users in your account

## What Gets Deployed

When users deploy this offering from your private catalog, it creates:

- **IBM Code Engine Project** - Serverless container platform
- **IBM Cloud Logs Instance** - Centralized logging service
- **Cloud Object Storage** - Two buckets for logs and metrics data
- **Log Routing Tenant** - Automatic platform logs routing
- **Optional CBR Rules** - Context-Based Restrictions for security

## User Configuration Options

Users can customize the deployment with these variables:

### Required
- `ibmcloud_api_key` - IBM Cloud API key

### Optional
- `region` - Deployment region (default: us-south)
- `prefix` - Resource name prefix (default: ce-logs)
- `resource_group` - Existing resource group name
- `resource_tags` - Tags for cost tracking
- `access_tags` - Access management tags
- `cloud_logs_plan` - Cloud Logs pricing plan (default: standard)
- `retention_period` - Log retention in days (7, 14, 30, 60, 90)
- `service_endpoints` - Endpoint type (default: public-and-private)
- `enable_platform_logs` - Enable automatic log routing (default: true)
- `enable_cbr_rules` - Enable Context-Based Restrictions (default: false)
- `cbr_enforcement_mode` - CBR enforcement mode (default: report)
- `cbr_allowed_ip_range` - Allowed IP range for CBR

## IAM Permissions Required

Users deploying this offering need the following IAM roles:

- **Editor** role on Code Engine service
- **Editor** role on Cloud Logs service
- **Editor** role on Cloud Object Storage service
- **Editor** role on Logs Router service
- **Editor** role on Resource Group (if creating new)

## Cost Estimation

Approximate monthly costs (US South region):
- Code Engine Project: Free (pay only for workload resources)
- Cloud Logs Standard: ~$0.50/GB ingested + $0.02/GB stored
- Cloud Object Storage: ~$0.023/GB stored
- Log Routing: No additional charge

**Example**: For 10GB logs/month with 30-day retention:
- Cloud Logs: ~$5.60/month
- COS Storage: ~$0.23/month
- **Total**: ~$5.83/month

## Support and Documentation

- **IBM Cloud Logs**: https://cloud.ibm.com/docs/cloud-logs
- **Code Engine**: https://cloud.ibm.com/docs/codeengine
- **Private Catalog**: https://cloud.ibm.com/docs/account?topic=account-restrict-by-user

## Troubleshooting

### Import Fails
- Verify the tar.gz file is not corrupted
- Check that ibm_catalog.json is valid JSON
- Ensure you have Catalog Manager permissions

### Validation Fails
- Verify API key has required IAM permissions
- Check that selected region supports all services
- Review Terraform logs in validation output

### Deployment Issues
- Ensure resource group exists (if specified)
- Verify no naming conflicts with existing resources
- Check service availability in selected region

## Version Information

- **Terraform Version**: >= 1.9.0
- **IBM Provider Version**: >= 1.80.0, < 2.0.0
- **Module Dependencies**:
  - terraform-ibm-modules/resource-group/ibm v1.4.7
  - terraform-ibm-modules/cos/ibm v10.12.0
  - terraform-ibm-modules/cloud-logs/ibm v1.11.0
  - terraform-ibm-modules/code-engine/ibm v4.7.26
  - terraform-ibm-modules/cbr/ibm v1.35.13

## Next Steps After Import

1. **Test the offering** - Run validation with test parameters
2. **Set visibility** - Configure who can see and use the offering
3. **Add documentation** - Customize README for your organization
4. **Set up notifications** - Configure alerts for deployments
5. **Monitor usage** - Track deployments and costs

## License

Apache License 2.0