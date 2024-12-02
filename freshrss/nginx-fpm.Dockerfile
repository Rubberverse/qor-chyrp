ARG IMAGE_REPOSITORY=docker.io/library
ARG IMAGE_VERSION=bookworm-slim

FROM $IMAGE_REPOSITORY/debian:$IMAGE_VERSION AS debian-base

ARG GIT_BRANCH="1.24.3"
ARG GIT_REPOSITORY="https://github.com/FreshRSS/FreshRSS.git"

ARG DEB="php8.2" \
	PHP_VERSION="8.2" \
	CONT_USER=nginx_user \
	CONT_UID=1001 \
	SERVICE_CONFIG="freshrss.conf" \
	SERVICE_NAME="FreshRSS" \
	DIRECTORY_PATH="/app/www/freshrss" \
	SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64" \
	SUPERCRONIC_SHA1SUM=71b0d58cc53f6bd72cf2f293e09e294b79c666d8 \
	SUPERCRONIC=supercronic-linux-amd64

ENV DEB=$DEB \
	PHP_VERSION=$PHP_VERSION \
	CONT_USER=$CONT_USER \
	CONT_UID=$CONT_UID \
	DEBIAN_FRONTEND=noninteractive \
	SERVICE_CONFIG=$SERVICE_CONFIG \
	SERVICE_NAME=$SERVICE_NAME \
	DIRECTORY_PATH=$DIRECTORY_PATH

COPY --chmod=755 /scripts/remove-junk.sh /app/scripts/remove-junk.sh

WORKDIR /app

RUN apt update \
	&& apt upgrade -y \
	&& apt install --no-install-recommends -y \
		git \
		sed \
		curl \
		adduser \
		openssl=3.0.15-1~deb12u1 \
		sqlite3=3.40.1-2+deb12u1 \
		gettext-base \
		ca-certificates \
	&& addgroup \
		--system \
		--gid ${CONT_UID} \
		${CONT_USER} \
	&& adduser \
		--home "/var/lib/mysql" \
		--shell "/bin/sh" \
		--uid ${CONT_UID} \
		--ingroup ${CONT_USER} \
		--disabled-password \
		${CONT_USER} \
	&& apt install --no-install-recommends -y \
		tini \
		nginx \
		${DEB}=8.2.26-1~deb12u1 \
		${DEB}-gd \
		${DEB}-zip \
		${DEB}-gmp \
		${DEB}-xml \
		${DEB}-fpm \
		${DEB}-exif \
		${DEB}-intl \
		${DEB}-curl \
		${DEB}-iconv \
		${DEB}-mysql \
		${DEB}-pgsql \
		${DEB}-opcache \
		${DEB}-sqlite3 \
		${DEB}-mbstring \
	&& mkdir -p \
		/app/run \
		/app/www \
		/app/scripts \
		/app/logs/fpm \
		/app/logs/nginx \
		/app/configs \
		/app/configs/fpm \
		/app/temp/session \
		/app/temp/opcache \
	&& mv /etc/nginx /app/configs/nginx \
	&& curl -fsSLO "$SUPERCRONIC_URL" \
	&& echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
	&& chmod +x "$SUPERCRONIC" \
	&& mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
	&& ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/sbin/supercronic \
	&& touch \
		/app/logs/fpm/php-error.log \
		/app/logs/fpm/fpm-error.log \
		/app/logs/fpm/fpm-access.log \
		/app/logs/nginx/freshrss.log \
		/app/configs/nginx/sites-enabled/freshrss.conf \
		/app/configs/crontab \
	&& git clone \
		--depth 1 \
		--branch $GIT_BRANCH $GIT_REPOSITORY \
		/app/www/freshrss \
	&& sed -i "s|'disable_update' => false,|'disable_update' => true,|g" /app/www/freshrss/config.default.php \
	&& /app/scripts/remove-junk.sh \
	&& rm /app/scripts/remove-junk.sh

COPY /freshrss/php.ini /app/configs/fpm/php.ini
COPY /configs/fpm.conf /app/configs/fpm/php-fpm.conf
COPY /configs/www.conf /app/configs/fpm/pool.d/www.conf
COPY /configs/nginx.conf /app/configs/nginx.conf.template
COPY /configs/nginx/freshrss.conf /app/configs/freshrss.conf.template
COPY /freshrss/crontab /app/configs/crontab

RUN chown -Rf $CONT_USER:$CONT_USER \
	/app \
	# Hardcoded: https://salsa.debian.org/nginx-team/nginx/-/blob/debian/1.26.0-2/debian/rules#L32
	/var/lib/nginx

