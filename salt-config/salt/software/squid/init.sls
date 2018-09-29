squid_pkgs:
  pkg.latest:
    - names:
      - 'squid'

# Verify that chain is setup.
squid_fwchains:
  iptables.chain_present:
  - names:
    - 'SERVICES'
  - family: 'ipv4'

# Add firewall rules.
squid_fwrules:
  iptables.append:
  - names:
    - 'squid':
      - dport: {{ salt['pillar.get']('software:squid:config:http_port', '3128') }}
      - jump: 'ACCEPT'
      - comment: 'squid'
  - chain: 'SERVICES'
  - proto: 'tcp'
  - table: filter
  - save: True

squid_conf:
  file.managed:
    - names:
      - '/etc/squid/squid.conf':
        - source: salt://{{slspath}}/files/squid.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644

squid_running:
  service.running:
    - names:
      - 'squid'
    - watch:
      - pkg: squid_pkgs
      - file: squid_conf
