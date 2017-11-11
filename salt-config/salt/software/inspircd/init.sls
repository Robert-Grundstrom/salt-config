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

inspircd_dirs:
  file.directory:
    - names:
      - '/etc/inspircd'
      - '/etc/inspircd/sslkeys'
    - makedirs: True
    - user: irc
    - group: irc
    - mode: 770

# openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 1095  
# openssl dhparam -out dhparam.pem 4096

inspircd_config:
  file.managed:
    - names:
      - '/etc/inspircd/sslkeys/cert.pem':
        - create: False
        - replace: False
      - '/etc/inspircd/sslkeys/key.pem':
        - create: False
        - replace: False
      - '/etc/inspircd/sslkeys/dhparam.pem':
        - create: False
        - replace: False

      - '/etc/inspircd/sslkeys/create-cert.sh':
        - source: 'salt://{{ slspath }}/files/create-cert.sh'
        - slspath: '{{ slspath }}'
        - mode: 755
        - user: root
        - group: root

      - '/etc/inspircd/inspircd.conf':
        - source: 'salt://{{ slspath }}/files/inspircd.conf'
        - slspath: '{{ slspath }}'

      - '/etc/inspircd/inspircd.motd':
        - source: 'salt://{{ slspath }}/files/inspircd.motd'

      - '/etc/inspircd/inspircd.rules':
        - source: 'salt://{{ slspath }}/files/inspircd.rules'
    - user: irc
    - group: irc
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
