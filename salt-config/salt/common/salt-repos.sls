{% from slspath + '/map.jinja' import os with context %}
# Adds Saltstack repos to servers.
---
# Centos and Redhat
{%-if salt['grains.get']('os') in ['CentOS', 'Redhat']%}
repos_centos:
  pkgrepo.managed:
    - humanname: 'SaltStack Latest Release Channel for RHEL/Centos $releasever'
    - baseurl: '{{os.repo_url}}'
    - enabled: 1
    - gpgcheck: 1
    - key_url: '{{os.repo_key}}'
{%endif%}

# Ubuntu and Debian.
{%-if salt['grains.get']('os') in ['Ubuntu', 'Debian']%}
repos_ubuntu:
  {%set key = os.repo_key%}
  {%set url = os.repo_url%}
  {%set dist = salt['grains.get']('oscodename')%}
  {%-if salt['grains.get']('osfinger') in ['Ubuntu-17.04']%}
    {%set url = "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main"%}
    {%set key = "https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub"%}
    {%set dist = "xenial"%}
  {%endif%}

  pkgrepo.managed:
    - humanname: 'Saltstack repository.'
    - name: '{{url}}'   
    - dist: '{{dist}}'
    - file: '/etc/apt/sources.list.d/saltstack.list'
    - key_url: '{{key}}'
{%endif%}
