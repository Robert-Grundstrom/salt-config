{%- from slspath + '/map.jinja' import iptables with context %}
# SSHD configuration.

# Intalling and keeping service up to date.
sshd-pkgs:
  pkg.latest:
    - pkgs:
      - openssh-server
      - rsyslog

# Set up a iptables chain for the service.
sshd-chain:
  iptables.chain_present:
  - names:
    - 'SSHSCAN'
  - family: 'ipv4'

# Set up the iptable rules.
flush-sshscan:
  iptables.flush:
    - chain: 'SSHSCAN'

sshd-rules:
  iptables.append:
  - names:
    - 'SSH Connections':
      - chain: 'SERVICES'
      - jump: 'SSHSCAN'
      - i: '!lo'
      - dport: '22'
      - connstate: 'NEW'

    - 'SSHD Set':
      - match: 'recent --set --name SSH --rsource'
      - connstate: 'NEW'

    - 'SSHD Log':
      - match: 'recent --update --name SSH --rsource'
      - jump: 'LOG'
      - log-prefix: '[SSH Brute-Force attempt:] '
      - log-level: '7'
      - seconds: '120'
      - hitcount: '20'

    - 'SSHD Drop':
      - jump: 'DROP'
      - match: 'recent --update --name SSH --rsource'
      - connstate: 'NEW'
      - seconds: '120'
      - hitcount: '20'

    - 'SSHD Accept':
      - jump: 'ACCEPT'
      - source: {{salt['pillar.get']('software:ssh:source', '0.0.0.0/0')}}
 
  - chain: 'SSHSCAN'
  - proto: 'tcp'
  - table: filter
  - save: True

sshd-config:
  file.managed:
    - names:
      - '/etc/ssh/sshd_config':
        - source: salt://{{slspath}}/files/sshd_config

      - '/etc/rsyslog.d/30-iptables.conf':
        - contents: ':msg,contains,"[SSH Brute-Force attempt:] " /var/log/iptables.log'

      - '/var/log/iptables.log':
        - create: True
        - mode: 640
        - user: {{iptables.rsyslog_usr}}
        - group: {{iptables.rsyslog_grp}}
        - replace: False
    - mode: 644
    - user: root
    - group: root
    - template: jinja

# Make sure services are running.
sshd-services:
  service.running:
    - names: 
      - 'sshd'
    - enable: True
    - watch:
      - file: sshd-config
      - pkg: sshd-pkgs
