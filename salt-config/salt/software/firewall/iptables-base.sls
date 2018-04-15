{%- from slspath + '/map.jinja' import iptables with context %}
# Install packets:
iptables-pkg:
  pkg.latest:
  - pkgs:
    - {{iptables.pkg}}
{%-if not salt['grains.get']('os') in ['CentOS', 'Redhat']%}
    - iptables-persistent
{%-endif%}

firewalld-dead:
  service.dead:
    - name: 'firewalld'
    - enable: False

# Setting up the chains we will be using.
# Custom is used for the rules that are set in the pillar files.
iptables-chains:
  iptables.chain_present:
  - names:
    - 'SERVICES'
    - 'PILLAR'
  - family: 'ipv4'

# The basic settings for iptables is set here.
# More advanced rules are set in the states
# for each service.

iptables-rules:
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

# Setting the custom rules of the server defined by pillar.
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

# Here we have fw_enable pillar setting regarding if the DROP policy to
# the INPUT chain. (Default False) This is used to avoid accidental lockout.
# check your rules before setting fw_enable = True
iptable-policy:
  iptables.set_policy:
    - chain: 'INPUT'
    - table: filter
    - family: ipv4
    - save: True
    - policy: ACCEPT 

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

{%-if salt['grains.get']('os') in ['CentOS', 'Redhat']%}
iptables-service:
  service.running:
    - name: 'iptables'
    - enable: 'true'
{%-endif%}
