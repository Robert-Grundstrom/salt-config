{%- from slspath + '/map.jinja' import inspircd with context %}
#!/bin/bash
function stop {
	service inspircd stop
}

function start {
	service inspircd start
}

function check_file (){
	RED='\033[0;31m'
	GREEN='\033[0;32m'
	NC='\033[0m'
	FILE=$1
	if  [ -f $FILE ]; then
          echo -e "$FILE \t\t [ ${GREEN}OK${NC} ]"

	else
          echo -e "$FILE \t\t [ ${RED}FAIL!${NC} ]"
          RUN=True

	fi
}

function ask {
echo -e ""
echo -e "The certificates are present."
echo -e "If you continue the present files will be removed "
echo -e ""
read -r -p "Are you sure? [y/N] " response

case "$response" in
	[yY][eE][sS]|[yY]) 
		rm -f /etc/inspircd/sslkeys/*.pem 2> /dev/null
	;;

	*)
	        exit 0
	;;
esac
}

function create {
	echo -e ""
	echo -e "# ######################### #"
	echo -e "# Creating SSL certificate. #"
	echo -e "# ######################### #"
	echo -e ""
openssl req -nodes -newkey rsa:4096 \
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
	openssl dhparam -out /etc/inspircd/sslkeys/dhparam.pem 4096
	chown irc:irc /etc/inspircd/sslkeys/*.pem
}

# If --force is passed.
RUN=False
FORCE=$1
if [ "$FORCE" == "--force" ]; then
	stop
	create
	start
	exit 0
fi

# Normal run
echo -e "# ############################### #"
echo -e "# Checking for certificate files. #"
echo -e "# ############################### #"
check_file /etc/inspircd/sslkeys/key.pem
check_file /etc/inspircd/sslkeys/cert.pem
check_file /etc/inspircd/sslkeys/dhparam.pem

if [ "$RUN" == "True" ]; then
	stop
	create
	start
	exit 0
else
	ask
	stop
	create
	start
	exit 0
fi