COPY --chmod=755 /freshrss/docker-entrypoint.sh /app/scripts/docker-entrypoint.sh

USER $CONT_USER

ENV TINI_SUBREAPER=1 \
	# PHP
	PHP_SHORT_OPEN_TAG="Off" \
	PHP_OUTPUT_BUFFERING=4096 \
	PHP_DISABLE_FUNCTIONS="" \
	PHP_DISABLE_CLASSES="" \
	PHP_IGNORE_USER_ABORT="Off" \
	PHP_REALPATH_CACHE_SIZE="4096k" \
	PHP_REALPATH_CACHE_TTL=120 \
	PHP_ZEND_ENABLE_GC="On" \
	PHP_ZEND_MULTIBYTE="Off" \
	PHP_ZEND_EXCEPTION_IGNORE_ARGS="On" \
	PHP_EXPOSE_PHP="Off" \
	PHP_MAX_EXECUTION_TIME=0 \
	PHP_MAX_INPUT_TIME=-1 \
	PHP_MEMORY_LIMIT="256M" \
	PHP_IGNORE_REPEATED_ERRORS="Off" \
	PHP_IGNORE_REPEATED_SOURCE="Off" \
	PHP_POST_MAX_DATA_SIZE="8M" \
	PHP_DEFAULT_CHARSET="UTF-8" \
	PHP_FASTCGI_LOGGING=1 \
	PHP_FILE_UPLOADS="On" \
	PHP_UPLOAD_MAX_FILESIZE="100M" \
	PHP_ALLOW_URL_FOPEN="Off" \
	PHP_ALLOW_URL_INCLUDE="Off" \
	PHP_DEFAULT_SOCKET_TIMEOUT=60 \
	PHP_DATE_TIMEZONE="Europe/Warsaw" \
	PHP_INTL_DEFAULT_LOCALE="" \
	PHP_PDO_ODBC_CONNECTION_POOLING="strict" \
	PHP_SESSION_COOKIE_DOMAIN="" \
	PHP_SESSION_COOKIE_SAMESITE="Strict" \
	PHP_MBSTRING_LANGUAGE="" \
	PHP_OPCACHE_ENABLE=1 \
	PHP_OPCACHE_MEMORY_CONSUMPTION=128 \
	PHP_OPCACHE_INTERNED_STRING_BUFFER=8 \
	PHP_OPCACHE_MAX_ACCELERATED_FILES=10000 \
	PHP_OPCACHE_MAX_WASTED_PRECENTAGE=5 \
	PHP_OPCACHE_USE_CWD=1 \
	PHP_OPCACHE_BLACKLIST_FILENAME="" \
	PHP_OPCACHE_PRELOAD="" \
	PHP_OPCACHE_PRELOAD_USER="" \
	# FPM
	FPM_LISTEN_ADDRESS="/app/run/php-fpm.sock" \
	FPM_ALLOWED_CLIENTS="127.0.0.1" \
	FPM_CLEAR_ENV="yes" \
	FPM_PROCESS_MANAGER="static" \
	FPM_PM_MAX_CHILDREN=4 \
	FPM_PM_START_SERVERS=2 \
	FPM_PM_MIN_SPARE_SERVERS=1 \
	FPM_PM_MAX_SPARE_SERVERS=1 \
	FPM_SENDMAIL_PATH="" \
	FPM_FASTCGI_LOGGING="yes" \
	FPM_LOG_ERRORS="on" \
	FPM_LOG_LEVEL="warn" \
	FPM_LOG_LIMIT=2048 \
	FPM_EMERGENCY_RESTART_THRESHOLD= \
	FPM_LOG_BUFFERING= \
	# NGINX
	NGINX_FASTCGI_CONNECTION="unix:/app/run/php-fpm.sock" \
	NGINX_WORKER_PROCESSES="auto" \
	NGINX_WORKER_CONNECTIONS=1024 \
	NGINX_SERVER_NAME="" \
	NGINX_HTTP_SERVER_PORT=9001 \
	NGINX_MULTI_ACCEPT="off" \
	NGINX_CLIENT_MAX_BODY_SIZE="100M" \
	NGINX_SENDFILE="on" \
	NGINX_SENDFILE_MAX_CHUNK="1m" \
	NGINX_DIRECTIO="off" \
	NGINX_DIRECTIO_ALIGNMENT="4k" \
	NGINX_OUTPUT_BUFFERS="2 1m" \
	NGINX_TCP_NOPUSH="on" \
	NGINX_CHARSET="UTF-8" \
	NGINX_KEEPALIVE_TIMEOUT="20s" \
	NGINX_GZIP_VARY="on"

ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]
