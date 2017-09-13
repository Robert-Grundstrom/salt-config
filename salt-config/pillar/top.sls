base:
  'fqdn:{{salt['grains.get']('fqdn')}}':
    - match: grain
    - ignore_missing: True
    - fqdn.{{salt['grains.get']('fqdn').split('.')|join('_')}}

  '*':
    - default
    - users
