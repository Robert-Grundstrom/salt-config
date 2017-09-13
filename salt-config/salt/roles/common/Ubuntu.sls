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
  pkg.latest
{%- endfor %}

# Apply configuration files.
ubuntu_apply_configuration:
  file.managed:
    - names:
      - '/etc/network/interfaces':
        - source: 'salt://{{slspath}}/files/interfaces'
      - '/etc/modules':
        - replace: False
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

/etc/modules:
  file.append:
    - text: 'bonding'

# Ensure services are running.
ubuntu_service_running:
  service.running:
    - names:
      - 'salt-minion'
      - 'networking':
        - watch:
          - file: 'ubuntu_apply_configuration'
          - file: '/etc/modules'
    - enable: True

# End of configuration file.
