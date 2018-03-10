{% from slspath + '/map.jinja' import osystem with context %}
# This is the common configuration file.
# It handels network settings and general packet installation.
---
# Services that we wont be using. 
disabled_services:
  service.dead:
    - names:
        - '{{osystem.network_manager}}'
    - enable: False

# Installs packets that is defined in pillar.
{%-for packet in salt['pillar.get']('software:default_pkgs',)%}
{{packet}}:
  pkg.latest
{%- endfor %}

# Apply configuration files. This will configure network interfaces according
# to the pillar files. /etc/resolv.conf will also be set accoring to pillars.
# /sbin/call_home will be created as a shortcut to
# "salt-call --state_output=mixed state.apply"
apply_configuration:
  file.managed:
    - names:
      - '{{osystem.network_path}}':
        - source: 'salt://{{slspath}}/files/network.cfg'

      - '/etc/resolv.conf':
        - source: 'salt://{{slspath}}/files/resolv.conf'
        - search: {{ salt['pillar.get']('software:dns:set_search') }}
        - nameservers: {{salt['pillar.get']('software:dns:set_server')}}

      - '/sbin/call_home':
        - contents: 'salt-call --state_output=mixed state.apply'
        - mode: 755

    - mode: 644
    - template: jinja
    - user: root
    - group: root
    - follow_symlinks: False

# Ensure services are running. Salt-minion is ensured running and enable.
# Reason for salt-minion to be here is mostly to ensure salt-minion is 
# running after a reboot.
services_running:
  service.running:
    - names:
      - 'salt-minion'
      - '{{osystem.network}}':
        - watch:
          - file: 'apply_configuration'
    - enable: True

# End of configuration file.
