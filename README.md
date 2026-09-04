# CMD521 Ansible

Ansible playbooks and infrastructure automation for AWS hosts.

## Project Structure

```
.
├── .agents/skills/           # Agent skills for Ansible and Git
├── inventory/
│   └── production/
│       ├── hosts             # Inventory file (INI)
│       └── group_vars/
│           ├── aws_hosts.yml
│           └── windows_hosts.yml
├── playbooks/
│   ├── install-apache.yml             # Install Apache web server (uses role)
│   ├── install-packages.yml           # Install Linux packages (uses role)
│   ├── install-windows-packages.yml   # Install Windows packages (uses role)
│   └── roles/
│       ├── apache/                    # Apache role (Ubuntu + Amazon Linux)
│       │   ├── defaults/main.yml
│       │   ├── handlers/main.yml
│       │   ├── tasks/main.yml
│       │   ├── templates/index.html.j2
│       │   └── vars/                  # Debian.yml, RedHat.yml
│       ├── common/                    # Linux role
│       │   ├── defaults/main.yml
│       │   └── tasks/main.yml
│       └── windows-common/            # Windows role
│           ├── defaults/main.yml
│           └── tasks/main.yml
├── scripts/
│   └── setup-winrm.ps1       # Windows WinRM setup
└── README.md
```

## Inventory

| Host | IP | OS | User |
|------|----|----|------|
| amazon-linux | 13.60.184.149 | Amazon Linux | ec2-user |
| ubuntu | 16.171.193.140 | Ubuntu | ubuntu |
| windows | 10.10.33.122 | Windows | master |

## Playbooks

| Playbook | Description |
|----------|-------------|
| `install-apache.yml` | Install Apache, start it and enable autostart (Ubuntu + Amazon Linux) |
| `install-packages.yml` | Install common Linux packages (mc, net-tools, curl, wget, git, vim, htop, unzip, tree, nano) |
| `install-windows-packages.yml` | Install common Windows packages (Chrome, WinRAR, Wireshark, Notepad++, Git) |

### Run Apache playbook
```bash
# Default (all aws_hosts):
ansible-playbook playbooks/install-apache.yml -i inventory/production/hosts

# Target specific host:
ansible-playbook playbooks/install-apache.yml -i inventory/production/hosts -e "target_hosts=ubuntu"
ansible-playbook playbooks/install-apache.yml -i inventory/production/hosts -e "target_hosts=amazon-linux"
```

### Run Linux playbook
```bash
# Default (all aws_hosts):
ansible-playbook playbooks/install-packages.yml -i inventory/production/hosts

# Target specific host:
ansible-playbook playbooks/install-packages.yml -i inventory/production/hosts -e "target_hosts=ubuntu"
ansible-playbook playbooks/install-packages.yml -i inventory/production/hosts -e "target_hosts=amazon-linux"
```

### Run Windows playbook
```bash
# Default (all windows_hosts):
ansible-playbook playbooks/install-windows-packages.yml -i inventory/production/hosts --ask-vault-pass

# Target specific host:
ansible-playbook playbooks/install-windows-packages.yml -i inventory/production/hosts -e "target_hosts=windows" --ask-vault-pass
```

## Quick Start

### Test connection
```bash
ansible aws_hosts -i inventory/production/hosts -m ping
```

### Run ad-hoc command
```bash
ansible aws_hosts -i inventory/production/hosts -m shell -a "uptime"
```

## SSH Key

Private key location: `/home/master/ansible/keys/Stockholm_3.pem`

## Windows WinRM Setup

On Windows machine (PowerShell as Administrator):

```powershell
.\scripts\setup-winrm.ps1
```

Test connection:

```bash
ansible windows_hosts -i inventory/production/hosts -m win_ping --ask-vault-pass
```

## Agent Skills

- **ansible** - Playbook development, roles, collections
- **git** - Version control operations

## License

MIT

## Apache playbook verification

`install-apache.yml` was executed against two real EC2 instances in `eu-north-1`
(Ubuntu 24.04 and Amazon Linux 2023) created with Terraform.

| Step | Result |
|------|--------|
| First run (clean hosts) | `ubuntu: changed=3`, `amazon-linux: changed=4`, `failed=0` — `docs/run-install.txt` |
| Second run | `changed=0` on both hosts, the playbook is idempotent — `docs/run-idempotent.txt` |
| Service state | `apache2` and `httpd`: `enabled` + `active` |
| HTTP | `HTTP 200` from the host itself and from the other instance over the public IP |
| Autostart | after `reboot` both services come up on their own, `http=200` — `docs/after-reboot.txt` |

The role installs `apache2` on Debian-family hosts and `httpd` on RedHat-family hosts;
the names come from `roles/apache/vars/Debian.yml` and `roles/apache/vars/RedHat.yml`,
selected by the `ansible_os_family` fact. Any other OS family stops the play with a
clear message instead of failing halfway through.
