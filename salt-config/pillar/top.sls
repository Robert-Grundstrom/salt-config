base:
  '*':
    - users
    - repositorys 

  'id:{{salt['grains.get']('id')}}':
    - match: grain
    - servers.{{salt['grains.get']('id')}}
