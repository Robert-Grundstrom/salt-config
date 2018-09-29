
repo_config:
  file.recurse:
    - name: '/etc/yum.repos.d/'
    - source: salt://{{ slspath }}/files/yum.repos.d
    - user: root
    - group: root
    - clean: True

repo_keys:
  file.managed:
    - name: '/etc/pki/rpm-gpg/saltstack-signing-key'
    - source: 'salt://{{ slspath }}/files/saltstack-signing-key'
    - user: 'root'
    - group: 'root'
    - mode: 0644

repo_clean:
  cmd.run:
    - names:
      - 'yum clean all'
      - 'rm -rf /var/cache/yum'
    - onchanges:
      - file: repo_config
      - file: repo_keys
