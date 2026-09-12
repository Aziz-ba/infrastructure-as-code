# ⚙️ Infrastructure as Code - Terraform + Ansible on AWS

Provision a **two-tier web stack on AWS** with **Terraform**, then configure it with **Ansible** - fully reproducible, no console clicks. The config is parameterized, validated in **CI**, and driven by a simple `Makefile`.

![terraform](https://img.shields.io/badge/Terraform-844FBA?style=flat-square&logo=terraform&logoColor=white)
![ansible](https://img.shields.io/badge/Ansible-EE0000?style=flat-square&logo=ansible&logoColor=white)
![CI](https://img.shields.io/badge/CI-fmt%20%2B%20validate-2088FF?style=flat-square&logo=githubactions&logoColor=white)

---

## 🗺️ Architecture

```
        ┌─────────────────────── AWS ───────────────────────┐
        │        security group: HTTP :80 (world)            │
   SSH  │        SSH :22 (allowed_ssh_cidr only)             │
  :22 ──┼──▶ ┌───────────────┐        ┌───────────────┐      │
  HTTP  │    │ EC2: <p>-nginx│        │ EC2:<p>-php_fpm│      │
  :80 ──┼──▶ │  web tier     │        │  app tier      │      │
        │    └───────────────┘        └───────────────┘      │
        │        both from one for_each definition           │
        └────────────────────────────────────────────────────┘
   Terraform provisions ─▶ outputs public IPs ─▶ Ansible installs NGINX / PHP-FPM
```

---

## 📁 Structure

| File | Purpose |
|------|---------|
| `versions.tf` | Terraform & provider version pins |
| `variables.tf` | Region, AMI, instance type, key path, **`allowed_ssh_cidr`** |
| `main.tf` | Key pair, security group, and both EC2 tiers via **`for_each`** |
| `outputs.tf` | Public IPs + a ready-to-paste **Ansible inventory** |
| `setup.yml` | Ansible: install & enable NGINX / PHP-FPM |
| `.github/workflows/terraform.yml` | CI: `fmt -check` + `validate` on every push |
| `Makefile` | `make fmt / validate / plan / apply / configure / destroy` |

---

## 🚀 Usage

```bash
make validate                       # fmt + init + validate (also runs in CI)
terraform apply                     # provision (prompts for confirmation)
terraform output ansible_inventory_hint > inventory.ini   # grab the IPs
make configure                      # ansible-playbook -i inventory.ini setup.yml
```

Prereqs: an AWS account (`aws configure`), Terraform ≥ 1.3, Ansible, and an SSH key at `~/.ssh/id_rsa.pub`.

---

## 🔒 Security

- **No credentials or state** are committed - `credentials`, `*.tfstate`, `inventory.ini` are git-ignored.
- **`allowed_ssh_cidr`** defaults to `0.0.0.0/0` for demo convenience - **set it to your IP** for real use.
- All resources are **tagged** (`Project`, `ManagedBy`, `Role`) for cost tracking and cleanup.

---

## 📄 License

Released under the [MIT License](LICENSE).
