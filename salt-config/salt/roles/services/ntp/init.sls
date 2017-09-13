ntp_install:
  pkg.latest:
    - pkgs:
      - ntp

apply_ntp_configuration:
  file.managed:
    - names:
      - '/etc/ntp.conf':
        - source: salt://{{slspath}}/files/ntp.conf
    - mode: 644
    - follow_symlinks: False
    - template: jinja
    - user: root
    - group: root

service_ntp_running:
  service.running:
    - name: 'ntp'
    - enable: True
    - watch:
      - file: apply_ntp_configuration 
      - pkg: ntp_install
