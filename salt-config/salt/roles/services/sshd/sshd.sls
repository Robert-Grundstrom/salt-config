install_base:
  pkg.latest:
    - pkgs:
      - openssh-server

apply_configuration:
  file.replace:
    - name: '/etc/ssh/sshd_config'
    - pattern: '#PermitRootLogin.*'
    - repl: 'PermitRootLogin no'

services_running:
  service.running:
    - names: 
      - 'sshd'
    - watch:
      - pkg: install_base
      - file: apply_configuration
    - enable: True

