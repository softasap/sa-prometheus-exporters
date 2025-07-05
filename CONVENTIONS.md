When we are developing ansible roles we should follow the conventions below.

## General
Do not change role logic, and remove any existing code without confirmation or PR review,
other code might depend on role logic, instead, confirm.

In yaml files, use 2 spaces for indentation.

## Roles
### Role name
Role name should be in the format of `sa_<service_name>`

## Tasks

We should use fully qualified names for modules, as per ansible documentation.
Some validated names include:
ansible.builtin.apt_key
ansible.builtin.apt_repository
When calling a module, always specify name in a format  GOAL | What step does.

Example:
```
- name: GIT | Install modern git ppa repo
```

usually goal is the word after tasks_, in tasks file name, like GIT for tasks_git.yml

### Arguments

When calling a module, do not pass arguments in the same line inline,
prefer yaml style with sub-nodes.
