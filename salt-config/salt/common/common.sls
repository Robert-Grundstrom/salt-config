{% from slspath + '/map.jinja' import os with context %}
# Salt Ubuntu configuration file.
---
# Services that we wont be using.
disabled_services:
  service.dead:
    - names:
        - 'timesyncd'
        - '{{os.network_manager}}'
    - enable: False

# Installs packets.
{%-for packet in salt['pillar.get']('server:settings:set_default_packets',)%}
{{packet}}:
  pkg.latest
{%- endfor %}

# Apply configuration files.
apply_configuration:
  file.managed:
    - names:
      {%if salt['grains.get']('os') in ['Ubuntu', 'Debian']%}
      - '{{os.network_path}}':
        - source: 'salt://{{slspath}}/files/interfaces'
      {%endif%}

      {%-if salt['grains.get']('os') in ['CentOS', 'Redhat']%}
        {%-for device, value in salt.pillar.get('server:settings:network', {}).iteritems()%}
      - '{{os.network_path}}{{device}}':
        - source: 'salt://{{slspath}}/files/interfaces'
        - device: {{device}}
        - ipaddr: {{value['set_ipaddr']}}
        - netmask: {{value['set_netmask']}}
        - gateway: {{value['set_gateway']}}
        {%endfor%}
      {%endif%}

      - '/etc/resolv.conf':
        - source: 'salt://{{slspath}}/files/resolv.conf'

      - '/sbin/call_home':
        - contents: 'salt-call --state_output=mixed state.apply'
        - mode: 755

    - mode: 644
    - template: jinja
    - user: root
    - group: root
    - follow_symlinks: False

# Ensure services are running.
services_running:
  service.running:
    - names:
      - 'salt-minion'
      - '{{os.network}}':
        - watch:
          - file: 'apply_configuration'
    - enable: True

# End of configuration file.
