# SSHD configuration.

# Intalling and keeping service up to date.
install_sshd_pkgs:
  pkg.latest:
    - pkgs:
      - openssh-server
      - rsyslog

# Set up a iptables chain for the service.
set_sshd_fwchains:
  iptables.chain_present:
  - names:
    - 'SSHSCAN'
  - family: 'ipv4'

# Set up the iptable rules.
set_sshd_chainrule:
  iptables.append:
  - name: 'SSH Connections'
  - chain: 'INPUT'
  - jump: 'SSHSCAN'
  - i: '!lo'
  - dport: '22'
  - connstate: 'NEW'
  - match: 'state'
  - proto: 'tcp'
  - table: filter
  - save: True

set_sshd_fwrules:
  iptables.insert:
  - names:
    - 'SSHD Set':
      - position: '1'
      - match: 'recent --set --name SSH --rsource'
      - connstate: 'NEW'

    - 'SSHD Log':
      - position: '2'
      - match: 'recent --update --seconds 120 --hitcount 10 --name SSH --rsource'
      - jump: 'LOG'
      - log-prefix: '[SSH Brute-Force attempt:] '
      - log-level: '7'

    - 'SSHD Drop':
      - position: '3'
      - jump: 'REJECT'
      - match: 'recent --update --seconds 120 --hitcount 10 --name SSH --rsource'
      - connstate: 'NEW'

    - 'SSHD Accept':
      - position: '4'
      - jump: 'ACCEPT'
      - source: {{salt['pillar.get']('server:settings:ssh_config:source')}}
 
  - chain: 'SSHSCAN'
  - proto: 'tcp'
  - table: filter
  - save: True

apply_sshd_config:
  file.managed:
    - names:
      - '/etc/ssh/sshd_config':
        - source: salt://{{slspath}}/files/sshd_config

      - '/etc/rsyslog.d/30-iptables.conf':
        - contents: ':msg,contains,"[SSH Brute-Force attempt:] " /var/log/iptables.log'

      - '/var/log/iptables.log':
        - create: True
        - mode: 640
        - user: syslog
        - group: adm
        - replace: False
    - mode: 644
    - user: root
    - group: root
    - template: jinja

# Make sure services are running.
sshd_services_running:
  service.running:
    - names: 
      - 'sshd'
      - 'rsyslog'
    - enable: True
    - watch:
      - file: apply_sshd_config
      - pkg: install_sshd_pkgs
