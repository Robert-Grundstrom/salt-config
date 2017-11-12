{% if salt['pillar.get']('software:inspircd') %}
{% from slspath + '/map.jinja' import inspircd with context %}
# Install pakets and check for updates.
inspircd_pkgs:
  pkg.latest:
    - pkgs:
#      - {{inspircd.packets}} 	# Does not work
      - 'inspircd'
      - 'libmysqlclient20'
      - 'libpq5'
      - 'libtre5'

# Add firewall rules.
inspircd_fwrules:
  iptables.append:
  - names:
    - 'inspircd':
      - dport: '{{ inspircd.port }}'
      - comment: 'inspircd'
  - chain: 'SOFTWARE'
  - proto: 'tcp'
  - table: filter
  - save: True

# Create folders and set modes.
inspircd_dirs:
  file.directory:
    - names:
      - '/etc/inspircd'
      - '/etc/inspircd/sslkeys'
      - '/etc/inspircd/conf.d'
    - makedirs: True
    - user: irc
    - group: irc
    - mode: 770

# If one ore more of the SSL certificate files are missing.
inspircd_ssl:
  cmd.run:
  - name: '/etc/inspircd/sslkeys/create-cert.sh --force'
  - unless:
    - test -f '/etc/inspircd/sslkeys/cert.pem'
    - test -f '/etc/inspircd/sslkeys/key.pem'
    - test -f '/etc/inspircd/sslkeys/dhparam.pem'

# Push inspircd configuration.
inspircd_config:
  file.managed:
    - names:
      - '/etc/inspircd/sslkeys/cert.pem':
        - replace: False
      - '/etc/inspircd/sslkeys/key.pem':
        - replace: False
      - '/etc/inspircd/sslkeys/dhparam.pem':
        - replace: False

      - '/etc/inspircd/sslkeys/create-cert.sh':
        - source: 'salt://{{ slspath }}/files/create-cert.sh'
        - mode: 755
        - user: root
        - group: root

      - '/etc/inspircd/inspircd.conf':
        - source: 'salt://{{ slspath }}/files/inspircd.conf'

      - '/etc/inspircd/inspircd.motd':
        - source: 'salt://{{ slspath }}/files/inspircd.motd'

      - '/etc/inspircd/inspircd.rules':
        - source: 'salt://{{ slspath }}/files/inspircd.rules'

      - '/etc/inspircd/conf.d/operators.conf':
        - source: 'salt://{{ slspath }}/files/operators.conf'

    - slspath: '{{ slspath }}'
    - user: irc
    - group: irc
    - mode: 644
    - template: jinja

# Start the inspircd service.
inspircd_serice:
  service.running:
    - names:
      - 'inspircd'
    - enable: True
    - watch:
      - pkg: inspircd_pkgs
      - file: inspircd_config
{%endif%}
