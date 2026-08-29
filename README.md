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
│           └── aws_hosts.yml # Group variables
├── playbooks/
│   └── install-packages.yml  # Install common packages
└── README.md
```

## Inventory

| Host | IP | OS | User |
|------|----|----|------|
| amazon-linux | 51.21.254.58 | Amazon Linux | ec2-user |
| ubuntu | 13.51.157.77 | Ubuntu 26.06 | ubuntu |

## Playbooks

| Playbook | Description |
|----------|-------------|
| `install-packages.yml` | Install common packages (mc, net-tools, curl, wget, git, vim, htop, unzip, tree, nano) |

### Run playbook
```bash
# Default (all aws_hosts):
ansible-playbook playbooks/install-packages.yml -i inventory/production/hosts

# Target specific host:
ansible-playbook playbooks/install-packages.yml -i inventory/production/hosts -e "hosts=ubuntu"
ansible-playbook playbooks/install-packages.yml -i inventory/production/hosts -e "hosts=amazon-linux"
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

## Agent Skills

- **ansible** - Playbook development, roles, collections
- **git** - Version control operations

## License

MIT
