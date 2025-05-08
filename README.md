# Simple Mario Game With MIG Backend

This project deploys a scalable web application using Infrastructure as Code (IaC) on Google Cloud Platform using Terraform. 
It creates a VPC network, Managed Instance Group (MIG) running a lightwieght Mario game web app, and a global HTTP load balancer. 
This project is designed to run from the Google Cloud Shell using a user-friendly startup script. Simply clone this repository, run the script (following the prompts), and let Terraform do the rest!

## Architecture

- **VPC Network** with custom subnet and firewall rules
- **Managed Instance Group** with autoscaling (2-5 instances)
- **Global HTTP Load Balancer** for traffic distribution
- **Cloud NAT** for internet egress from private instances
- **IAP-protected SSH access** to instances
- **Service Account** with minimal required permissions

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
- Display a link to the newly created website at the end of the output. Please note that it may take several minutes for the website to go live.

## Cleanup

To destroy all resources:

```bash
terraform destroy
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

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
