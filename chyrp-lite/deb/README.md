## General Information

`nginx-fpm.Dockerfile` uses `debian/bookworm-slim:latest` as base image.

Purges essential system tools and runs as rootless user named `nginx_user` with UID and GID of `1001` respectively.

PHP-FPM and NGINX both run as same rootless user and make use of `tini` to reap zombie sub-processes.

Requires prior bare-metal installation of Chyrp Lite to be mounted in `/app/www/chyrp` and a working database installation either containerized or not.

## Package(s)

Spins up an image with following configuration for Chyrp Lite:

- 📦 tini
- 📦 curl
- 📦 gettext-base (For `envsubst`)
- 📦 ca-certificates (For proper `curl` operation)
- 📦 Nginx (Clean URLs, HTTP traffic - Terminate TLS via Caddy instead)
- 📦 PHP8.2-FPM (via unix socket)
- ⚙️ gd
- ⚙️ curl
- ⚙️ intl
- ⚙️ mcrypt
- ⚙️ mbstring
- ⚙️ pdo_mysql
- ⚙️ pdo_pgsql
- ⚙️ pdo_sqlite3

**Legend**

- 📦: `.deb` or `.apk` Package
- ⚙️: PHP Module
