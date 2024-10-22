# Inspirations: 
# https://github.com/Endava/docker-php/blob/release/8.3/Dockerfile
# https://github.com/nginxinc/docker-nginx-unprivileged/blob/main/Dockerfile-debian.template
# I suppose it became it's own thing now, huh?

ARG IMAGE_REPOSITORY=docker.io/library
ARG IMAGE_NODE_VERSION=18-bookworm-slim

FROM $IMAGE_REPOSITORY/node:$IMAGE_NODE_VERSION AS debian-base

ARG DEB="php8.2" \
    PHP_VERSION="8.2" \
    CHYRP_VERSION="2024.03" \
    COMPOSER_VERSION="2.8.1" \
    CONT_USER=www-data \
    CONT_UID=1001

ENV DEB=$DEB \
    PHP_VERSION=$PHP_VERSION \
    CHYRP_VERSION=$CHYRP_VERSION \
    CONT_USER=$CONT_USER \
    CONT_UID=$CONT_UID \
    DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN apt update \
    && apt install --no-install-recommends -y \
        git \
        sed \
        curl \
        adduser \
        sendmail \
        gettext-base \
        ca-certificates \
    && deluser \
        ${CONT_USER} \
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
        curl \
        tini \
        nginx \
        unzip \
        ${DEB}-gd \
        ${DEB}-fpm \
        ${DEB}-intl \
        ${DEB}-curl \
        ${DEB}-mysql \
        ${DEB}-pgsql \
        ${DEB}-mcrypt \
        ${DEB}-opcache \
        ${DEB}-imagick \
        ${DEB}-mbstring \
    && mkdir -p \
        /app/run \
        /app/scripts \
        /app/logs/fpm \
        /app/logs/nginx \
        /app/configs/fpm \
        /app/php-fpm/session \
        # Hardcoded: https://salsa.debian.org/nginx-team/nginx/-/blob/debian/1.26.0-2/debian/rules#L32
        /var/lib/nginx \
    && touch \
        /app/logs/fpm/php-error.log \
        /app/logs/fpm/fpm-error.log \
        /app/logs/fpm/fpm-access.log \
    && mv /etc/nginx /app/configs/nginx \
    && rm \
        /app/configs/nginx/sites-available/default \
        /app/configs/nginx/sites-enabled/default \
        /app/configs/nginx/nginx.conf \
    && rm -rf \
        /app/configs/nginx/snippets \
    && touch /app/configs/nginx/sites-enabled/chyrp.conf \
    # Don't need no manuals, we in docker bitch1111
    && rm -rf /usr/share/man

COPY php.ini /app/configs/fpm/php.ini
COPY fpm.conf /app/configs/fpm/php-fpm.conf
COPY www.conf /app/configs/fpm/pool.d/www.conf
COPY nginx.conf /app/configs/nginx.conf.template
COPY chyrp.conf /app/configs/chyrp.conf.template

RUN curl -Lo /app/chyrplite.zip https://github.com/xenocrat/chyrp-lite/archive/refs/tags/v${CHYRP_VERSION}.zip \
    && unzip -d /app /app/chyrplite.zip \
    # God I hate this nonsense
    && mv /app/chyrp-lite-${CHYRP_VERSION} /app/chyrp \
    # Like why doesn't it just work the same as in bash?
    # Doing same mv command above suddenly screws up every single directory
    && mv /app/chyrp /var/www \
    && chown -R $CONT_USER:$CONT_USER \
        /app \
        /var/www \
        /var/lib/nginx \
    && ls -l /var/www/chyrp \
    && rm -rf \
        /var/www/chyrp/.github \
        /var/www/chyrp/uploads \
        /var/www/chyrp/licenses \
        /var/www/html \
    && rm \
        /var/www/chyrp/.gitignore \
        /var/www/chyrp/.dockerignore \
        /var/www/chyrp/upgrade.php \
        /var/www/chyrp/install.php \
        /var/www/chyrp/Dockerfile \
        /var/www/chyrp/*.md \
        /app/chyrplite.zip \
    && apt remove --auto-remove -y \
        unzip \
    && rm -rf /var/lib/apt/lists/*

COPY --chmod=755 docker-entrypoint.sh /app/scripts/docker-entrypoint.sh

USER $CONT_USER

ENV TINI_SUBREAPER=1 \
    DATE_TIMEZONE="Europe/Warsaw" \
    ALLOW_URL_FOPEN="On" \
    LOG_ERRORS_MAX_LEN=2048 \
    LOG_ERRORS="1" \
    MAX_EXECUTION_TIME=0 \
    MAX_FILE_UPLOADS=20 \
    MAX_INPUT_VARS=1000 \
    MEMORY_LIMIT=128M \
    VARIABLES_ORDER="EGPCS" \
    SHORT_OPEN_TAG="On" \
    OPCACHE_PRELOAD="" \
    OPCACHE_PRELOAD_USER="" \
    OPCACHE_MEMORY_CONSUMPTION=128 \
    OPCACHE_MAX_ACCELERATED_FILES=10000 \
    OPCACHE_VALIDATE_TIMESTAMPS=1 \
    REALPATH_CACHE_SIZE=4M \
    REALPATH_CACHE_TTL=120 \
    POST_MAX_SIZE=16M \
    SENDMAIL_PATH="/usr/sbin/sendmail -t -i -f ${EMAIL_DOMAIN}" \
    SESSION_SAVE_HANDLER=files \
    SESSION_SAVE_PATH="/app/php-fpm/session" \
    UPLOAD_MAX_FILESIZE=100M \
    DISPLAY_ERRORS='STDOUT' \
    DISPLAY_STARTUP_ERRORS=1 \
    EXPOSE_PHP=1 \
    SERVER_PORT=9001 \
    CHYRP_SERVER_NAME="blog.rubberverse.xyz www.rubberverse.xyz rubberverse.xyz" \
    FASTCGI_CONNECTION="unix:/app/run/php-fpm.sock" \
    MULTI_ACCEPT="on" \
    WORKER_CONNECTIONS=2048 \
    WORKER_PROCESSES="auto" \
    VALID_REFS="blog.rubberverse.xyz www.rubberverse.xyz rubberverse.xyz cdn.discordapp.com discord.com" \
    LISTEN_ADDRESS="/app/run/php-fpm.sock" \
    ALLOWED_CLIENTS="127.0.0.1" \
    CLEAR_ENV="no" \
    FASTCGI_LOGGING="yes" \
    LOG_BUFFERING="no" \
    LOG_LIMIT=2048 \
    LOG_LEVEL="warn" \
    LOG_ERRORS="on" \
    PM_DAEMON_VALUE="ondemand" \
    PM_MAX_CHILDREN=16 \
    PM_PROCESS_IDLE_TIMEOUT="3s"

ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]