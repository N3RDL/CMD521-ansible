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
└── README.md
```

## Inventory

| Host | IP | OS | User |
|------|----|----|------|
| amazon-linux | 51.21.254.58 | Amazon Linux | ec2-user |
| ubuntu | 13.51.157.77 | Ubuntu 26.06 | ubuntu |

## Quick Start

### Test connection
```bash
ansible aws_hosts -i inventory/production/hosts -m ping
```

### Run ad-hoc command
```bash
ansible aws_hosts -i inventory/production/hosts -m shell -a "uptime"
```

### Run playbook
```bash
ansible-playbook playbooks/site.yml -i inventory/production/hosts
```

## SSH Key

Private key location: `/home/master/ansible/keys/Stockholm_3.pem`

## Agent Skills

- **ansible** - Playbook development, roles, collections
- **git** - Version control operations

## License

MIT
