# Add administration users to servers.
---
# Checks for administrators in pillar files and adds users to server.
{%set if_master = salt['grains.get']('fqdn')%}
{%- for user in salt['pillar.get']('set_users') %}
  {%set if_admin = salt['pillar.get']('set_users:'+user+':set_team')%}
  {%- if if_admin == "administrator" or if_master == "salt-master.it.op5.com" %}

{{user}}:
  group:
    - present
  user.present:
    - fullname: {{salt['pillar.get']('set_users:'+user+':set_fullname')}} 
    - shell: /bin/bash
    - home: /home/{{user}}
    - password: {{salt['pillar.get']('set_default_password')}}
    - enforce_password: True
    - groups:
      - {{user}}

  ssh_auth.present:
    - user: {{user}}
    - source: salt://.ssh_keys/{{user}}.authkey
    - config: '%h/.ssh/authorized_keys'

  {% endif %}
{% endfor %}

# Applies sudoers to salt-master.
sudoers_saltmaster:
  file.managed:
    - names:
      - '/etc/sudoers.d/administrators':
        - source: salt://{{slspath}}/files/administrators
    - mode: 0400
    - template: jinja
    - user: root
    - group: root
    - follow_symlinks: False

# Creates local users if pillar is defined.
{%- if salt['pillar.get']('set_local_user') %}
  {%- for local_user in salt['pillar.get']('set_local_user') %}
{{local_user}}:
  group:
    - present
  user.present:
    - fullname: {{salt['pillar.get']('set_local_user:'+local_user+':set_fullname')}}
    - shell: /bin/bash
    - home: /home/{{local_user}}
    - password: {{salt['pillar.get']('set_local_user:'+local_user+':set_local_password')}}
    - enforce_password: True
    - groups:
      - {{local_user}}
  {% endfor %}
{% endif %}

# Delete users if pillar is defined.
{%- if salt['pillar.get']('remove_user') %}
  {% for del_user in salt['pillar.get']('remove_user') %}
    {% if not del_user in salt['pillar.get']('set_users', {}) %}
{{del_user}}:
  user.absent:
  - name: {{del_user}}
  file.absent:
  - name: /home/{{del_user}}
    {% endif %}
  {% endfor %}
{% endif %}

# End of configuration file.
