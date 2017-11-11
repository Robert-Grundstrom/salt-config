{%- from slspath + '/map.jinja' import inspircd with context %}
#!/bin/bash
RUN=False
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
KEY='/etc/inspircd/sslkeys/key.pem'
CERT='/etc/inspircd/sslkeys/cert.pem'
DHP='/etc/inspircd/sslkeys/dhparam.pem'

service inspircd stop

echo -e "# ################### #"
echo -e "# Checking for files. #"
echo -e "# ################### #"

if [ ! -f $KEY ]; then
  echo -e "$KEY \t\t ${RED}[ File not found! ]${NC}"
  RUN=True

else
  echo -e "$KEY \t\t ${GREEN}[ OK ]${NC}"

fi

if [ ! -f  $CERT ]; then
  echo -e "$CERT \t\t ${RED}[ File not found! ]${NC}"
  RUN=True

else
  echo -e "$CERT \t\t ${GREEN}[ OK ]${NC}"

fi

if [ ! -f  $DHP ]; then
  echo -e "$DHP \t ${RED}[ File not found! ]${NC}"
  RUN=True

else
  echo -e "$DHP \t ${GREEN}[ OK ]${NC}"

fi 

echo -e ""
case "$RUN" in
  True)
    echo "File / Files does not exist creating new SSL certificate."
  ;;
  False)
    echo -e "The certificates are present."
    echo -e "If you continue the present files will be removed "
    echo -e ""
    read -r -p "Are you sure? [y/N] " response
    if [[ "$response" = [yY] ]]
      then
        rm -rf $KEY 2> /dev/null
	rm -rf $CERT 2> /dev/null
	rm -rf $DHP 2> /dev/null

      else
        exit 0

      fi
  ;;
esac

echo -e "# ######################### #"
echo -e "# Creating SSL certificate. #"
echo -e "# ######################### #"
echo -e ""
openssl req -nodes -newkey rsa:2048 \
	-x509 \
	-subj '/C={{inspircd.ssl_country}}/L={{inspircd.ssl_city}}/O={{inspircd.ssl_organisation}}/OU={{inspircd.ssl_unit}}/CN={{inspircd.ssl_hostname}}/ST={{inspircd.ssl_state}}' \
	-keyout /etc/inspircd/sslkeys/key.pem \
	-out /etc/inspircd/sslkeys/cert.pem \
	-days 1095
echo -e ""
echo -e "# ################################### #"
echo -e "# Creating Diffie Hellman parameters. #"
echo -e "# ################################### #"
echo -e ""
openssl dhparam -out /etc/inspircd/sslkeys/dhparam.pem 2048
service inspircd start
