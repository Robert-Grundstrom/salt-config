call_home_conf:
  file.managed:
    - names:
        - '/sbin/call_home':
          - contents: 'salt-call --state_output=mixed state.apply'
          - mode: 755
