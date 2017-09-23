{%-if salt['grains.get']('os') == "CentOS" %}
  {%-set service_name = "ntpd"%}
  {%-set pkg_name = "ntp"%}
{%endif%}
{%-if salt['grains.get']('os') == "Ubuntu" %}
  {%-set service_name = "ntp"%}
  {%-set pkg_name = "ntp"%}
{%-endif%}

ntp_install:
  pkg.latest:
    - pkgs:
      - {{pkg_name}}

apply_ntp_configuration:
  file.managed:
    - names:
      - '/etc/ntp.conf':
        - source: salt://{{slspath}}/files/ntp.conf
    - mode: 644
    - follow_symlinks: False
    - template: jinja
    - user: root
    - group: root

service_ntp_running:
  service.running:
    - name: {{service_name}}
    - enable: True
    - watch:
      - file: apply_ntp_configuration 
      - pkg: ntp_install
