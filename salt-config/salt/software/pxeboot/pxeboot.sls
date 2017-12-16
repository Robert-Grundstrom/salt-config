{% if salt['pillar.get']('software:pxeboot') %}

# Install requiered packets.
pxe_pkgs:
  pkg.latest:
    - pkgs:
      - tftpd-hpa
      - inetutils-inetd

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
      - '/etc/inetd.conf':
        - source: 'salt://{{slspath}}/files/inetd.conf'
    - user: root
    - group: root
    - mode: 644

pxe_tftpd_conf:
  file.recurse:
    - name: '/opt/tftpboot'
    - source: 'salt://{{slspath}}/files/tftpboot'

pxe_services:
  service.running:
  - names:
    - 'tftpd-hpa'
    - 'inetutils-inetd'
  - enable: True
  - watch:
    - file: pxe_tftpd_conf
    - file: pxe_config
    - pkg: pxe_pkgs

{% endif %}
