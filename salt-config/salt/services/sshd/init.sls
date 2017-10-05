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

# The hardned ssh in this case will set another rule to the iptables.
# The new rule will effectivly slow down connection attempts towards
# the standard ssh port (TCP/22) this will prevent any attempts to
# bruteforce your SSH password.
#
# We will also add logging of droped connection atempts.
#
# We will also set the option to restrict SSH access to a ipaddress.
# This will ensure that only a specific ip, ip range can access the 
# server. (Default this is set to 0.0.0.0/0)

{%if salt['pillar.get']('server:settings:hardned_ssh:enable') == True%}
  {%set interface = salt['pillar.get']('server:settings:hardned_ssh:interface')%}
set_sshd_fwrule:
  iptables.append:
  - names:
    - 'LOG-LOGDROP':
      - jump: 'LOG'
      - chain: 'LOGDROP'
    - 'DROP-LOGDROP':
      - jump: 'DROP'
      - chain: 'LOGDROP'
    - 'sshd TCP/22/1:':
      - position: 4
      - match: 'recent --set'
      - source: {{salt['pillar.get']('server:settings:hardned_ssh:source')}}
      - connstate: 'NEW'
      - dport: '22'
    - 'sshd TCP/22':
      - position: 5
      - match: 'recent --update --seconds 60 --hitcount 4'
      - source: {{salt['pillar.get']('server:settings:hardned_ssh:source')}}
      - jump: 'LOGDROP'
      - connstate: 'NEW'
      - dport: '22'
    - 'DROP':
      - position: 200
      - chain: 'INPUT'
      - jump: 'DROP'
      - comment: "Drop everything else"
  - chain: 'DEFAULT'
  - proto: 'tcp'

# {%if interface is defined%}
#   - i: {{interface}}
# {%endif%}
  - table: filter
  - save: True

apply_sshd_config:
  file.managed:
    - name: '/etc/ssh/sshd_config'
    - source: salt://{{slspath}}/files/sshd_config
    - mode: 644
    - user: root
    - group: root
    - template: jinja

{%else%}
set_sshd_fwrule:
  iptables.append:
  - names:
    - 'sshd TCP/22':
      - chain: 'DEFAULT'
      - dport: 22
      - proto: tcp
  - table: filter
  - save: True

apply_sshd_config:
  file.managed:
    - name: '/etc/ssh/sshd_config'
    - source: salt://{{slspath}}/files/sshd_config
    - mode: 644
    - user: root
    - group: root
    - template: jinja

{%endif%}

sshd_services_running:
  service.running:
    - names: 
      - 'sshd'
    - watch:
      - pkg: install_sshd_pkgs
      - file: apply_sshd_config
    - enable: True
