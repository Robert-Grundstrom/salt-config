{% if salt['pillar.get']('software:inspircd') %}
{% from slspath + '/map.jinja' import inspircd with context %}
# Install pakets and check for updates.
inspircd_pkgs:
  pkg.latest:
    - pkgs:
      - 'inspircd'
      - 'libmysqlclient20'
      - 'libpq5'
      - 'libtre5'

inspircd_fwrules:
  iptables.append:
  - names:
    - 'inspircd':
      - dport: {{inspircd.port}}
      - comment: 'inspircd'
  - chain: 'SOFTWARE'
  - proto: 'tcp'
  - table: filter
  - save: True

inspircd_config:
  file.managed:
    - names:
      - '/etc/inspircd/inspircd.conf':
        - source: 'salt://{{ slspath }}/files/inspircd.conf'
        - slspath: '{{ slspath }}'

      - '/etc/inspircd/inspircd.motd':
        - source: 'salt://{{ slspath }}/files/inspircd.motd'

      - '/etc/inspircd/inspircd.rules':
        - source: 'salt://{{ slspath }}/files/inspircd.rules'
    - user: root
    - group: root
    - mode: 644
    - template: jinja

inspircd_serice:
  service.running:
    - names:
      - 'inspircd'
    - watch:
      - pkg: inspircd_pkgs
      - file: inspircd_config

{%endif%}
