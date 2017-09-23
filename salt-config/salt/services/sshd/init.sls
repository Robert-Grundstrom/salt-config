sshd_install_base:
  pkg.latest:
    - pkgs:
      - openssh-server

sshd_apply_configuration:
  file.managed:
    - name: '/etc/ssh/sshd_config'
    - source: salt://{{slspath}}/files/sshd_config
    - mode: 644
    - user: root
    - group: root
    - template: jinja

sshd_services_running:
  service.running:
    - names: 
      - 'sshd'
    - watch:
      - pkg: sshd_install_base
      - file: sshd_apply_configuration
    - enable: True

