pxenfs_pkgs:
  pkg.latest:
    - pkgs:
      - 'nfs-kernel-server'
      - 'nfs-common'

pxenfs_dir:
  file.directory:
    - names:
      - '/opt/nfs-share'
      - '/opt/nfs-share/ISO'
      - '/opt/nfs-share/home'
      - '/opt/os'

pxenfs_conf:
  file.managed:
    - names:
      - '/etc/exports':
        - source: 'salt://{{slspath}}/files/exports'
    - mode: 644
    - user: root
    - group: root

pxenfs_fstab:
  file.append:
    - name: '/etc/fstab'
    - text: '/opt/nfs-share/home	/home	none	bind	0	0'

pxenfs_service:
  service.running:
    - names:
      - 'nfs-kernel-server'
    - enable: True
    - watch:
      - pkg: pxenfs_pkgs
      - file: pxenfs_dir
      - file: pxenfs_conf
