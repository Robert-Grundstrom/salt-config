{%-set user = salt['pillar.get']('server:settings:set_snmp_settings:set_snmp_user')%}
{%-set sha = salt['pillar.get']('server:settings:set_snmp_settings:set_sha_passwd')%}
{%-set aes = salt['pillar.get']('server:settings:set_snmp_settings:set_aes_passwd')%}

install_snmp_packets:
  pkg.latest:
    - pkgs:
      - snmpd

  service.dead:
    - name: snmpd
    - onchanges:
      - pkg: install_snmp_packets

apply_snmp_config:
  file.managed:
    - names:
      - '/var/lib/snmp/snmpd.conf':
        - contents: 'createUser {{user}} SHA {{sha}} AES {{aes}}'
        - watch.pkg: install_snmp_packets
      - '/etc/snmp/snmpd.conf':
        - source: salt://{{slspath}}/files/snmpd.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - onchanges:
      - pkg: install_snmp_packets

service_snmp_running:
  service.running:
  - name: snmpd
  - watch:
    - pkg: install_snmp_packets
    - file: apply_snmp_config
