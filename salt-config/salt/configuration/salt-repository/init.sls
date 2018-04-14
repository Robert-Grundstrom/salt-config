# Adds Saltstack repos to servers.
---
{% from slspath + '/map.jinja' import saltrepo with context %}

# Ubuntu
{%-if salt['grains.get']('os') in ['Ubuntu', 'Debian']%}
repos_ubuntu:
  pkgrepo.managed:
    - humanname: 'Saltstack repository.'
    - name: 'deb {{saltrepo.mirror}} {{saltrepo.oscodename}} main'   
    - dist: '{{saltrepo.oscodename}}'
    - file: '/etc/apt/sources.list.d/saltstack.list'
    - key_url: '{{saltrepo.key}}'
{%endif%}

# {%-if salt['grains.get']('os') in ['CentOS', 'RedHat']%}
# repos_ubuntu:
#  pkgrepo.managed:
#    - humanname: 'Saltstack repository.'
#    - name: 'deb http://storage.blacknet.lan/salt xenial main'
#    - dist: 'xenial'
#    - file: '/etc/apt/sources.list.d/saltstack.list'
#    - key_url: 'http://storage.blacknet.lan/salt/key/SALTSTACK-GPG-KEY.pub'
{%endif%}

