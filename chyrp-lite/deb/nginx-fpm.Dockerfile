# Inspirations: 
# https://github.com/Endava/docker-php/blob/release/8.3/Dockerfile
# https://github.com/nginxinc/docker-nginx-unprivileged/blob/main/Dockerfile-debian.template
# I suppose it became it's own thing now, huh?

ARG IMAGE_REPOSITORY=docker.io/library
ARG IMAGE_VERSION=bookworm-slim

FROM $IMAGE_REPOSITORY/debian:$IMAGE_VERSION AS debian-base

ARG GIT_BRANCH
ARG GIT_REPOSITORY

ARG DEB="php8.2" \
	PHP_VERSION="8.2" \
	CONT_USER=nginx_user \
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
		${DEB} \
		${DEB}-gd \
		${DEB}-fpm \
		${DEB}-intl \
		${DEB}-curl \
		${DEB}-mysql \
		${DEB}-pgsql \
		${DEB}-mcrypt \
		${DEB}-mbstring \
		mariadb-client \
		postgresql-client \
	&& mkdir -p \
		/app/run \
		/app/www \
		/app/scripts \
		/app/logs/fpm \
		/app/logs/nginx \
		/app/configs/fpm \
		/app/php-fpm/session \
	# Hardcoded: https://salsa.debian.org/nginx-team/nginx/-/blob/debian/1.26.0-2/debian/rules#L32
		/var/lib/nginx \
		/app/chyrp \
	&& mv /etc/nginx /app/configs/nginx \
	&& touch \
		/app/logs/fpm/php-error.log \
		/app/logs/fpm/fpm-error.log \
		/app/logs/fpm/fpm-access.log \
		/app/configs/nginx/sites-enabled/chyrp.conf \
	# Frees up around 300MB
	&& rm \
		/app/configs/nginx/sites-available/default \
		/app/configs/nginx/sites-enabled/default \
		/app/configs/nginx/nginx.conf \
		/usr/bin/base64 \
		/usr/bin/base32 \
		/usr/bin/git-receive-pack \
		/usr/bin/git-upload-archive \
		/usr/bin/git-upload-pack \
		/usr/bin/shred \
		/usr/bin/systemd \
		/usr/bin/tabs \
		/usr/bin/toe \
		/usr/bin/top \
		/usr/bin/passwd \
		/usr/bin/pager \
		/usr/bin/prove \
		/usr/bin/pstree.x11 \
		/usr/bin/rdma \
		/usr/bin/which.debianutils \
		/usr/bin/which \
		/usr/bin/zipdetails \
		/usr/bin/zmore \
		/usr/bin/znew \
		/usr/bin/more \
		/usr/bin/mkfifo \
		/usr/bin/findmnt \
		/usr/bin/fgrep \
		/usr/bin/dircolors \
		/usr/bin/deb-systemd-helper \
		/usr/bin/deb-systemd-invoke \
		/usr/bin/busctl \
		/usr/bin/bashbug \
		/usr/bin/mv \
		/usr/bin/uncompress \
		/usr/bin/unexpand \
		/usr/bin/unlink \
		/usr/bin/update-alternatives \
		/usr/bin/tar \
		/usr/bin/taskset \
		/usr/bin/tee \
		/usr/bin/timedatectl \
		/usr/bin/systemd-mount \
		/usr/bin/systemd-tty-ask-password-agent \
		/usr/bin/systemd-tmpfiles \
		/usr/bin/systemd-sysusers \
		/usr/bin/systemd-sysext \
		/usr/bin/systemd-stdio-bridge \
		/usr/bin/systemd-run \
		/usr/bin/systemd-repart \
		/usr/bin/systemd-path \
		/usr/bin/systemd-notify \
		/usr/bin/systemd-machine-id-setup \
		/usr/bin/systemd-inhibit \
		/usr/bin/systemd-id128 \
		/usr/bin/systemd-firstboot \
		/usr/bin/systemd-escape \
		/usr/bin/systemd-detect-virt \
		/usr/bin/systemd-delta \
		/usr/bin/systemd-cryptenroll \
		/usr/bin/systemd-creds \
		/usr/bin/systemd-cgtop \
		/usr/bin/systemd-cgls \
		/usr/bin/systemd-cat \
		/usr/bin/systemd-ask-password \
		/usr/bin/systemd-analyze \
		/usr/bin/systemctl \
		/usr/bin/sum \
		/usr/bin/su \
		/usr/bin/stty \
		/usr/bin/streamzip \
		/usr/bin/ss \
		/usr/bin/splain \
		/usr/bin/sort \
		/usr/bin/shasum \
		/usr/bin/sha512sum \
		/usr/bin/sha384sum \
		/usr/bin/sha256sum \
		/usr/bin/sha224sum \
		/usr/bin/sha1sum \
		/usr/bin/setterm \
		/usr/bin/setpriv \
		/usr/bin/sensible-editor \
		/usr/bin/sensible-pager \
		/usr/bin/sensible-browser \
		/usr/bin/scriptreplay \
		/usr/bin/scriptlive \
		/usr/bin/script \
		/usr/bin/realpath \
		/usr/bin/bash \
		/usr/bin/pod2html \
		/usr/bin/pod2text \
		/usr/bin/pod2usage \
		/usr/bin/podchecker \
		/usr/bin/perl* \
		/usr/bin/newgrp \
		/usr/bin/networkctl \
		/usr/bin/mawk \
		/usr/bin/loginctl \
		/usr/bin/localedef \
		/usr/bin/localectl \
		/usr/bin/locale \
		/usr/bin/kernel-install \
		/usr/bin/journalctl \
		/usr/bin/hostnamectl \
		/usr/bin/gpasswd \
		/usr/bin/git \
		/usr/bin/git-shell \
		/usr/bin/find \
		/usr/bin/dpkg \
		/usr/bin/dpkg-* \
		/usr/bin/debconf \
		/usr/bin/debconf-* \
		/usr/bin/apt \
		/usr/bin/apt-* \
		/usr/sbin/chpasswd \
		/usr/sbin/chcpu \
		/usr/sbin/blockdev \
		/usr/sbin/blkid \
		/usr/sbin/blkdiscard \
		/usr/sbin/blkdeactivate \
		/usr/sbin/ctrlaltdel \
		/usr/sbin/cppw \
		/usr/sbin/debugfs \
		/usr/sbin/devlink \
		/usr/sbin/dmsetup \
		/usr/sbin/dpkg-fsys-usrunmess \
		/usr/sbin/dpkg-preconfigure \
		/usr/sbin/dumpe2fs \
		/usr/sbin/e4crypt \
		/usr/sbin/e4defrag \
		/usr/sbin/findfs \
		/usr/sbin/filefrag \
		/usr/sbin/e2* \
		/usr/sbin/delgroup \
		/usr/sbin/groupmod \
		/usr/sbin/dpkg-reconfigure \
		/usr/sbin/blkzone \
		/usr/sbin/capsh \
		/usr/sbin/pwhistory_helper \
		/usr/sbin/addgroup \
		/usr/sbin/adduser \
		/usr/sbin/deluser \
		/usr/sbin/badblocks \
		/usr/sbin/agetty \
		/usr/sbin/add-shell \
		/usr/sbin/fsck* \
		/usr/sbin/dcb \
		/usr/sbin/remove-shell \
		/usr/sbin/newusers \
		/usr/sbin/swaplabel \
		/usr/sbin/service \
		/usr/sbin/usermod \
		/usr/sbin/installkernel \
		/usr/sbin/isosize \
		/usr/sbin/ldattach \
		/usr/sbin/ldconfig \
		/usr/sbin/mke2fs \
		/usr/sbin/mkfs* \
		/usr/sbin/sulogin \
		/usr/sbin/switch_root \
		/usr/sbin/runuser \
		/usr/sbin/mkhomedir_helper \
		/usr/sbin/mklost+found \
		/usr/sbin/mkswap \	
		/usr/sbin/pam-auth-update \
		/usr/sbin/pam_getenv \
		/usr/sbin/pam_namespace_helper \
		/usr/sbin/pam_timestamp_check \
		/usr/sbin/pwck \
		/usr/sbin/pwconv \
		/usr/sbin/pwunconv \
		/usr/sbin/resize2fs \
		/usr/sbin/setcap \
		/usr/sbin/swapon \
		/usr/sbin/swapoff \
		/usr/sbin/sysctl \
		/usr/sbin/tune2fs \
		/usr/sbin/userdel \
		/usr/sbin/useradd \
		/usr/sbin/groupadd \
		/usr/sbin/groupdel \
		/usr/sbin/zramctl \
		/usr/sbin/wipefs \
	&& rm -rf \
		/usr/lib/apt \
		/usr/lib/binfmt.d \
		/usr/lib/dpkg \
		/usr/lib/environment.d \
		/usr/lib/git-core \
		/usr/lib/systemd \
		/usr/lib/tmpfiles.d \
		/usr/share/bash-completion \
		/usr/share/X11 \
		/usr/share/git-core \
		/usr/share/git-web \
		/usr/share/initramfs-tools \
		/usr/share/java \
		/usr/share/pam \
		/usr/share/perl \
		/usr/share/perl5 \
		/usr/share/vim \
		/var/lib/systemd \
		/app/configs/nginx/snippets \
		/var/lib/apt

