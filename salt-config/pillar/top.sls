base:
  '*':
    - users

  'fqdn:{{salt['grains.get']('fqdn')}}':
    - match: grain
    - fqdn.{{salt['grains.get']('fqdn').split('.')|join('_')}}
