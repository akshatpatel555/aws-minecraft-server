# aws-minecraft-server

**Author:** Akshat Patel  
**Course:** CS312 - Midterm Project Part 2
**Date:** 06/06/2026

---

## Background

This project automates the full provisioning and configuration of a Minecraft Java Edition server (1.21.5) on AWS EC2. Instead of manually clicking through the AWS Console, everything is done through code:

- **Terraform** provisions the AWS infrastructure (EC2 instance, security group)
- **Ansible** configures the server (installs Java, downloads Minecraft, sets up auto-start)
- **run.sh** ties everything together into a single command

---

## Requirements

### Tools

| Tool | Install |
|------|---------|
| Terraform | [terraform.io](https://developer.hashicorp.com/terraform/install) |
| Ansible | `sudo apt install ansible -y` |
| AWS CLI | [aws.amazon.com/cli](https://aws.amazon.com/cli/) |
| nmap | `sudo apt install nmap -y` |
| Git | [git-scm.com](https://git-scm.com) |
| WSL | `wsl --install -d Ubuntu` |

### AWS Credentials

I retrieved my AWS credentials from AWS Academy.

```bash
aws configure
aws configure set aws_session_token <YOUR_SESSION_TOKEN>
```

### Environment

All commands were ran on **WSL (Windows Subsystem for Linux)** on Windows.

---

## Deployment Steps

### 1. Clone the repository

```bash
git clone https://github.com/akshatpatel555/aws-minecraft-server.git
cd aws-minecraft-server
```

### 2. Configure AWS credentials

Retrieve credentials from AWS Academy Learner Lab and run:

```bash
aws configure
aws configure set aws_session_token <YOUR_SESSION_TOKEN>
```

### 3. Add your SSH key

Place your `myKeyPair.pem` file in `~/.ssh/` and set permissions:

```bash
chmod 400 ~/.ssh/myKeyPair.pem
```

### 4. Run the deployment

```bash
chmod +x run.sh
./run.sh
```

This will:
1. Initialize and apply Terraform to provision AWS resources
2. Wait for the EC2 instance to boot
3. Run the Ansible playbook to configure the server
4. Verify the server is reachable with nmap

### 5. Verify the server

At the end of `run.sh`, nmap will automatically verify the server. You can also run it manually:

```bash
nmap -sV -Pn -p T:25565 <SERVER_IP>
```

Expected output:
PORT      STATE  SERVICE   VERSION
25565/tcp open   minecraft Minecraft 1.21.5

---

## Connecting to the Minecraft Server
1. Install and launch Minecraft Launcher
2. Go to **Minecraft: Java Edition** and click on **Installations** tab.
3. Click **New Installation** and pick version `release 1.21.5`
4. Launch the game
5. Go to **Multiplayer** → **Add Server**
6. Enter the server IP output by `run.sh`
7. Click **Done** and connect

---

## Teardown

To destroy all AWS resources when done:

```bash
cd terraform
terraform destroy -auto-approve
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Ansible can't connect | Wait longer for EC2 to boot, increase sleep in run.sh |
| nmap shows port closed | Check security group has port 25565 open |
| Terraform credential error | Re-run `aws configure` with fresh Academy credentials |
| Minecraft won't start | SSH in and check `sudo systemctl status minecraft` |

---

## Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Minecraft Server Download](https://www.minecraft.net/en-us/download/server)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [systemd Service Documentation](https://manpages.ubuntu.com/manpages/noble/man5/systemd.service.5.html)