# 🚀 Neo Technologies – DevSecOps Assessment (Ghost CMS Deployment)

This repository showcases a secure, automated deployment of [Ghost CMS](https://ghost.org/) on AWS EC2 using **Terraform**, **Docker**, and **GitHub Actions**. It adheres to **DevSecOps** best practices, including:

- 🔧 Infrastructure as Code (IaC) via Terraform
- 🚫 Secure containerized deployment on EC2
- 🌐 HTTPS with free DNS via Certbot + No-IP
- 🚀 CI/CD using GitHub Actions
- 🔒 SAST with Semgrep
- 💬 Slack integration for security notifications

---

## 🛠️ Features

- 🚀 Ghost CMS deployed automatically to AWS
- ⚖️ Security scans on Terraform files with Semgrep
- 🔧 Dockerized CMS with nginx reverse proxy
- 🌐 HTTPS support via Let's Encrypt
- 📅 Slack notifications for CI pipeline security events

---

## 📁 Project Structure

```bash
Neo_Technologies_Assessment/
├── .github/workflows/         # CI workflows
│   ├── deploy.yaml            # Deploy Terraform infra
│   ├── semgrep.yml            # Semgrep CI scanner
│   └── terraform-scan.yaml    # Terraform-specific scan (optional)
│
├── Diagrams/                  # Architecture & deployment visuals
│   ├── Ghost_Architecture.jpg
│   ├── Deployment_Diagram.jpg
│   └── *.png
│
├── terraform/                 # Infrastructure as Code
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── user_data.sh
│
├── certbot/                   # SSL cert generation
├── nginx/                     # Reverse proxy configuration
│   ├── startup.sh
│   └── templates/
│       ├── full.conf
│       └── http.conf
│
├── docker-compose.yaml        # Container setup
└── README.md                  # Project documentation
```

---

## 🚧 Architecture Overview



- VPC with public subnet (DNS hostnames enabled)
- EC2 Ubuntu instance in `eu-central-1`
- Docker auto-installed via `user_data.sh`
- Ghost CMS container mapped to `80:2368`
- Security group: HTTP, HTTPS, SSH (open for demo purposes)

> **Note**: For production, restrict inbound rules to specific IP ranges.

---

## 📆 Quick Start

1. **Fork & Clone**

   ```bash
   git clone https://github.com/your-username/Neo_Technologies_Assessment.git
   ```

2. **Set GitHub Secrets**

   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_DEFAULT_REGION` (eu-central-1)
   - `EC2_KEY` (e.g. "Riyad")
   - `SEMGREP_APP_TOKEN`
   - `SLACK_WEBHOOK_URL`
   - *(Bonus)* `EC2_USER` (usually `ubuntu`), `EC2_KEY_DEPLOY` (key content)

3. **Push to ****\`\`**** branch** – GitHub Actions will:

   - Deploy EC2 via Terraform
   - Install Ghost CMS via Docker
   - Run Semgrep security scan
   - Notify Slack with scan results

4. **Access your site**

   - Via EC2 Public IP: `http://<public-ip>`
   - Or via custom domain w/ HTTPS: `https://yourdomain.no-ip.org`

---

## 🚀 GitHub Actions – deploy.yaml

```yaml
yaml
name: Deploy Terraform Infra

on:
  push:
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: terraform

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.6.0

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan -var="key_name=${{ secrets.EC2_KEY }}"

      - name: Terraform Apply
        run: terraform apply -auto-approve -var="key_name=${{ secrets.EC2_KEY }}"

    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_DEFAULT_REGION: ${{ secrets.AWS_DEFAULT_REGION }}
```

---

## 🔐 GitHub Secrets Setup

| Secret Name                | Description                     |
| -------------------------- | ------------------------------- |
| `AWS_ACCESS_KEY_ID`        | AWS access key                  |
| `AWS_SECRET_ACCESS_KEY`    | AWS secret access key           |
| `AWS_DEFAULT_REGION`       | Region (e.g., eu-central-1)     |
| `EC2_KEY`                  | EC2 key name in AWS             |
| `SEMGREP_APP_TOKEN`        | Semgrep auth token              |
| `SLACK_WEBHOOK_URL`        | Slack channel webhook URL       |
| `EC2_USER` *(bonus)*       | SSH user (usually `ubuntu`)     |
| `EC2_KEY_DEPLOY` *(bonus)* | Private key content for SCP/SSH |

---

## 💰 Bonus: HTTPS + Domain (No-IP)

1. **Create a No-IP hostname**

   - Go to [NoIP.com](https://www.noip.com/)
   - Sign up > DDNS > Create Hostname
   - Pick free domain, then update IP with EC2 public IP

2. **Update the following files with your domain:**

   - `docker-compose.yaml`

   - `nginx/startup.sh`

   - `nginx/templates/http.conf`

   - `nginx/templates/full.conf`





   > Ensure `proxy_pass http://ghost:2368;` matches container name & port

3. **Certbot will automatically issue certs on first run.**

---

## 📝 Semgrep Setup + Slack Integration

1. Go to [Semgrep](https://semgrep.dev/) > Create New Project
2. Choose CI/CD > GitHub Actions > Select repo > Add CI jobs
3. Semgrep pushes `semgrep.yml` to repo
4. Token added automatically to GitHub secrets
5. Slack sends security results to your chosen channel



---

## 🎨 Deployment Result

- Ghost CMS running at public IP or domain
- Slack notification sent for scan results
- Fully automated setup & teardown



---

## 📈 Deployment Diagram



---

## 📊 Summary

| Feature                  | Status  |
| ------------------------ | ------- |
| IaC w/ Terraform         | ✅       |
| CI/CD via GitHub Actions | ✅       |
| Dockerized Ghost CMS     | ✅       |
| HTTPS + No-IP domain     | ✅ Bonus |
| SAST w/ Semgrep          | ✅       |
| Slack integration        | ✅       |

