{%- from slspath + '/map.jinja' import iptables with context %}

# Pillar example:
# -------------------------------------------
# software:
#   firewall:
#    - enable: True
#    - rules:
#      - 'TCP,80,172.18.0.0/24'
#      - 'TCP,443,172.18.0.0/24'
#
# Rules syntax: protocol,port,source/prefix
# -------------------------------------------

# Install packets:
iptables-pkg:
  pkg.latest:
  - pkgs:
    - {{iptables.pkg}}
{%-if not salt['grains.get']('os') in ['CentOS', 'Redhat']%}
    - iptables-persistent
{%-endif%}

# Later distros of Ubuntu and CentOS is using firewalld
# so we want to disable that one.
firewalld-dead:
  service.dead:
    - name: 'firewalld'
    - enable: False

# Setting up the chains we will be using.
iptables-chains:
  iptables.chain_present:
  - names:
    - 'SERVICES'
    - 'PILLAR'
  - family: 'ipv4'

# The basic settings for iptables is set here.
iptables-rules:
  iptables.append:
  - names:
    # Related, Established connections are able to keep thair connectios alive.
    - 'related-established':
      - connstate: 'ESTABLISHED,RELATED'

    # We will enable the use of the loopback interface.
    - 'loopback':
      - i: lo
      - jump: 'ACCEPT'
      - comment: "Accept lo traffic"

    # The jumps to our chains.
    - 'Services Accept':
      - jump: 'SERVICES'
      - comment: 'Jump to SERVICES chain.'
      - connstate: 'NEW'

    - 'Pillar Accept':
      - jump: 'PILLAR'
      - comment: 'Jump to PILLAR chain.'
      - connstate: 'NEW'

  # Common for all rules.
  - table: 'filter'
  - chain: 'INPUT'
  - jump: 'ACCEPT'
  - family: 'ipv4'
  - save: True

# Setting the pillar rules.
{%- if ['iptables.pillar', None] is defined %}
  {%-for fw_value in iptables.pillar%}
    {%-set proto, dport, source = fw_value.split(',')%}

{{proto+'/'+dport+'/src:'+source}}:
  iptables.append:
  - chain: 'PILLAR'
  - jump: 'ACCEPT'
  - connstate: 'NEW'
  - proto: {{proto}}
  - dport: {{dport}}
  - source: {{source}}
  {%-endfor%}
{%-endif%}

# Setting the INPUT policy to ACCEPT. Since we are using a DROP
# rule instead of the policy. This makes it possible to
# flush iptables witout risking to lock yourself out.
iptable-policy:
  iptables.set_policy:
    - chain: 'INPUT'
    - table: filter
    - family: ipv4
    - save: True
    - policy: ACCEPT 

# Here we have enable/disable setting regarding if the DROP rule for
# the INPUT chain. (Default False) Full pillar path: "software:firewall:enable"
# This is used to enable or disable the firewall.
{%-if iptables.enable == True%}
iptables-drop:
  iptables.append:
    - chain: 'INPUT'
    - jump: 'DROP'
    - table: 'filter'
    - family: 'ipv4'
    - save: True
{%-else%}

iptables-drop:
  iptables.delete:
    - chain: 'INPUT'
    - jump: 'DROP'
    - table: 'filter'
    - family: 'ipv4'
    - save: True
{%-endif%}

# In CentOS and Redhat iptables is a service and needs to be runnung.
{%-if salt['grains.get']('os') in ['CentOS', 'Redhat']%}
iptables-service:
  service.running:
    - name: 'iptables'
    - enable: 'true'
{%-endif%}
