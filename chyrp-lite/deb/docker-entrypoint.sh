#!/bin/sh

# Colors
cend='\033[0m'
darkorange='\033[38;5;208m'
pink='\033[38;5;197m'
purple='\033[38;5;135m'
green='\033[38;5;41m'
blue='\033[38;5;99m'

printf "%b" "[💡 entrypoint - Info] Hiya, you're running as $(whoami)!\n"

if [ -d /app/www/chyrp ] && [ "$BYPASS_CHECKS" = 0 ]; then
	printf "%b" "[✨ " "$purple" "entrypoint - Pass" "$cend" "] ✅ Directory including Chyrp Lite files is mounted correctly\n"
else
	printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] No valid directory was found, looked in: /app/www/chyrp\n"
	printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] This image is intended to be used for existing Chyrp Lite installations\n"
	printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] Please mount a full Chyrp Lite directory to container and try again!\n"
	exit 0
fi

printf "%b" "[💡 " "$darkorange" "entrypoint" "$cend" "] Grabbing Database connection url from configuration file\n"
DB_IP=$(sed -n '4s/^ *"host": *//p' /app/www/chyrp/includes/config.json.php)
DB_PORT=$(sed -n '5s/^ *"port": *//p' /app/www/chyrp/includes/config.json.php)
DB_TYPE=$(sed -n '10s/^ *"adapter": *//p' /app/www/chyrp/includes/config.json.php)

printf "%b" "[💡 " "$darkorange" "entrypoint" "$cend" "] Normalizing variables\n"
# Even if shellcheck complains, do NOT quote these variables inside or out. It will double quote them and break substitution with sed.
DB_IP=$(echo $DB_IP | sed 's|["",]||g')
DB_PORT=$(echo $DB_PORT | sed 's|["",]||g')
DB_TYPE=$(echo $DB_TYPE | sed 's|["",]||g')

# This was mostly done for fun because why not. More usage of sed to get the practice in.
if [ "$DB_TYPE" = "mysql" ] || [ "$DB_TYPE" = "mariadb" ] && [ "$BYPASS_CHECKS" = 0 ]; then
	printf "%b" "[🔎 " "$blue" "entrypoint - DB Check" "$cend" "] Database type is \"$DB_TYPE\", grabbing credentials from file\n"
	DB_USER=$(sed -n '6s/^ *"username": *//p' /app/www/chyrp/includes/config.json.php)
	DB_PASSWORD=$(sed -n '7s/^ *"password": *//p' /app/www/chyrp/includes/config.json.php)
	# This normalizes it by removing , and "" from JSON configuration
	DB_USER=$(echo $DB_USER | sed 's|["",]||g')
	DB_PASSWORD=$(echo $DB_PASSWORD | sed 's|["",]||g')
	printf "%b" "[🔎 " "$blue" "entrypoint - DB Check" "$cend" "] Checking if container can reach it using mysqladmin\n"
	MYSQL_STATUS=$(/usr/bin/mysqladmin -h ${DB_IP} --port=${DB_PORT} -u ${DB_USER} --password=${DB_PASSWORD} ping)
	case $MYSQL_STATUS in
		"mysqld is alive")
			printf "%b" "[✨ " "$purple" "entrypoint - Pass" "$cend" "] ✅ Database Check passed, mysqladmin reported \"$MYSQL_STATUS\"\n"
		;;
		*)
			printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] Your MySQL or MariaDB container is inaccessible to this host, or is unhealthy.\n"
			printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] mysqladmin reported \"$MYSQL_STATUS\" (are remote connections enabled for your DB user?)\n"
			printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] Bypass this check by setting BYPASS_CHECKS environmental variable to 1\n"
			exit 2
		;;
	esac
	printf "%b" "[♻️ " "$green" "entrypoint - Clean-Up" "$cend" "] Erasing variables...\n"
	DB_USER=""
	DB_PASSWORD=""
	DB_USER=""
	DB_IP=""
	DB_PORT=""
	DB_TYPE=""
	printf "%b" "[💡 " "$darkorange" "entrypoint - Cleanup" "$cend" "] Continuing launch\n"
