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
│   ├── install-packages.yml  # Install common packages (uses role)
│   └── roles/
│       └── common/
│           ├── defaults/main.yml # Default variables
│           └── tasks/main.yml    # Role tasks
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
| `install-packages.yml` | Install common packages (mc, net-tools, curl, wget, git, vim, htop, unzip, tree, nano) |

### Run playbook
```bash
# Default (all aws_hosts):
ansible-playbook playbooks/install-packages.yml -i inventory/production/hosts

# Target specific host:
ansible-playbook playbooks/install-packages.yml -i inventory/production/hosts -e "target_hosts=ubuntu"
ansible-playbook playbooks/install-packages.yml -i inventory/production/hosts -e "target_hosts=amazon-linux"
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
