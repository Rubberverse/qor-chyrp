## FreshRSS

Nginx, PHP-FPM, FreshRSS and supercronic all in one package.

- 👤 Container User: `nginx_user`, UID:GID `1001:1001`
- 🌊 Base Image: `debian/bookworm-slim:latest`
- 📦 With following packages: `curl`, `envsubst`, `ca-certificates`, `tini`, `nginx`, `php8.2` and `supercronic`

💁 Supercronic was used because normal cron requires root permissions in order to run

Intended to be ran behind a reverse proxy providing TLS.

## ⚙️ PHP Modules

Includes following bare minimum to run FreshRSS: `php-fpm`, `php-gd`, `php-zip`, `php-gmp`, `php-xml`, `php-exif`, `php-intl`, `php-curl`, `php-iconv`, `php-pdo_mysql`, `php-pdo_pgsql`, `php-pdo_sqlite3` and `php-mbstring`

## 🛠️ Build guide

1. Git clone this repository
2. Navigate to freshrss
3. Copy following files from configs: `fpm.conf`, `www.conf`, `nginx.conf` to freshrss
4. Copy `remove-junk.sh` from scritps to freshrss
5. Run `podman build -f nginx-fpm.Dockerfile -t localhost/freshrss:latest`
6. Look into the Dockerfile to see environmental variables, you definitely want to customize the `NGINX_` ones to your liking
7. Deploy it and navigate to `http://localhost:9001`
