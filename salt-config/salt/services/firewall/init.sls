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
{%endif%}

# Setting up the chains we will be using.
# Custom is used for the rules that are set in the pillar files.
set_fwchains:
  iptables.chain_present:
  - names:
    - 'CUSTOM'
  - family: 'ipv4'

set_fwrules:
  iptables.insert:
  - names:
    - 'related-established':
      - position: '1'
      - connstate: 'ESTABLISHED,RELATED'

    - 'loopback':
      - position: '2'
      - i: lo
      - jump: 'ACCEPT'
      - comment: "Accept lo traffic"

    - 'Custom Accept':
      - position: '3'
      - chain: 'INPUT'
      - jump: 'CUSTOM'
      - comment: 'Jump to Salt Custom rules.'

  - table: 'filter'
  - chain: 'INPUT'
  - jump: 'ACCEPT'
  - save: True

# Setting the custom rules of the server defined by pillar.
{%-if firewall is defined%}
  {%-for i in firewall%}
    {%-set val1, val2, val3 = i.split(',')%}

{{val1+'/'+val2+'/src:'+val3}}:
  iptables.append:
  - chain: 'CUSTOM'
  - proto: {{val1}}
  - dport: {{val2}}
  - source: {{val3}}
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
{%-if salt['pillar.get']('server:settings:firewall:enable') == True%}
  - policy: DROP
{%-else%}
  - policy: ACCEPT
{%-endif%}
