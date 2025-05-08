# Simple GCP VM with Load Balancer

This project deploys a scalable web application infrastructure on Google Cloud Platform using Terraform. It creates a VPC network, managed instance group running a Mario game web app, and a global HTTP load balancer.

## Architecture

- **VPC Network** with custom subnets and firewall rules
- **Managed Instance Group** with autoscaling (2-5 instances)
- **Global HTTP Load Balancer** for traffic distribution
- **Cloud NAT** for internet egress from private instances
- **IAP-protected SSH access** to instances
- **Service Account** with minimal required permissions

## Credits

This project uses the [Mario Game](https://github.com/anndcodes/mario-game) repository created by [anndcodes](https://github.com/anndcodes). The game is deployed on each instance as a demo web application.

## Prerequisites

1. Google Cloud Platform account
2. [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed
3. [Terraform](https://www.terraform.io/downloads.html) >= 1.11.0 installed
4. Active GCP project with billing enabled

## Required GCP APIs

This project requires the following Google Cloud APIs to be enabled:

- Compute Engine API (`compute.googleapis.com`)
- Identity and Access Management (IAM) API (`iam.googleapis.com`)
- Cloud Resource Manager API (`cloudresourcemanager.googleapis.com`)
- Service Usage API (`serviceusage.googleapis.com`)

These APIs will be automatically enabled when you run the `setup.sh` script.

## Quick Start

1. Open Google Cloud Shell or your local terminal

2. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/simple-gcp-vm-db.git
   cd simple-gcp-vm-db
   ```

3. Run the setup script:

   ```bash
   bash setup.sh
   ```

4. After deployment, access the Mario game using the displayed URL:
   ```bash
   terraform output website_url
   ```

## Module Structure

### Network Module (`./modules/network`)

- Creates VPC network and subnets
- Configures firewall rules
- Sets up Cloud NAT and Cloud Router

### Compute Module (`./modules/compute`)

- Deploys managed instance group
- Configures instance template with Mario game
- Implements autoscaling
- Enables OS Login

### Load Balancer Module (`./modules/load-balancer`)

- Creates global HTTP load balancer
- Sets up health checks
- Configures backend services

## Security Features

- Private instances with no public IPs
- IAP-protected SSH access
- Minimal service account permissions
- OS Login enabled by default

## Cost Considerations

This setup uses:

- e2-micro instances (2-5 instances)
- Standard persistent disks
- Global load balancer
- Cloud NAT (pay per use)

Estimated monthly cost: $20-50 USD (varies by usage)

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
