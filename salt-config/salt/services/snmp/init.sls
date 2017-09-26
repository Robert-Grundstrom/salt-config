{% from slspath + '/map.jinja' import snmp with context %}
{%-set usr = salt['pillar.get']('server:settings:set_snmp:snmp_usr')%}
{%-set sha = salt['pillar.get']('server:settings:set_snmp:snmp_sha')%}
{%-set aes = salt['pillar.get']('server:settings:set_snmp:snmp_aes')%}
{%-set snmp_ip = salt['pillar.get']('server:settings:set_snmp:snmp_ip', '0.0.0.0')%}

snmp_pkgs:
  pkg.latest:
    - pkgs:
      - {{snmp.packet}}

  service.dead:
    - name: snmpd
    - onchanges:
      - pkg: snmp_pkgs

snmp_config:
  file.managed:
    - names:
      - '{{snmp.path}}/snmpd.conf':
        - contents: 'createUser {{usr}} SHA {{sha}} AES {{aes}}'
        - onchanges:
          - pkg: snmp_pkgs

      - '/etc/snmp/snmpd.conf':
        - source: salt://{{slspath}}/files/snmpd.conf
        - snmp_ip: {{snmp_ip}}
        - usr: {{usr}}
    - template: jinja
    - mode: 644
    - user: root
    - group: root

snmp_service:
  service.running:
  - name: snmpd
  - watch:
    - pkg: snmp_pkgs
    - file: snmp_config
  - enable: True
