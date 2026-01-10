# Plan: Improve Ansible Setup for Local Dotfiles Management

## Summary
Fix issues and align Ansible setup with industry standards for localhost-only dotfiles management.

## Issues Found

| Priority | Issue | File |
|----------|-------|------|
| HIGH | No `ansible.cfg` | (missing) |
| HIGH | ssh-add fails without ssh-agent | `ssh_add.yml` |
| MEDIUM | Hardcoded versions | `node.yml`, `python.yml` |
| MEDIUM | macOS roles all commented | `macos_playbook.yml` |
| LOW | java.yml has wrong task names | `java.yml` |
| LOW | rust.yml missing idempotency | `rust.yml` |

## Implementation

### 1. Create ansible.cfg
**File:** `ansible/ansible.cfg` (new)

```ini
[defaults]
inventory = localhost,
interpreter_python = auto_silent
localhost_warning = False

[connection]
pipelining = True
```

### 2. Enable all macOS playbook roles
**File:** `ansible/macos_playbook.yml`

```yaml
---
- hosts: localhost
  vars_files: [./inventory/macos_variables.yml]
  roles:
    - brew
    - zsh
    - antidote
    - stow
    - tmux
    - asdf
```

### 3. Add version variables to inventory files
**File:** `ansible/inventory/macos_variables.yml` - add:
```yaml
asdf_versions:
  nodejs: "22.12.0"
  python: "3.13.1"
  java: "openjdk-21"
  rust: "stable"
```

**File:** `ansible/inventory/linux_variables.yml` - add same block

### 4. Update asdf tasks to use variables
**File:** `ansible/roles/asdf/tasks/node.yml`
- Replace `18.12.0` with `{{ asdf_versions.nodejs }}`

**File:** `ansible/roles/asdf/tasks/python.yml`
- Replace `3.11.0` with `{{ asdf_versions.python }}`

**File:** `ansible/roles/asdf/tasks/java.yml`
- Fix task name: "Install and configure Java development tools"
- Fix plugin add name: "Add java plugin to asdf"
- Replace `openjdk-17` with `{{ asdf_versions.java }}`

**File:** `ansible/roles/asdf/tasks/rust.yml`
- Replace `stable` with `{{ asdf_versions.rust }}`
- Add idempotency check (check if rust installed first)

### 5. Fix ssh-add task
**File:** `ansible/roles/zsh/tasks/ssh_add.yml`

```yaml
- name: Add SSH keys
  ansible.builtin.shell: ssh-add {{ item.identityfile }}
  loop: "{{ ssh_origins }}"
  ignore_errors: true
```

## Files Modified
1. `ansible/ansible.cfg` (new)
2. `ansible/macos_playbook.yml`
3. `ansible/inventory/macos_variables.yml`
4. `ansible/inventory/linux_variables.yml`
5. `ansible/roles/zsh/tasks/ssh_add.yml`
6. `ansible/roles/asdf/tasks/node.yml`
7. `ansible/roles/asdf/tasks/python.yml`
8. `ansible/roles/asdf/tasks/java.yml`
9. `ansible/roles/asdf/tasks/rust.yml`

## Verification
```bash
# Syntax check
ansible-playbook ansible/macos_playbook.yml --syntax-check

# Dry run
ansible-playbook ansible/macos_playbook.yml --check
```
