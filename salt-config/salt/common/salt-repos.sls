# Adds Saltstack repos to servers.
---
# Set common variable.
{%set oscode = salt['grains.get']('oscodename')%}

# Centos
{%if salt['grains.get']('os') == "CentOS"%}

salt-latest:
  {%set url = 'https://repo.saltstack.com/yum/redhat/$releasever/$basearch/'%}

  pkgrepo.managed:
    - humanname: 'SaltStack Latest Release Channel for RHEL/Centos $releasever'
    - baseurl: '{{url}}latest'
    - enabled: 1
    - gpgcheck: 1
    - key_url: '{{url}}latest/SALTSTACK-GPG-KEY.pub'

# Ubuntu
{%elif salt['grains.get']('os') == 'Ubuntu'%}

repos_ubuntu:
  {%set oscode = salt['grains.get']('oscodename')%}  
  {%if oscode == "zesty"%}
    {%set oscode = "xenial"%}
  {%endif%}

  {%set osrel = salt['grains.get']('osrelease')%}
  {%if osrel == "17.04"%}
    {%set osrel = "16.04"%}
  {%endif%}
  {%set url = '://repo.saltstack.com/apt/ubuntu/'+osrel+'/amd64/latest'%}

  pkgrepo.managed:
    - humanname: 'Saltstack repository.'
    - name: 'deb http{{url}} {{oscode}} main'
    - dist: '{{oscode}}'
    - file: '/etc/apt/sources.list.d/saltstack.list'
    - key_url: 'https{{url}}/SALTSTACK-GPG-KEY.pub'

# Debian
{%elif salt['grains.get']('os') == 'Debian'%}

repos_debian:
  {%set osrel = salt['grains.get']('osmajorrelease')%}
  {%set url = '://repo.saltstack.com/apt/debian/'+osrel+'/amd64/latest'%}

  pkgrepo.managed:
    - humanname: 'Saltstack repository.'
    - name: 'deb http{{url}} {{oscode}} main'
    - dist: '{{oscode}}'
    - file: '/etc/apt/sources.list.d/saltstack.list'
    - key_url: 'https{{url}}/SALTSTACK-GPG-KEY.pub'

{% endif %}
