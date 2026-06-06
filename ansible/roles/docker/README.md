Docker
======

This role installs Docker from the official Docker APT repository and deploys
the Cloud-1 Docker Compose stack.

What It Does
------------

- installs useful APT prerequisites such as `ca-certificates` and `curl`
- creates the Docker APT keyring directory
- downloads the Docker GPG key
- adds the official Docker APT repository
- installs Docker packages:
  - `docker-ce`
  - `docker-ce-cli`
  - `containerd.io`
  - `docker-buildx-plugin`
  - `docker-compose-plugin`
- enables and starts the Docker service
- optionally adds users to the `docker` group
- creates the Cloud-1 project and data directories
- generates `/cloud-1/.env`
- copies the Docker Compose file to `/cloud-1/docker-compose.yml`
- starts the stack with `docker compose up -d`

Requirements
------------

This role targets Debian/Ubuntu hosts with `apt`.

The playbook using this role should run with privilege escalation:

```yaml
become: true
```

Role Variables
--------------

Docker packages installed from the official Docker repository:

```yaml
docker_packages:
  - docker-ce
  - docker-ce-cli
  - containerd.io
  - docker-buildx-plugin
  - docker-compose-plugin
```

Useful packages installed before configuring the Docker repository:

```yaml
docker_usefull_packages:
  - ca-certificates
  - curl
```

Project and stack settings:

```yaml
docker_service_name: docker
docker_project_path: /cloud-1
docker_compose_file: docker-compose.yml
docker_env_file: .env
docker_stack_state: present
```

Docker APT repository settings:

```yaml
docker_apt_source_file: /etc/apt/sources.list.d/docker.sources
docker_apt_uri: https://download.docker.com/linux/ubuntu
docker_apt_components: stable
docker_keyring_dir: /etc/apt/keyrings
docker_gpg_url: https://download.docker.com/linux/ubuntu/gpg
docker_gpg_dest: /etc/apt/keyrings/docker.asc
```

Docker users and volume directories:

```yaml
docker_users: []

docker_volume_directories:
  - /cloud-1/data/wp
  - /cloud-1/data/db
```

Environment variables written to `/cloud-1/.env`:

```yaml
docker_nginx_domain_name: "{{ domain_name | default('localhost') }}"
docker_nginx_certif_name: "{{ certif_name | default('cert') }}"

docker_mysql_port: "{{ mysql_port | default(3306) }}"
docker_mysql_user: "{{ mysql_user | default('user') }}"
docker_mysql_host: "{{ mysql_host | default('mysql') }}"
docker_mysql_name: "{{ mysql_name | default('mysql') }}"
docker_mysql_user_password: "{{ mysql_user_password | default('user') }}"
docker_mysql_root_password: "{{ mysql_root_password | default('root') }}"
```

The role can reuse values from `group_vars`, for example:

```yaml
domain_name: jmougel.local
certif_name: cert
mysql_port: 8081
mysql_user: user
mysql_host: mysql
mysql_name: mysql
mysql_user_password: user
mysql_root_password: root
```

Stack State
-----------

By default, the role starts the stack:

```yaml
docker_stack_state: present
```

This runs:

```bash
docker compose -f docker-compose.yml up -d
```

To stop the stack:

```bash
ansible-playbook ansible/playbook.yml -e docker_stack_state=absent
```

This runs:

```bash
docker compose -f docker-compose.yml down
```

Example Playbook
----------------

```yaml
---
- name: Deploy Docker stack
  hosts: web
  become: true
  roles:
    - docker
```

Run
---

From the repository root:

```bash
ANSIBLE_ROLES_PATH=ansible/roles \
ANSIBLE_CONFIG=ansible/ansible.cfg \
ansible-playbook ansible/playbook.yml
```

Syntax check:

```bash
ANSIBLE_LOCAL_TEMP=/tmp/ansible-local \
ANSIBLE_ROLES_PATH=ansible/roles \
ANSIBLE_CONFIG=ansible/ansible.cfg \
ansible-playbook ansible/playbook.yml --syntax-check
```

Files
-----

- `files/docker-compose.yml`: Compose stack for MySQL, WordPress, and Nginx
- `templates/env.j2`: generated `.env` file
- `templates/docker.sources.j2`: Docker APT source definition
- `defaults/main.yml`: role configuration
- `tasks/main.yml`: install and deployment tasks
- `handlers/main.yml`: updates the APT cache when the Docker source changes

License
-------

MIT
