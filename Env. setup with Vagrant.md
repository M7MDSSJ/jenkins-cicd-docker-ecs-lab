# Vagrant Provisioning Guide

This guide sets up the local environment using **Vagrant** to run **Jenkins** and **SonarQube** VMs.  
No Nexus VM is needed — artifacts are pushed directly to **AWS ECR**.

### VMs Created

| VM Name     | Box Image       | Hostname        | Private IP      | RAM  | CPUs | Provision Script |
|-------------|-----------------|-----------------|-----------------|------|------|------------------|
| jenkins     | ubuntu/jammy64  | jenkins-lab     | 192.168.33.13   | 2048 | 2    | jenkins.sh       |
| sonarqube   | ubuntu/jammy64  | sonarqube-lab   | 192.168.33.12   | 4096 | 2    | sonarqube.sh     |

### Prerequisites

- VirtualBox (latest version recommended)
- Vagrant (latest version)
- Host machine with at least 8–12 GB RAM free

### Steps to Start

1. Clone the repository
2. Go to the project root
3. Make sure the `scripts/` folder contains:
   - `Vagrantfile`
   - `jenkins.sh`
   - `sonarqube.sh`
4. Run:

```bash
vagrant up
```

This will:
- Download Ubuntu 22.04 boxes (if not cached)
- Create two VMs with private network IPs
- Execute the provisioning scripts

Provisioning time: ~10–25 minutes depending on internet speed.

### Post-Provisioning Steps (Important!)

After `vagrant up` finishes, you **must** prepare Docker & AWS CLI inside the Jenkins VM:

1. SSH into Jenkins VM:

```bash
vagrant ssh jenkins
```

2. Install Docker and add jenkins user to docker group:

```bash
sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker jenkins
sudo systemctl enable docker --now
```

3. Install AWS CLI v2:

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws
```

4. Log out and back in (or reboot the VM) so group membership takes effect:

```bash
exit
vagrant ssh jenkins
```

5. Verify installations:

```bash
docker --version
aws --version
groups   # should include "docker"
```

### Service Access

| Service    | URL                             | Initial Credentials / Notes                  |
|------------|---------------------------------|----------------------------------------------|
| Jenkins    | http://192.168.33.13:8080      | Get initial password from console output     |
| SonarQube  | http://192.168.33.12           | Default: admin / admin → change immediately  |

### Cleanup Commands

- Stop VMs:

```bash
vagrant halt
```

- Destroy VMs (when done with lab):

```bash
vagrant destroy -f
```
