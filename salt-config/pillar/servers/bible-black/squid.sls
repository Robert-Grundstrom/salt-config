software:
  squid:
    networks:
      localnet: '172.18.0.0/24'

    devices:
      bingo: '172.18.0.10/32'
      core: '172.18.0.254/32'

    url:
      blacknet: '.blacknet.lan'
      facebook: '.facebook.com'
      hotmail: '.hotmail.com'
      google: '.google.com'

    rules:   
      rule01:
        name: facebook 

      rule02:
        name: blacknet
        objects:
          localnet: allow

    config:
      http_port: 3128
