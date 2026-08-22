---
name: ansible
description: Develop, update, and maintain Ansible playbooks, roles, and collections. Use when creating infrastructure automation, configuration management, deployment scripts, or any Ansible YAML files.
license: MIT
compatibility: Requires Ansible 2.12+ and Python 3.8+
metadata:
  author: opencode
  version: "1.0"
allowed-tools: Bash(ansible:*) Bash(ansible-playbook:*) Bash(ansible-lint:*) Read Write Edit Glob Grep
---

# Ansible Skill

Develop, update, and maintain Ansible playbooks, roles, and collections.

## Core Principles

1. **Idempotency**: Playbooks must be safely re-runnable without side effects
2. **幂等性**: Use `state: present/absent` consistently, avoid destructive operations without confirmation
3. **Modularity**: Break complex playbooks into roles and reusable tasks
4. **Security**: Never hardcode secrets; use `ansible-vault`, environment variables, or lookup plugins

## File Structure

```
project/
├── ansible.cfg              # Ansible configuration
├── inventory/
│   ├── production/
│   │   ├── hosts            # Production inventory
│   │   └── group_vars/
│   │       └── all.yml      # Production variables
│   └── staging/
│       ├── hosts            # Staging inventory
│       └── group_vars/
│           └── all.yml      # Staging variables
├── playbooks/
│   ├── site.yml             # Main playbook
│   ├── webservers.yml       # Web server tasks
│   └── dbservers.yml        # Database tasks
├── roles/
│   ├── common/
│   │   ├── tasks/main.yml
│   │   ├── handlers/main.yml
│   │   ├── templates/
│   │   ├── files/
│   │   ├── vars/main.yml
│   │   ├── defaults/main.yml
│   │   └── meta/main.yml
│   └── webserver/
│       ├── tasks/main.yml
│       └── handlers/main.yml
├── group_vars/
│   └── all.yml              # Global variables
├── host_vars/
│   └── hostname.yml         # Host-specific variables
└── requirements.yml         # Collection/role dependencies
```

## Playbook Writing Rules

### Task Structure
```yaml
- name: Descriptive task name
  module_name:
    parameter1: value1
    parameter2: value2
  notify: handler_name
  tags:
    - tag1
    - tag2
```

### Naming Conventions
- **Play names**: Descriptive, start with action (e.g., "Install and configure nginx")
- **Task names**: Explain what the task does (e.g., "Install nginx package")
- **Role names**: Lowercase, underscores (e.g., `webserver`, `common`)
- **Variable names**: snake_case (e.g., `nginx_port`, `db_host`)

### Variable Precedence (highest to lowest)
1. Extra vars (`-e`)
2. Role vars
3. Inventory vars
4. Play vars
5. Role defaults
6. Inventory group_vars
7. Inventory host_vars
8. Playbook group_vars
9. Playbook host_vars

### Best Practices

- Use `ansible-lint` to validate playbooks before deployment
- Prefer `ansible.builtin` FQCN (fully qualified collection names)
- Use `block/rescue/always` for error handling
- Implement `check_mode` support where possible
- Use `changed_when` and `failed_when` for better reporting
- Include `--diff` output in tasks that modify files

### Example Playbook

```yaml
---
- name: Configure web servers
  hosts: webservers
  become: yes
  vars:
    http_port: 80
    max_clients: 200

  tasks:
    - name: Install nginx
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: yes
      notify: Start nginx

    - name: Deploy nginx configuration
      ansible.builtin.template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
        owner: root
        group: root
        mode: '0644'
        validate: 'nginx -t -c %s'
      notify: Reload nginx

  handlers:
    - name: Start nginx
      ansible.builtin.service:
        name: nginx
        state: started

    - name: Reload nginx
      ansible.builtin.service:
        name: nginx
        state: reloaded
```

### Example Role Structure

```yaml
# roles/webserver/tasks/main.yml
---
- name: Install web server packages
  ansible.builtin.package:
    name: "{{ webserver_packages }}"
    state: present
  loop: "{{ webserver_packages }}"

- name: Ensure web server is running
  ansible.builtin.service:
    name: "{{ webserver_service }}"
    state: started
    enabled: yes
```

## Validation Commands

```bash
# Syntax check
ansible-playbook playbook.yml --syntax-check

# Dry run
ansible-playbook playbook.yml --check --diff

# Lint
ansible-lint playbook.yml

# Run specific tags
ansible-playbook playbook.yml --tags "setup,config"
```

## Vault Usage

```bash
# Encrypt a file
ansible-vault encrypt secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Run with vault password
ansible-playbook playbook.yml --ask-vault-pass

# Use vault password file
ansible-playbook playbook.yml --vault-password-file ~/.vault_pass
```

## Troubleshooting

1. **Connection issues**: Verify inventory, SSH keys, and `ansible_user`
2. **Permission denied**: Ensure `become: yes` and sudo configuration
3. **Variable undefined**: Check variable precedence and spelling
4. **Module errors**: Use `-vvv` for verbose output

For role templates and advanced patterns, see [references/](references/).
