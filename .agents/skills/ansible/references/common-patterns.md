# Common Ansible Patterns

## Error Handling

```yaml
- name: Task with error handling
  block:
    - name: Risky operation
      ansible.builtin.command: risky-command
  rescue:
    - name: Handle failure
      ansible.builtin.debug:
        msg: "Operation failed, executing fallback"
  always:
    - name: Cleanup
      ansible.builtin.file:
        path: /tmp/tempfile
        state: absent
```

## Conditional Execution

```yaml
- name: Run only on specific OS
  ansible.builtin.apt:
    name: nginx
    state: present
  when: ansible_os_family == "Debian"

- name: Skip if file exists
  ansible.builtin.copy:
    content: "new content"
    dest: /etc/config
  when: not config_file.stat.exists
```

## Loops

```yaml
- name: Install multiple packages
  ansible.builtin.package:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - git
    - curl

- name: Create users
  ansible.builtin.user:
    name: "{{ item.name }}"
    groups: "{{ item.groups }}"
    state: present
  loop:
    - { name: "alice", groups: "admin" }
    - { name: "bob", groups: "developer" }
```

## Jinja2 Templates

```jinja2
{# templates/nginx.conf.j2 #}
server {
    listen {{ http_port }};
    server_name {{ server_name }};

    location / {
        proxy_pass http://{{ backend_host }}:{{ backend_port }};
    }
}
```

## Secrets Management

```yaml
# Using ansible-vault encrypted vars
# First encrypt: ansible-vault encrypt_string 'secret_value' --name 'db_password'

- name: Configure database
  ansible.builtin.template:
    src: db.conf.j2
    dest: /etc/app/db.conf
  vars:
    db_password: "{{ vault_db_password }}"
```

## Performance Optimization

```yaml
# Use pipelining in ansible.cfg for faster SSH
# [ssh_connection]
# pipelining = True

# Use async for long-running tasks
- name: Long running task
  ansible.builtin.command: /opt/long-task.sh
  async: 3600
  poll: 0
  register: long_task

- name: Wait for completion
  ansible.builtin.async_status:
    jid: "{{ long_task.ansible_job_id }}"
  register: job_result
  until: job_result.finished
  retries: 60
  delay: 60
```
