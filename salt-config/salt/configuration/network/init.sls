{%- from slspath + '/map.jinja' import network with context %}
# This is the common configuration file.
# It handels network settings and general packet installation.
---
# Services that we wont be using. 
disabled_services:
  service.dead:
    - names:
        - '{{ network.manager }}'
    - enable: False

# Apply configuration files. This will configure network interfaces according
# to the pillar files. /etc/resolv.conf will also be set accoring to pillars.
# /sbin/call_home will be created as a shortcut to
# "salt-call --state_output=mixed state.apply"
resolv_conf:
  file.managed:
    - name: '/etc/resolv.conf'
    - source: 'salt://{{slspath}}/files/resolv.conf'
    - slspath: '{{ slspath }}'
    - mode: 644
    - template: jinja
    - user: root
    - group: root
    - follow_symlinks: False

{%- if salt['grains.get']('os') in ['Ubuntu', 'Debian'] %}
network_conf:
  file.managed:
    - name: '{{ network.path }}'
    - source: 'salt://{{slspath}}/files/network.cfg'
    - mode: 644
    - template: jinja
    - user: root
    - group: root
    - follow_symlinks: False

services_running:
  service.running:
    - names:
      - 'salt-minion'
      - '{{network.service}}':
        - watch:
          - file: 'network_conf'
    - reload: True
    - enable: True
{%-endif%}
# End of configuration file.
