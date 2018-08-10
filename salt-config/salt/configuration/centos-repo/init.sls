
goddamnit1:
  file.recurse:
    - name: '/etc/yum.repos.d/'
    - source: salt://{{ slspath }}/files/yum.repos.d
    - user: root
    - group: root
    - clean: True

goddamnit2:
  file.managed:
    - name: '/etc/pki/rpm-gpg/saltstack-signing-key'
    - source: 'salt://{{ slspath }}/files/saltstack-signing-key'
    - user: 'root'
    - group: 'root'
    - mode: 0644


  cmd.run:
    - name: 'yum clean all'
    - name: 'rm -rf /var/cache/yum'
    - onchange:
      - goddamnit1
      - goddamnit2
