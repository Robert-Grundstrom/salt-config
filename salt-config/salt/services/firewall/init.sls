fwpkg_dep:
  pkg.latest:
  - pkgs:
    - iptables-persistent
    - iptables

set_fwchains:
  iptables.chain_present:
  - names:
    - 'Default-Input'
    - 'Custom-Input'
  - family: 'ipv4'

set_fwrules:
  iptables.append:
  - names:
    - 'Default Accept':
      - chain: 'INPUT'
      - jump: 'Default-Input'

    - 'Custom Accept':
      - chain: 'INPUT'
      - jump: 'Custom-Input'

    - 'related-established':
      - chain: 'Default-Input'
      - connstate: RELATED,ESTABLISHED
      - jump: ACCEPT

    - 'loopback':
      - i: lo
      - chain: 'Default-Input'

    - 'sshd TCP/22':
      - chain: 'Default-Input'
      - dport: 22
      - proto: tcp
  - table: filter
  - save: True

{%if salt['pillar.get']('server:settings:firewall:rules') is defined%}
  {%for i in salt['pillar.get']('server:settings:firewall:rules', {})%}
    {%set val1, val2, val3 = i.split(',')%}

{{val1+'/'+val2+'/src:'+val3}}:
  iptables.append:
  - chain: 'Custom-Input'
  - proto: {{val1}}
  - dport: {{val2}}
  - source: {{val3}}
  {%endfor%}
{%endif%}

set_fwpolicys:
  iptables.set_policy:
  - chain: 'INPUT'
  - table: filter
  - family: ipv4
{%if salt['pillar.get']('server:settings:firewall:enable') == True%}
  - policy: DROP
{%else%}
  - policy: ACCEPT
{%endif%}
