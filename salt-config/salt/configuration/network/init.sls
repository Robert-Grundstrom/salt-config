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
network_conf:
  file.managed:
    - names:

{%- if salt['grains.get']('os') in ['Ubuntu', 'Debian'] %}
      - '{{ network.path }}':
        - source: 'salt://{{slspath}}/files/network.cfg'
{%-endif%}

{%-if salt['grains.get']('os') in ['CentOS', 'RedHat']%}


{%-endif%}

      - '/etc/resolv.conf':
        - source: 'salt://{{slspath}}/files/resolv.conf'
        - slspath: '{{ slspath }}'

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
      - '{{network.service}}':
        - watch:
          - file: 'network_conf'
{%-if salt['grains.get']('os') in ['Ubuntu', 'Debian']%}
    - reload: True
{%-endif%}
    - enable: True

#      - '/sbin/call_home':
#        - contents: 'salt-call --state_output=mixed state.apply'
#        - mode: 755



# End of configuration file.
