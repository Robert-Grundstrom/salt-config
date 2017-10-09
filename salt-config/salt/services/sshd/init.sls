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

set_sshd_fwrule:
  iptables.append:
  - names:
    - 'sshd TCP/22/1:':
      - position: 4
      - match: 'recent --set'
      - source: {{salt['pillar.get']('server:settings:hardned_ssh:source')}}
      - connstate: 'NEW'
      - dport: '22'
    - 'sshd TCP/22':
      - position: 5
      - match: 'recent --update --seconds 30 --hitcount 4'
      - source: {{salt['pillar.get']('server:settings:hardned_ssh:source')}}
      - jump: 'LOGDROP'
      - connstate: 'NEW'
      - dport: '22'
  - chain: 'DEFAULT'
  - proto: 'tcp'
  - table: filter
  - save: True
  {%if interface is defined%}
  - i: {{interface}}
  {%endif%}

apply_sshd_config:
  file.managed:
    - names:
      - '/etc/ssh/sshd_config':
        - source: salt://{{slspath}}/files/sshd_config
      - '/etc/rsyslog.d/30-iptables.conf':
        - contents: ':msg,contains,"[netfilter] " /var/log/iptables.log'
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
