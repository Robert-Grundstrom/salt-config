{% from slspath + '/map.jinja' import snmp with context %}
{%-set user = salt['pillar.get']('server:settings:set_snmp_settings:set_snmp_user')%}
{%-set sha = salt['pillar.get']('server:settings:set_snmp_settings:set_sha_passwd')%}
{%-set aes = salt['pillar.get']('server:settings:set_snmp_settings:set_aes_passwd')%}

install_snmp_packets:
  pkg.latest:
    - pkgs:
      - {{snmp.packet}}

  service.dead:
    - name: snmpd
    - onchanges:
      - pkg: install_snmp_packets

apply_snmp_config:
  file.managed:
    - names:
      - '{{snmp.path}}/snmpd.conf':
        - contents: 'createUser {{user}} SHA {{sha}} AES {{aes}}'
        - onchanges:
          - pkg: install_snmp_packets
      - '/etc/snmp/snmpd.conf':
        - source: salt://{{slspath}}/files/snmpd.conf
        - set_ipaddr: {{salt['network.ip_addrs']()|first}}
    - template: jinja
    - mode: 644
    - user: root
    - group: root

service_snmp_running:
  service.running:
  - name: snmpd
  - watch:
    - pkg: install_snmp_packets
    - file: apply_snmp_config
  - enable: True
