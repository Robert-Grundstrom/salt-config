software:
  squid:
# Creates src acls to use for networks:
    networks:
      localnet: '192.168.0.0/24'

# Creates src acls to use for specific devices:
    devices:
      host1: '192.168.0.10/32'
      host2: '192.168.0.11/32'

# Creates dstdomain acls to use with URLS:
    url:
      facebook: '.facebook.com'
      hotmail: '.hotmail.com'
      google: '.google.com'

# ----------------------------------------------------------- #
# Anything that is defined in rules automatically gets a deny #
# rule. You dont need to define objects if you simply want a  #
# deny a acl. Example:                                        #
#                                                             #
#    rules:                                                   #
#      rule01:                                                #
#        name: 'facebook'                                     #
#                                                             #
# Will set "http_access deny facebook"                        #
# If you want to allow access for a specific acl then add it  #
# under objects, example:                                     #
#                                                             #
#      rule02:                                                #
#        name: 'facebook'                                     #
#        objects:                                             #
#          'localnet': 'allow'                                #
#                                                             #
# Will set:                                                   #
# "http_access allow facebook localnet"                       #
# "http_access deny facebook"                                 #
#                                                             #
# ----------------------------------------------------------- #

    rules:   
      rule01:
        name: facebook 

      rule02:
        name: google
        objects:
          localnet: allow

    config:
      http_port: 3128
