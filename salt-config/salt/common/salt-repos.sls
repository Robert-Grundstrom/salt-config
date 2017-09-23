{% from slspath + '/map.jinja' import os with context %}
# Adds Saltstack repos to servers.
---
# Set common variable.
{%set oscode = salt['grains.get']('oscodename')%}

# Centos
{%-if salt['grains.get']('os') in ['CentOS', 'Redhat']%}
repos_centos:
  pkgrepo.managed:
    - humanname: 'SaltStack Latest Release Channel for RHEL/Centos $releasever'
    - baseurl: '{{os.repo_url}}latest'
    - enabled: 1
    - gpgcheck: 1
    - key_url: '{{os.repo_url}}latest/SALTSTACK-GPG-KEY.pub'

# Ubuntu
{%-if salt['grains.get']('os') in ['Ubuntu', 'Debian']%}
repos_ubuntu:
  {%-if salt['grains.get']('osfinger') in ['Ubuntu-17.04']
    {%set oscode = "xenial"%}
    {%set osrel = "16.04"%}
  {%endif%}

  pkgrepo.managed:
    - humanname: 'Saltstack repository.'
    - name: 'deb http{{os.repo_url}} {{oscode}} main'
    - dist: '{{oscode}}'
    - file: '/etc/apt/sources.list.d/saltstack.list'
    - key_url: 'https{{os.repo_url}}/SALTSTACK-GPG-KEY.pub'
{%endif%}
