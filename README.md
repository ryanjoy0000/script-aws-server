# AWS EC2 Instance Automation Script

This repository contains a Bash script designed to automate the creation and configuration of an AWS EC2 instance. The script performs the following tasks:

- Creates a new key pair and security group.
- Configures the security group to allow SSH and HTTP access.
- Launches a new EC2 instance based on a specified Amazon Machine Image (AMI).
- Installs Docker, Python 3, and Nginx on the instance.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Script Overview](#script-overview)
- [Usage](#usage)
- [Features](#features)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

To use this script, ensure you have the following:

- **AWS CLI**: Installed and configured with the necessary permissions to create EC2 instances, security groups, and key pairs.
- **Bash Shell**: Required to execute the script.
- **AWS Account**: With access to the EC2 service and appropriate permissions.

## Script Overview

This automation script performs the following steps:

1. **Creates a Key Pair**: Generates a unique key pair to securely connect to the EC2 instance.
2. **Creates a Security Group**: Defines a new security group and configures it for SSH and HTTP access.
3. **Launches EC2 Instance**: Starts a new EC2 instance with the specified AMI, instance type, and security group.
4. **Installs Required Software**: Automatically connects to the instance and installs Docker, Python 3, and Nginx.

## Usage

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/repo-name.git
   cd repo-name
   ```

2. **Make the Script Executable:**

   ```bash
   chmod +x your-script.sh
   ```

3. **Run the Script:**

   ```bash
   ./your-script.sh
   ```

4. **Follow the Output**: Monitor the terminal output for real-time status updates on key creation, security group configuration, instance launch, and software installation.

## Features

- **Error Handling**: Provides meaningful error messages for troubleshooting.
- **Automated Software Installation**: Installs Docker, Python 3, and Nginx on the EC2 instance.
- **Security Best Practices**: Sets appropriate file permissions for key pairs and configures security groups for safe access.

## Troubleshooting

- **Connection Refused Error**: Ensure the security group rules are correctly set to allow SSH access (port 22). Verify the EC2 instance's public IP and that your local IP is not blocked.
- **Permission Denied**: Confirm that the private key (`*.pem` file) has the correct permissions (`chmod 400`).

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any bug fixes, feature enhancements, or improvements.

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature-name`.
3. Commit your changes: `git commit -m 'Add your feature'`.
4. Push to the branch: `git push origin feature/your-feature-name`.
5. Open a pull request.

