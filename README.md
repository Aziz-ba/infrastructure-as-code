# ⚙️ Infrastructure as Code — Terraform + Ansible on AWS

Provision a **two-tier web stack on AWS** with **Terraform**, then configure it with **Ansible** — fully reproducible, zero manual clicks in the console.

- **Terraform** builds the infrastructure: two EC2 instances (an NGINX web tier and a PHP-FPM app tier), a security group, and an SSH key pair.
- **Ansible** configures the servers: installs and starts NGINX on one host and PHP-FPM on the other.

---

## 🗺️ What gets created

```
        ┌─────────────────── AWS ───────────────────┐
        │                                            │
   SSH  │   ┌───────────────┐    ┌───────────────┐   │
  :22 ──┼──▶│  EC2: nginx   │    │  EC2: php_fpm │   │
  HTTP  │   │  (web tier)   │    │  (app tier)   │   │
  :80 ──┼──▶│               │    │               │   │
        │   └───────────────┘    └───────────────┘   │
        │        security group: web_sg (22, 80)     │
        └────────────────────────────────────────────┘
```

| Tool | File | Responsibility |
|------|------|----------------|
| Terraform | [`main.tf`](main.tf) | key pair, security group (22/80), two `t2.micro` EC2 instances |
| Ansible | [`setup.yml`](setup.yml) | install + enable NGINX and PHP-FPM |
| Inventory | [`inventory.ini.example`](inventory.ini.example) | maps hosts to the provisioned public IPs |

---

## 🚀 Usage

```bash
# 1. Provision the infrastructure
terraform init
terraform plan
terraform apply

# 2. Copy the example inventory and fill in the EC2 public IPs Terraform output
cp inventory.ini.example inventory.ini

# 3. Configure the servers
ansible-playbook -i inventory.ini setup.yml
```

> Prerequisites: an AWS account with credentials configured (`aws configure` / environment variables), Terraform, Ansible, and an SSH key at `~/.ssh/id_rsa.pub`.

---

## 🔒 Security note

This repository **never** contains credentials or state. The following are git-ignored and must stay local:

- `credentials` — your AWS keys
- `*.tfstate` — Terraform state (can contain sensitive resource data)
- `inventory.ini` — your real host IPs

Configure AWS auth via `aws configure`, environment variables, or a profile instead of committing keys.

---

## 🛠️ Tech Stack

![Terraform](https://img.shields.io/badge/Terraform-844FBA?style=flat-square&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=flat-square&logo=ansible&logoColor=white)
![AWS](https://img.shields.io/badge/AWS_EC2-FF9900?style=flat-square&logo=amazonaws&logoColor=white)

---

## 📄 License

Released under the [MIT License](LICENSE).
