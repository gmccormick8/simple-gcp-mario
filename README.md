# Simple Mario Game With MIG Backend Project

[![Run Super Linter](https://github.com/gmccormick8/simple-gcp-mario/actions/workflows/super-linter.yml/badge.svg?branch=main)](https://github.com/gmccormick8/simple-gcp-mario/actions/workflows/super-linter.yml)

This project deploys a scalable web application using Infrastructure as Code (IaC) on Google Cloud Platform using Terraform.
It creates a VPC network, Managed Instance Group (MIG) running a lightwieght Mario game web app, and a global HTTP load balancer.
This project is designed to run from the Google Cloud Shell using a user-friendly startup script. Simply clone this repository, run the script (following the prompts), and let Terraform do the rest!

## Architecture

- **VPC Network** with custom subnet and firewall rules
  - VPC Flow Logging enabled with 5-second intervals
  - Full metadata collection for network analysis
- **Managed Instance Group** with autoscaling (1-5 instances)
- **Global HTTP Load Balancer** for traffic distribution
- **Cloud NAT** for internet egress from private instances
- **IAP-protected SSH access** to instances
- **Service Account** with minimal required permissions
- **Shielded VMs** with secure boot and integrity monitoring

## Credits

This project uses the [Mario Game](https://github.com/anndcodes/mario-game) repository created by [anndcodes](https://github.com/anndcodes). The game is deployed on each instance as a demo web application.

## Prerequisites

1. Google Cloud Platform account
2. [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed - Preinstalled in Google Cloud Shell
3. [Terraform](https://www.terraform.io/downloads.html) >= 1.11.0 installed - Terraform is preinstalled in Google Cloud Shell.
4. Active GCP project with billing enabled
5. It is recommended to run this project from the [Google Cloud Shell](https://cloud.google.com/shell/docs/using-cloud-shell)

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
   git clone https://github.com/gmccormick8/simple-gcp-mario.git && cd simple-gcp-mario
   ```

3. Run setup script to initialize the project (enter "y" when prompted):

   ```bash
   bash setup.sh
   ```

The setup script will:

- Verify and update Terraform if needed
- Enable required Google Cloud APIs
- Initialize Terraform
- Create and apply the Terraform configuration
<!-- textlint-disable -->
- Display a link to the newly created website at the end of the output. Please note that it may take several minutes for the website to go live.
<!-- textlint-enable -->

## Cleanup

To destroy all resources (enter "yes" when prompted):

```bash
terraform destroy
```

## Module Structure

### Network Module (`./modules/network`)

- Creates VPC network and subnets
- Configures firewall rules
- Sets up Cloud NAT and Cloud Router
- Enables VPC Flow Logging with:
  - 5-second aggregation intervals
  - 50% sampling rate
  - Full metadata collection

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
- Shielded VM features:
  - Secure Boot enabled
  - vTPM enabled
  - Integrity monitoring enabled
- VPC Flow Logging for network security monitoring

## Cost Considerations

This setup uses:

- e2-micro instances (1-5 instances)
  - ~$6.11/month per instance
- Standard persistent disks
  - ~$0.04/GB/month
- Global load balancer
  - ~$18/month for the forwarding rule
  - ~$0.008/GB processed
- Cloud NAT
  - ~$0.045/hour when in use
- Network egress
  - $0.085/GB to $0.23/GB depending on region

Total estimated monthly cost: $30-100 USD depending on:
- Number of active instances
- Amount of traffic processed
- Data transfer volumes
- Region selection

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
