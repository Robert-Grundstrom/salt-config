# Salt Debian configuration file.
---
# Setup and configure SNMP3 for OP5 monitor.
{%-if not salt['file.file_exists']('/var/lib/snmp/snmpd.conf')%}
common_snmp_user:
  pkg.installed:
  - pkg: snmpd

  service.dead:
  - name: snmpd

{%-set user = salt['pillar.get']('set_snmp_settings:set_snmp_user')%}
{%-set sha = salt['pillar.get']('set_snmp_settings:set_sha_passwd')%}
{%-set aes = salt['pillar.get']('set_snmp_settings:set_aes_passwd')%}
  file.managed:
    - name: '/var/lib/snmp/snmpd.conf'
    - contents: 'createUser {{user}} SHA {{sha}} AES {{aes}}'
    - template: jinja
    - mode: 644
    - user: root
    - group: root
{% endif %}

# Install packets.
{%-for packet in salt['pillar.get']('set_default_packets',)%}
{{packet}}:
  pkg.installed
{%-endfor %}

# Apply configuration files.
debian_apply_configuration:
  file.managed:
    - names:
      - '/etc/resolv.conf':
        - source: salt://templates/resolv.conf
      - '/etc/ntp.conf':
        - source: salt://templates/ntp.conf
      - '/sbin/call_home':
        - contents: 'salt-call --state_output=mixed state.apply'
        - mode: 755
      - '/etc/snmp/snmpd.conf':
        - source: salt://templates/snmpd.conf
    - mode: 644
    - follow_symlinks: False
    - template: jinja
    - user: root
    - group: root

# Ensure services are running.
debian_service_running:
  service.running:
    - names:
      - 'ntp':
        - watch.file: '/etc/ntp.conf'
      - 'snmpd':
        - watch.file: '/etc/snmp/snmpd.conf'
    - enable: True

# End of configuration file.
