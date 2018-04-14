{% from slspath + '/map.jinja' import firewall with context %}
# iptables is used as a firewall for clients.
# This is for ipv4 only!
# 
# Install of the dependencys needed for iptables to work.
fwpkg_dep:
  pkg.latest:
  - pkgs:
    - {{firewall.pkg}}
{%-if not salt['grains.get']('os') in ['CentOS', 'Redhat']%}
    - iptables-persistent
{%-endif%}

# Setting up the chains we will be using.
# Custom is used for the rules that are set in the pillar files.
set_fwchains:
  iptables.chain_present:
  - names:
    - 'SERVICES'
  - family: 'ipv4'

# The basic settings for iptables is set here.
# More advanced rules are set in the states
# for each service.

set_fwrules:
  iptables.append:
  - names:
  # Related, Established connections are able to keep
  # thair connectios alive.
    - 'related-established':
      - connstate: 'ESTABLISHED,RELATED'

  # We will enable the use of the loopback interface.
    - 'loopback':
      - i: lo
      - jump: 'ACCEPT'
      - comment: "Accept lo traffic"

    - 'Services Accept':
      - jump: 'SERVICES'
      - comment: 'Jump to SERVICES rules.'

  # Common for all rules.
  - table: 'filter'
  - chain: 'INPUT'
  - jump: 'ACCEPT'
  - save: True

# Setting the custom rules of the server defined by pillar.
{%- if salt.pillar.get('firewall:rules', None) is defined %}
set_pillar_chain:
  iptables.chain_present:
  - name: 'PILLAR'
  - family: 'ipv4'

set_pillar_rules:
  iptables.append:
  - name: 'Pillar Accept'
  - jump: 'PILLAR'
  - comment: 'Jump to PILLAR rules.'
  - chain: 'INPUT'

  {%-for fw_value in firewall.pillar%}
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

# Here we have fw_enable pillar setting regarding if the DROP policy to
# the INPUT chain. (Default False) This is used to avoid accidental lockout.
# check your rules before setting fw_enable = True
{%-if firewall.enable == True%}
set_fwpolicys:
  iptables.set_policy:
    - chain: 'INPUT'
    - table: filter
    - family: ipv4
    - save: True
    - policy: DROP

add_drop:
  iptables.append:
    - chain: 'INPUT'
    - jump: 'DROP'

{%-else%}

set_fwpolicys:
  iptables.set_policy:
    - chain: 'INPUT'
    - table: filter
    - family: ipv4
    - save: True
    - policy: ACCEPT

{%-endif%}
