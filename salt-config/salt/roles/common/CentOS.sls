# Salt Centos configuration file.
---
# Install default packets.
{%-for packet in salt['pillar.get']('server:settings:set_default_packets',)%}
{{packet}}:
  pkg.latest
{%- endfor %}

# Apply configuration files.
centos_apply_configuration:
  file.managed:
    - names:

      {%for device in salt['pillar.get']('server:settings:network')%}
      - '/etc/sysconfig/network-scripts/test-ifcfg-{{device}}':
        - source: salt://{{slspath}}/files/ifcfg-
      {%endfor%}        

      - '/sbin/call_home':
        - contents: 'salt-call --state_output=mixed state.apply'
        - mode: 755

      - '/etc/resolv.conf':
        - source: salt://{{slspath}}/files/resolv.conf

    - mode: 644
    - follow_symlinks: False
    - template: jinja
    - user: root
    - group: root

# Ensure services are running.
centos_service_running:
  service.running:
    - names:
      - 'salt-minion'
    - enable: True

# End of configuration file.
