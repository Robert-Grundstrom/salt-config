set_network_config:
  file.managed:
    - names:
      - '/etc/network/interfaces':
        - source: 'salt://{{slspath}}/files/interfaces'
      - '/etc/modules':
        - replace: False
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  
/etc/modules:
  file.append:
    - text: 'bonding'

  service.running:
  - name: networking
  - watch:
    - file: set_network_config
