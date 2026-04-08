# Basic Example - Code Engine with Cloud Logs

This example demonstrates the simplest deployment of IBM Code Engine with IBM Cloud Logs integration.

## What This Example Creates

- **Resource Group**: A new resource group (or uses existing)
- **Code Engine Project**: An empty project ready for workload deployment
- **IBM Cloud Logs Instance**: A logging service with standard plan
- **Cloud Object Storage**: Instance with two buckets (logs and metrics)
- **Log Routing**: Automatic platform logs routing from Code Engine to Cloud Logs

## Prerequisites

- IBM Cloud account
- IBM Cloud API key with appropriate permissions
- Terraform >= 1.9.0

## Usage

1. **Set your IBM Cloud API key**:
   ```bash
   export TF_VAR_ibmcloud_api_key="your-api-key-here"
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review the plan**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

5. **View the outputs**:
   ```bash
   terraform output
   ```

## Customization

You can customize the deployment by setting variables:

```bash
# Deploy to a different region
terraform apply -var="region=eu-gb"

# Use a custom prefix
terraform apply -var="prefix=my-app"

# Use an existing resource group
terraform apply -var="resource_group=my-existing-rg"
```

## What Happens After Deployment

1. **Code Engine Project** is created and ready for workloads
2. **Cloud Logs** is configured to receive logs
3. **Log Routing** is automatically set up
4. Any Code Engine apps or jobs you deploy will automatically send logs to Cloud Logs

## Next Steps

### Deploy a Sample Application

After the infrastructure is ready, deploy a sample Code Engine application:

```hcl
resource "ibm_code_engine_app" "hello_world" {
  project_id      = module.code_engine_cloud_logs.code_engine_project_id
  name            = "hello-world"
  image_reference = "icr.io/codeengine/helloworld"
  
  scale_cpu_limit    = "1"
  scale_memory_limit = "4G"
}
```

### View Logs in Cloud Logs

1. Go to IBM Cloud Console
2. Navigate to **Observability** > **Logging** > **IBM Cloud Logs**
3. Select your Cloud Logs instance
4. Search for logs from your Code Engine application

## Clean Up

To destroy all resources:

```bash
terraform destroy
```

## Estimated Costs

For this basic example with minimal usage:

- **Code Engine Project**: Free (no workloads deployed)
- **Cloud Logs**: ~$0.50/GB ingested + $0.02/GB stored
- **Cloud Object Storage**: ~$0.023/GB stored

**Total for 1GB logs/month**: ~$0.54/month

## Troubleshooting

### Logs not appearing?

Wait 5-10 minutes after deployment for the log routing to fully propagate.

### Permission errors?

Ensure your API key has:
- Editor role on Resource Group
- Editor role on Code Engine
- Editor role on Cloud Logs
- Editor role on Cloud Object Storage

## Support

For issues:
- [IBM Cloud Logs Documentation](https://cloud.ibm.com/docs/cloud-logs)
- [Code Engine Documentation](https://cloud.ibm.com/docs/codeengine)