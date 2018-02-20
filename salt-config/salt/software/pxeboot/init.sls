# Install requiered packets.
pxe_pkgs:
  pkg.latest:
    - pkgs:
      - tftpd-hpa

# Create folders
pxe_dir:
  file.directory:
    - names:
      - '/opt/tftpboot'
    - user: root
    - group: nogroup
    - mode: 755

pxe_config:
  file.managed:
    - names:
      - '/etc/default/tftpd-hpa':
        - source: 'salt://{{slspath}}/files/tftpboot-hpa'
    - user: root
    - group: root
    - mode: 644

pxe_tftpd_conf:
  file.recurse:
    - name: '/opt/tftpboot'
    - source: 'salt://{{slspath}}/files/tftpboot'
    - dir_mode: 755
    - file_mode: 755

pxe_services:
  service.running:
  - names:
    - 'tftpd-hpa'
  - enable: True
  - watch:
    - file: pxe_tftpd_conf
    - file: pxe_config
    - pkg: pxe_pkgs
