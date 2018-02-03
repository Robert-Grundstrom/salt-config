{% from slspath + '/map.jinja' import osystem with context %}
# Adds Saltstack repos to servers.
---
# Ubuntu
{%-if salt['grains.get']('os') in ['Ubuntu']%}
repos_ubuntu:
  pkgrepo.managed:
    - humanname: 'Saltstack repository.'
    - name: 'deb http://storage.blacknet.lan/salt xenial main'   
    - dist: 'xenial'
    - file: '/etc/apt/sources.list.d/saltstack.list'
    - key_url: 'http://storage.blacknet.lan/salt/key/SALTSTACK-GPG-KEY.pub'
{%endif%}
