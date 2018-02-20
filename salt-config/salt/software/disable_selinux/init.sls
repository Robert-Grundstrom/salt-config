# selinux is broken for ubuntu so ignoring.
{%if not salt['grains.get']('os') in ['Ubuntu', 'Debian']%}
install_dependecys:
  pkg.latest:
  - pkgs:
    - 'policycoreutils'
    - 'policycoreutils-python'

set_selinux_mode:
  selinux.mode:
  - name: Permissive

set_selinux_config:
  file.managed:
  - names:
    - '/etc/selinux/config':
      - source: salt://{{slspath}}/files/config
  - user: root
  - group: root
  - mode: 644
{%endif%}
