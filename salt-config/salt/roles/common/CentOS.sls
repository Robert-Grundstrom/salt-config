# Salt Centos configuration file.
---
# Install packets.
centos_packets_install:
  pkg.latest:
    - pkgs:
      - ntp
      - vim-enhanced
      - sudo
      - openssh-server

# Apply configuration files.
centos_apply_configuration:
  file.managed:
    - names:
      - '/etc/ntp.conf':
        - source: salt://templates/ntp.conf
      - '/sbin/call_home':
        - contents: 'salt-call --state_output=mixed state.apply'
      - '/etc/resolv.conf':
        - source: salt://templates/resolv.conf
      - '/etc/snmp/snmpd.conf':
        - source: salt://templates/snmpd.conf
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
      - 'ntpd':
        - watch.file: '/etc/ntp.conf'
      - 'snmpd':
        - watch.file: '/etc/snmp/snmpd.conf'
    - enable: True

# End of configuration file.