elif [ "$DB_TYPE" = "pgsql" ] && [ "$BYPASS_CHECKS" = 0 ]; then
  # This check probably doesn't work
	printf "%b" "[❌ " "$pink" "entrypoint - DB Check] Database type is \"$DB_TYPE\"\n"
	printf "%b" "[❌ " "$pink" "♻️ entrypoint - DB Check] Checking if container can reach it using pgsql_isready\n"
	PGSQL_STATUS=$(usr/bin/pg_isready -h $DB_IP -p $DB_PORT)
	case $PGSQL_STATUS in
		1)
			printf "%b" "[✨ " "$purple" "entrypoint - Pass" "$cend" "] ✅ Database Check passed, mysqladmin reported \"$MYSQL_STATUS\"\n"
		;;
		*)
			printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] Your PostgreSQL container is inaccessible to this host, or is unhealthy.\n"
			printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] pg_isready reported \"$PGSQL_STATUS\" (are remote connections enabled?)\n"
			printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] Bypass this check by setting BYPASS_CHECKS environmental variable to 1\n"
			exit 2
		;;
	esac
	
	printf "%b" "[♻️ " "$green" "entrypoint - Clean-Up" "$cend" "] Erasing variables...\n"
	DB_IP=""
	DB_PORT=""
	DB_TYPE=""
	printf "%b" "[💡 " "$darkorange" "entrypoint - Cleanup" "$cend" "] Continuing launch\n"

else
	printf "%b" "[🔎 " "$blue" "entrypoint - DB Check" "$cend" "] Database type is \"$DB_TYPE\"\n"
	printf "%b" "[✨ " "$purple" "entrypoint - Pass" "$cend" "] ✅ Database Check passed! (sqlite database or non-standard)\n"
	printf "%b" "[♻️ " "$green" "entrypoint - Clean-Up" "$cend" "] Erasing variables...\n"
	DB_IP=""
	DB_PORT=""
	DB_TYPE=""
	printf "%b" "[💡 " "$darkorange" "entrypoint - Cleanup" "$cend" "] Continuing launch\n"
fi

printf "%b" "[✨ " "$purple" "entrypoint - envsubst" "$cend" "] Substituting environmental variables for NGINX configuration\n"
envsubst '${WORKER_PROCESSES} ${WORKER_CONNECTIONS} ${MULTI_ACCEPT} ${CLIENT_MAX_BODY_SIZE} ${SENDFILE} ${TCP_NOPUSH} ${CHARSET} ${KEEPALIVE_TIMEOUT} ${GZIP_VARY}' < /app/configs/nginx.conf.template > /app/configs/nginx/nginx.conf
envsubst '${SERVER_PORT} ${CHYRP_SERVER_NAME} ${FASTCGI_CONNECTION} ${VALID_REFS}' < /app/configs/chyrp.conf.template > /app/configs/nginx/sites-enabled/chyrp.conf
printf "%b" "[✨ " "$purple" "entrypoint - Pass" "$cend" "] ✅ Successfully substituted environmental variables for NGINX configuration!\n"

printf "%b" "$darkorange" " ______        _     _                                             \n(_____ \      | |   | |                                            \n _____) )_   _| |__ | |__  _____  ____ _   _ _____  ____ ___ _____ \n|  __  /| | | |  _ \|  _ \| ___ |/ ___) | | | ___ |/ ___)___) ___ |\n| |  \ \| |_| | |_) ) |_) ) ____| |    \ V /| ____| |  |___ | ____|\n|_|   |_|____/|____/|____/|_____)_|     \_/ |_____)_|  (___/|_____)\n" "$cend";
printf "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"
printf "%b" "🗒️ " "$blue" "Setup Guide " "$cend" "- None \n"
printf "%b" "📁 " "$green" "GitHub Repository " "$cend" "- https://github.com/Rubberverse/qor-nginx \n"
printf "🦆 Guacamole, guacamole\n"

printf "%b" "[✨" " $green" "entrypoint" "$cend" "] Starting php-fpm${PHP_VERSION} using tini\n"
tini -- /usr/sbin/php-fpm"${PHP_VERSION}" \
        --daemonize \
        --force-stderr \
        --php-ini /app/configs/fpm/php.ini \
        --fpm-config /app/configs/fpm/php-fpm.conf

printf "%b" "[✨" " $green" "entrypoint" "$cend" "] Starting NGINX using tini and leaving entrypoint\n"
exec tini -- /usr/sbin/nginx \
        -c /app/configs/nginx/nginx.conf \
        -g 'daemon off;'
