{% from slspath + '/map.jinja' import snmp with context %}
# Install snmp deamon packet.
{{snmp.packet}}:
  pkg.latest

# If the packet is installed or upgraded, we need to stop
# the service and apply the user configuration.
snmp_dead:
  service.dead:
    - name: snmpd
    - onchanges:
      - pkg: {{snmp.packet}}

# Apply the configuration that is requiered.
snmp_config:
  file.managed:
    - names:
      - '{{snmp.path}}/snmpd.conf':
        - contents: 'createUser {{snmp.user}} SHA {{snmp.sha}} AES {{snmp.aes}}'
        - onchanges:
          - pkg: {{snmp.packet}}

      - '/etc/snmp/snmpd.conf':
        - source: salt://{{slspath}}/files/snmpd.conf
        - snmp_ip: {{snmp.bind}}
        - usr: {{snmp.user}}
    - template: jinja
    - mode: 644
    - user: root
    - group: root

# Set the firewall rules requiered to make SNMP work.
# If monitor servers are specified we will add them
# as sources to up the security.
# 
# If no monitor servers are specified we will set it
# to all (0.0.0.0/0)

set_SNMP_fwrule_{{snmp.monitor_ip}}:
  iptables.append:
  - dport: '161'
  - proto: 'udp'
  - d: {{snmp.bind}}/32
  {%for monitor in snmp.monitor_ip%}
  - source: {{monitor}}/32
  {%endfor%}
  - chain: 'SOFTWARE'
  - save: True

# Make sure SNMP service are running.
snmp_service:
  service.running:
  - name: snmpd
  - watch:
    - pkg: {{snmp.packet}}
    - file: snmp_config
  - enable: True
