# As an extra layer of protection you can set the hardned_ssh to
# 'True' in your pillar files. This will set a more restricted
# configuration as well as added security to the iptables rules.
#
# This should not be needed if you dont have an open port for SSH
# access to the Internet. Some general advice regarding having SSH
# open towards the internet.
#
# - Don't use the default port. (TCP/22)
# - Force certificate login.
# - Disable passwords.

install_sshd_pkgs:
  pkg.latest:
    - pkgs:
      - openssh-server
      - rsyslog

set_sshd_fwchains:
  iptables.chain_present:
  - names:
    - 'SSHSCAN'
  - family: 'ipv4'

set_sshd_fwrule:
  iptables.append:
  - names:
    - 'SSH Connections':
      - chain: 'INPUT'
      - jump: 'SSHSCAN'
      - i: '!lo'
      - dport: '22'
      - connstate: 'NEW'
      - match: state

    - 'SSHD resource':
      - match: 'recent --set --name SSH --rsource'
      - connstate: 'NEW'

    - 'SSHD rule 1':
      - match: 'recent --update --seconds 120 --hitcount 10 --name SSH --rsource'
      - jump: 'LOG'
      - log-prefix: '[SSH Brute-Force attempt:] '
      - log-level: '7'

    - 'SSHD Drop':
      - jump: 'REJECT'
      - match: 'recent --update --seconds 120 --hitcount 10 --name SSH --rsource'
      - connstate: 'NEW'

{%for source in salt['pillar.get']('server:settings:ssh_config:source')%}
    - 'Accept {{source}}':
      - jump: 'ACCEPT'
      - source: {{source}}
{%endfor%}
 
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

sshd_services_running:
  service.running:
    - names: 
      - 'sshd':
        - watch:
          - pkg: install_sshd_pkgs
          - file: apply_sshd_config
      - 'rsyslog':
        - watch:
          - file: apply_sshd_config
    - enable: True
