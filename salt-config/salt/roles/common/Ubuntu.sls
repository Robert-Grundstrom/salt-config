# Salt Ubuntu configuration file.
---
# Services that we wont be using.
disabled_services:
  service.dead:
    - names:
        - timesyncd
    - enable: False

# Installs packets.
{%-for packet in salt['pillar.get']('server:settings:set_default_packets',)%}
{{packet}}:
  pkg.installed
{%- endfor %}

# Setup and configure SNMP3 for OP5 monitor.
{%-if not salt['file.file_exists']('/var/lib/snmp/snmpd.conf')%}
common_snmp_user:
  pkg.installed:
  - pkgs:
    - 'snmpd'

  service.dead:
  - name: snmpd

{%-set user = salt['pillar.get']('server:settings:set_snmp_settings:set_snmp_user')%}
{%-set sha = salt['pillar.get']('server:settings:set_snmp_settings:set_sha_passwd')%}
{%-set aes = salt['pillar.get']('server:settings:set_snmp_settings:set_aes_passwd')%}
  file.managed:
    - name: '/var/lib/snmp/snmpd.conf'
    - contents: 'createUser {{user}} SHA {{sha}} AES {{aes}}'
    - template: jinja
    - mode: 644
    - user: root
    - group: root
{%- endif %}

# Apply configuration files.
ubuntu_apply_configuration:
  file.managed:
    - names:
      - '/etc/resolv.conf':
        - source: salt://{{slspath}}/files/resolv.conf
      - '/sbin/call_home':
        - contents: 'salt-call --state_output=mixed state.apply'
        - mode: 755
    - mode: 644
    - template: jinja
    - user: root
    - group: root
    - follow_symlinks: False

# Ensure services are running.
ubuntu_service_running:
  service.running:
    - name: 'salt-minion'
    - enable: True

# End of configuration file.
