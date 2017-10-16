{%set fw_enable = salt['pillar.get']('server:settings:firewall:enable', False)%}
{%set firewall = salt['pillar.get']('server:settings:firewall:rules', {})%}
# iptables is used as a firewall for clients.
# This is for ipv4 only!
# 
# Install of the dependencys needed for iptables to work.
fwpkg_dep:
  pkg.latest:
  - pkgs:
    - iptables
{%-if not salt['grains.get']('os') in ['CentOS', 'Redhat']%}
    - iptables-persistent
{%-endif%}

# Setting up the chains we will be using.
# Custom is used for the rules that are set in the pillar files.
set_fwchains:
  iptables.chain_present:
  - names:
    - 'CUSTOM'
  - family: 'ipv4'

# The basic settings for iptables is set here.
# More advanced rules are set in the states
# for each service.

set_fwrules:
  iptables.insert:
  - names:
  # Related, Established connections are able to keep
  # thair connectios alive.
    - 'related-established':
      - position: '1'
      - connstate: 'ESTABLISHED,RELATED'

  # We will enable the use of the loopback interface.
    - 'loopback':
      - position: '2'
      - i: lo
      - jump: 'ACCEPT'
      - comment: "Accept lo traffic"

  # Adding jump to the CUSTOM chain.
  # Here you can find the rules that are defined in
  # the pillar data
    - 'Custom Accept':
      - position: '3'
      - chain: 'INPUT'
      - jump: 'CUSTOM'
      - comment: 'Jump to Salt Custom rules.'

  # Common for all rules.
  - table: 'filter'
  - chain: 'INPUT'
  - jump: 'ACCEPT'
  - save: True

# Setting the custom rules of the server defined by pillar.
{%-if firewall is defined%}
  {%-for fw_value in firewall%}
    {%-set proto, dport, source = fw_value.split(',')%}

{{proto+'/'+dport+'/src:'+source}}:
  iptables.append:
  - chain: 'CUSTOM'
  - proto: {{proto}}
  - dport: {{dport}}
  - source: {{source}}
  {%-endfor%}
{%-endif%}

# Here we have fw_enable pillar setting regarding if the DROP policy to
# the INPUT chain. (Default False) This is used to avoid accidental lockout.
# check your rules before setting fw_enable = True
set_fwpolicys:
  iptables.set_policy:
  - chain: 'INPUT'
  - table: filter
  - family: ipv4
{%-if fw_enable == True%}
  - policy: DROP
{%-else%}
  - policy: ACCEPT
{%-endif%}
