install_dependecys:
  pkg.latest:
  - pkgs:
    - 'policycoreutils'
{%if salt['grains.get']('os') == "CentOS"%}
    - 'policycoreutils-python'
{%endif%}
{%if salt['grains.get']('osfinger') == "Ubuntu-17.04"%}
    - 'policycoreutils-python-utils'
{%endif%}
set_selinux_mode:
  selinux.mode:
  - name: Disabled

set_selinux_config:
  file.managed:
  - names:
    - '/etc/selinux/config':
      - source: salt://{{slspath}}/files/config
  - user: root
  - group: root
  - mode: 644
