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
      - '/sbin/call_home':
        - contents: 'salt-call --state_output=mixed state.apply'
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
