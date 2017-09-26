base:
  '*':
    - users
    - default

  'fqdn:{{salt['grains.get']('fqdn')}}':
    - match: grain
    - fqdn.{{salt['grains.get']('fqdn').split('.')|join('_')}}
