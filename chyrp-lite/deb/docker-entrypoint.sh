#!/bin/sh

# Colors
cend='\033[0m'
darkorange='\033[38;5;208m'
pink='\033[38;5;197m'
purple='\033[38;5;135m'
green='\033[38;5;41m'
blue='\033[38;5;99m'

printf "%b" "[💡 entrypoint - Info] Hiya, you're running as $(whoami)!\n"

if [ -d "/app/www/chyrp" ]; then
	printf "%b" "[✨ " "$purple" "entrypoint - Pass" "$cend" "] ✅ Directory including Chyrp Lite files is mounted correctly\n"
else
	printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] No valid directory was found, looked in: /app/www/chyrp\n"
	printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] This image is intended to be used for existing Chyrp Lite installations\n"
	printf "%b" "[❌ " "$pink" "entrypoint - Error" "$cend" "] Please mount a full Chyrp Lite directory to container and try again!\n"
	exit 0
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
