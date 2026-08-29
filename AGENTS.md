# AGENTS.md — System Prompt for CMD521 Ansible

## Project Context

- Ansible automation project for 2 AWS EC2 hosts (Amazon Linux, Ubuntu)
- Host group: `aws_hosts`
- SSH key: `/home/master/ansible/keys/Stockholm_3.pem`
- Inventory: `inventory/production/hosts` (INI format)
- Python interpreter: `/usr/bin/python3`
- Privilege escalation: `become=yes`, `sudo`

## Inventory

| Host | IP | User | OS |
|------|----|----|-----|
| amazon-linux | 13.60.184.149 | ec2-user | Amazon Linux |
| ubuntu | 16.171.193.140 | ubuntu | Ubuntu |
| windows | 10.10.33.122 | master | Windows |

## Ansible Rules

### Parameterization (STRICT)

- NEVER hardcode `hosts:` value — always use variables with defaults:
  ```yaml
  hosts: "{{ target_hosts | default('aws_hosts') }}"
  ```
- Apply the same pattern for other key play-level fields (`become`, etc.)
- Users pass parameters via `-e`:
  ```bash
  ansible-playbook playbooks/install-packages.yml -i inventory/production/hosts -e "target_hosts=ubuntu"
  ```

### Playbook Standards

- Use FQCN: `ansible.builtin.*`, `ansible.posix.*`
- `snake_case` for all variable names
- Descriptive play/task names starting with an action verb
- Idempotent tasks: always use `state: present/absent`
- No hardcoded secrets — use `ansible-vault`, environment variables, or lookup plugins
- Use `block/rescue/always` for error handling
- Use `changed_when` and `failed_when` for better reporting
- Prefer `ansible.builtin.package` over distro-specific modules when possible

### Task Structure

- **Play names**: action-oriented (e.g., "Install and configure nginx")
- **Task names**: explain what the task does (e.g., "Install nginx package")
- **Role names**: lowercase with underscores (e.g., `webserver`, `common`)
- **Variable names**: snake_case (e.g., `nginx_port`, `db_host`)

## Git Conventions

- Follow **Conventional Commits**: `<type>: <description>`
- Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `style`
- Examples:
  ```
  feat: parameterize hosts in install-packages playbook
  fix: resolve connection timeout issue
  docs: update README with playbook usage
  ```
- Branch: `main` (primary)
- Always run lint before committing
- NEVER auto-push — always ask user for permission before `git push`

## File Structure

```
.
├── AGENTS.md                  # This file
├── README.md                  # Project documentation
├── inventory/
│   └── production/
│       ├── hosts              # Inventory file (INI)
│       └── group_vars/
│           ├── aws_hosts.yml  # Group variables
│           └── windows_hosts_vault.yml   # Encrypted password
├── playbooks/
│   ├── install-packages.yml   # Install common packages (uses role)
│   └── roles/
│       └── common/
│           ├── defaults/
│           │   └── main.yml   # Default variables (common_packages)
│           └── tasks/
│               └── main.yml   # Role tasks
└── .agents/
    └── skills/
        ├── ansible/           # Ansible skill + references
        └── git/               # Git skill
```

## Validation Commands

```bash
# Syntax check
ansible-playbook playbooks/<file>.yml --syntax-check

# Dry run
ansible-playbook playbooks/<file>.yml --check --diff

# Lint
ansible-lint playbooks/<file>.yml

# Run with custom host target
ansible-playbook playbooks/<file>.yml -i inventory/production/hosts -e "target_hosts=<target>"
```

## Troubleshooting

1. **Connection issues**: Verify inventory, SSH keys, and `ansible_user`
2. **Permission denied**: Ensure `become: yes` and sudo configuration
3. **Variable undefined**: Check variable precedence and spelling
4. **Module errors**: Use `-vvv` for verbose output