COPY php.ini /app/configs/fpm/php.ini
COPY fpm.conf /app/configs/fpm/php-fpm.conf
COPY www.conf /app/configs/fpm/pool.d/www.conf
COPY nginx.conf /app/configs/nginx.conf.template
COPY chyrp.conf /app/configs/chyrp.conf.template

RUN chown -Rf $CONT_USER:$CONT_USER \
	/app \
	/var/lib/nginx

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
	REALPATH_CACHE_SIZE=4M \
	REALPATH_CACHE_TTL=120 \
	POST_MAX_SIZE=16M \
	SESSION_SAVE_HANDLER=files \
	SESSION_SAVE_PATH="/app/php-fpm/session" \
	UPLOAD_MAX_FILESIZE=100M \
	DISPLAY_ERRORS='STDOUT' \
	DISPLAY_STARTUP_ERRORS=1 \
	EXPOSE_PHP=0 \
	SERVER_PORT=9001 \
	CHYRP_SERVER_NAME="CHANGE ME" \
	FASTCGI_CONNECTION="unix:/app/run/php-fpm.sock" \
	MULTI_ACCEPT="off" \
	WORKER_CONNECTIONS=1024 \
	WORKER_PROCESSES=4 \
	VALID_REFS="CHANGE ME" \
	LISTEN_ADDRESS="/app/run/php-fpm.sock" \
	ALLOWED_CLIENTS="127.0.0.1" \
	CLEAR_ENV="no" \
	FASTCGI_LOGGING="yes" \
	LOG_BUFFERING="no" \
	LOG_LIMIT=2048 \
	LOG_LEVEL="warn" \
	LOG_ERRORS_FPM="on" \
	PROCESS_MANAGER="static" \
	PM_MAX_CHILDREN=32 \
	PM_START_SERVERS=4 \
	PM_MIN_SPARE_SERVERS=2 \
	PM_MAX_SPARE_SERVERS=8 \
	GZIP_VARY="on" \
	KEEPALIVE_TIMEOUT="20s" \
	CHARSET="utf-8" \
	TCP_NOPUSH="on" \
	SENDFILE="on" \
	CLIENT_MAX_BODY_SIZE="100M" \
	INSTALLED=true \
	BYPASS_CHECKS=0

ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]
