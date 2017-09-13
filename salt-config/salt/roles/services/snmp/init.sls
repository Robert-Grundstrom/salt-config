{%-set user = salt['pillar.get']('server:settings:set_snmp_settings:set_snmp_user')%}
{%-set sha = salt['pillar.get']('server:settings:set_snmp_settings:set_sha_passwd')%}
{%-set aes = salt['pillar.get']('server:settings:set_snmp_settings:set_aes_passwd')%}


{%-if salt['grains.get']('os') == "Ubuntu" or "Debian"%}
  {%-set path = "/var/lib/snmp"%}
  {%-set pkg_name = "snmpd"%}
{%endif%}
{%-if salt['grains.get']('os') == "CentOS"%}
  {%-set path = "/var/lib/net-snmp"%}
  {%-set pkg_name = "net-snmp"%}
{%endif%}

install_snmp_packets:
  pkg.latest:
    - pkgs:
      - {{pkg_name}}

  service.dead:
    - name: snmpd
    - onchanges:
      - pkg: install_snmp_packets

apply_snmp_config:
  file.managed:
    - names:
      - '{{path}}/snmpd.conf':
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
