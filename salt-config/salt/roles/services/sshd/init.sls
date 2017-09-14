install_base:
  pkg.latest:
    - pkgs:
      - openssh-server

apply_configuration:
  file.managed:
    - name: '/etc/ssh/sshd_config'
    - source: salt://{{slspath}}/files/sshd_config
    - mode: 644
    - user: root
    - group: root
    - template: jinja

services_running:
  service.running:
    - names: 
      - 'sshd'
    - watch:
      - pkg: install_base
      - file: apply_configuration
    - enable: True

