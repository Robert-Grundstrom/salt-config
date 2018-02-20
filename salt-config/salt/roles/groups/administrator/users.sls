# Add administration users to servers.
---
# Checks for administrators in pillar files and adds users to server.
{%- for user in salt['pillar.get']('server:set_users') %}
  {%- if salt['pillar.get']('server:set_users:'+user+':set_team') == "administrator" %}

{{user}}:
  group:
    - present
  user.present:
    - fullname: {{salt['pillar.get']('server:set_users:'+user+':set_fullname')}} 
    - shell: /bin/bash
    - home: /home/{{user}}
    - password: {{salt['pillar.get']('server:set_users:'+user+':set_passwd')}}
    - enforce_password: True
    - groups:
      - {{user}}
{%-if salt['grains.get']('os') in ['OpenBSD']%}
      - wheel
{%-endif%}

  ssh_auth.present:
    - comment: 'Adding keys'
    - user: {{user}}
    - source: 'salt://.ssh-keys/{{user}}.auth'
    - config: '%h/.ssh/authorized_keys'

  {% endif %}
{% endfor %}

# Ensure wheel and root group is present.
{%-if salt['grains.get']('os') in ['OpenBSD']%}
core_groups:
  group.present:
  - names:
    - 'root'
    - 'wheel'
{%-endif%}
# Applies sudoers to salt-master.
sudoers_dir:
  file.directory:
  - mode: 755
  - name: /etc/sudoers.d
  - user: root
{%-if salt['grains.get']('os') in ['OpenBSD']%}
  - group: wheel
{%-else%}
  - group: root
{%-endif%}

sudoers_saltmaster:
  file.managed:
    - names:
      - '/etc/sudoers.d/administrators':
        - source: salt://{{slspath}}/files/administrators
    - makedirs: True
    - dirmode: 755
    - mode: 0440
    - template: jinja
    - user: root
    - follow_symlinks: False
  {%-if salt['grains.get']('os') in ['OpenBSD']%}
    - group: wheel
  {%-else%}
    - group: root      
  {%-endif%}

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
