## 🦆 Rubberverse container images

![Image version](https://img.shields.io/badge/Image_Version-v2024.03-purple) ![caddy version](https://img.shields.io/badge/Chyrp_Lite_Oak_v2024.03-brown) ![qor-chyrplite pulls](https://img.shields.io/docker/pulls/mrrubberducky/qor-chyrplite)

📦 **Currently supported build(s)**: `v2024.03-debian`

♻️ **Update Policy**: On new stable releases of Chyrp Lite

🛡️ **Security Policy**: Everytime there's a patched CVE that arises on the horizon. Unfixable Debian low severity CVEs are not taken into consideration!

## Version Tag information

| 🐳 Image(s) | 📁 Tag(s) | 📓 Description | 💻 Architecture |
|----------|--------|-------------|---------------|
| `docker.io/mrrubberducky/qor-chyrplite:latest-debian` | `latest-debian`, `$VERSION-alpine` | Runs as `nginx_user`, uses `debian:bookworm-slim` image as base | x86_64 |

## Extensive Image Information

- 👤 Container User: `nginx_user`, UID:GID `1001:1001`
- 🌊 Base Image: `debian/bookworm-slim:latest`
- 📦 Includes following packages: `nginx-1.22.1`, `php-8.2`, `gettext-base`, `ca-certificates`, `curl` and `tini`
- ️⚙️ Includes following PHP modules: `php8.2-gd`, `php8.2-fpm`, `php8.2-intl`, `php-8.2-curl`, `php8.2-mysql` (pdo), `php8.2-pgsql` (pdo), `php8.2-sqlite3` (pdo), `php8.2-mbstring` and `php8.2-opcache`
- 🌐 Serves following project: [xenocrat/chyrp-lite](https://github.com/xenocrat/chyrp-lite/)

Intended to be ran behind a reverse proxy that will terminate TLS. Nginx communicates with php-fpm via socket inside the container.

## 💲 Environmental Variables

⚙️ **PHP Environmental Variables**

💁 PHP variables are set to sane production values, recommended by `php.ini` configuration that ships with Debian 12. 
Changing them is not recommended unless you need it for your setup, ex. incompatible charset.

Refer to PHP documentation in order to know what these do, this is to ensure you know what you're actually changing. You can easily look up any option by just searching for ex. "php short_open_tag"

I did this on purpose as all options are worded as-is inside the `php.ini` configuration file and they can have confusing naming that means the exact opposite like ex. `ignore_user_abort`

| Env Variable                      | Default Value     |
|-----------------------------------|-------------------|
| `PHP_SHORT_OPEN_TAG`              | `"Off"`           |
| `PHP_OUTPUT_BUFFERING`            | `4096`            |
| `PHP_DISABLE_FUNCTIONS`           | `""`              |
| `PHP_DISABLE_CLASSES`             | `""`              |
| `PHP_IGNORE_USER_ABORT`           | `"Off"`           |
| `PHP_REALPATH_CACHE_SIZE`         | `"4096k"`         |
| `PHP_REALPATH_CACHE_TTL`          | `120`             |
| `PHP_ZEND_ENABLE_GC`              | `"On"`            |
| `PHP_ZEND_MULTIBYTE`              | `"Off"`           |
| `PHP_ZEND_EXCEPTION_IGNORE_ARGS`  | `"On"`            |
| `PHP_EXPOSE_PHP`                  | `"Off"`           |
| `PHP_MAX_EXECUTION_TIME`          | `0`               |
| `PHP_MAX_INPUT_TIME`              | `-1`              |
| `PHP_MEMORY_LIMIT`                | `"256M"`          |
| `PHP_IGNORE_REPEATED_ERRORS`      | `"Off"`           |
| `PHP_IGNORE_REPEATED_SOURCE`      | `"Off"`           |
| `PHP_POST_MAX_DATA_SIZE`          | `"8M"`            |
| `PHP_DEFAULT_CHARSET`             | `"UTF-8"`         |
| `PHP_FASTCGI_LOGGING`             | `1`               |
| `PHP_FILE_UPLOADS`                | `"On"`            |
| `PHP_UPLOAD_MAX_FILESIZE`         | `"100M"`          |
| `PHP_ALLOW_URL_FOPEN`             | `"Off"`           |
| `PHP_ALLOW_URL_INCLUDE`           | `"Off"`           |
| `PHP_DEFAULT_SOCKET_TIMEOUT`      | `60`              |
| `PHP_DATE_TIMEZONE`               | `"Europe/Warsaw"` |
| `PHP_INTL_DEFAULT_LOCALE`         | `""`              |
| `PHP_PDO_ODBC_CONNECTION_POOLING` | `"strict"`        |
| ⚠️ `PHP_SESSION_COOKIE_DOMAIN`   | `""`           |
| `PHP_SESSION_COOKIE_SAMESITE`     | `"Strict"`        |
| `PHP_MBSTRING_LANGUAGE`           | `""`              |

⚠️ - Not recommended to set this one to anything, let PHP handle it on it's own.

⚙️ **PHP-FPM Environmental Variables**

💁 Refer to PHP documentation in order to know what these do, this is to ensure you know what you're actually changing. You can easily look up any option by just searching for ex. "php-fpm process_manager"

| Env Variable                       | Default Value             |
|------------------------------------|---------------------------|
| `FPM_LISTEN_ADDRESS`               | `/app/run/php-fpm.sock`   |
| `FPM_ALLOWED_CLIENTS`              | `127.0.0.1`               |
| `FPM_CLEAR_ENV`                    | `"yes"`                   |
| `FPM_PROCESS_MANAGER`              | `"static"`                |
| `FPM_PM_MAX_CHILDREN`              | `4`                       |
| `FPM_PM_START_SERVERS`             | `2`                       |
| `FPM_PM_MIN_SPARE_SERVERS`         | `1`                       |
| `FPM_PM_MAX_SPARE_SERVERS`         | `1`                       |
| `FPM_SENDMAIL_PATH`                | `"/usr/bin/sendmail -t -s"` |
| `FPM_FASTCGI_LOGGING`              | `"yes"`                   |
| `FPM_LOG_ERRORS`                   | `"on"`                    |
| `FPM_LOG_LEVEL`                    | `"warn"`                  |
| `FPM_LOG_LIMIT`                    | `2048`                    |
| `FPM_EMERGENCY_RESTART_THRESHOLD`  | `""`                      |
| `FPM_LOG_BUFFERING`                | `""`                      |

⚙️ **NGINX Environmental Variables**

❗ Please keep in mind that you should not overwrite `chyrp.conf` inside the container as it will get overwritten by force via the entrypoint script!

If you want for any reason to change default NGINX configuration, then download `nginx.conf` from this repository and mount it into `/app/configs/nginx.conf.template`. `envsubst` fails silenty so container shouldn't have any issue with it adding anything extra to it.

| Env Variable                       | Default Value                  | Description                                                                   |
|------------------------------------|--------------------------------|-------------------------------------------------------------------------------|
| `NGINX_FASTCGI_CONNECTION`         | `"unix:/app/run/php-fpm.sock"` | Passed via `fastcgi_pass`, URL where Nginx can reach locally running PHP-FPM  |
| `NGINX_WORKER_PROCESSES`           | `"auto"`                       | See [nginx beginner's guide](https://nginx.org/en/docs/beginners_guide.html)  |
| `NGINX_WORKER_CONNECTIONS`         | `1024`                         | See [nginx beginner's guide](https://nginx.org/en/docs/beginners_guide.html)  |
| ⚠️ `NGINX_SERVER_NAME`                | `"<change me>"`                | You can set this to your domain or `_;`, you can read more about it [here](https://nginx.org/en/docs/http/server_names.html) |
| `NGINX_HTTP_SERVER_PORT`           | `9001`                         | Port Nginx will start the HTTP server on, change it if you need something better. Keep it above 1000 range as unprivileged users can't bind below <1000 |
| `NGINX_MULTI_ACCEPT`               | `"off"`                        | Mostly left here in case somebody wants to try it but best kept off, you can learn more [here](https://serverfault.com/a/763887) |
| `NGINX_CLIENT_MAX_BODY_SIZE`       | `"100M"`                       | This needs to match `PHP_UPLOAD_MAX_FILESIZE` otherwise you'll get 413 Content Too Large error while trying to upload large content to the server |
| `NGINX_SENDFILE`                   | `on`                           | Enables or disables the use of `sendfile()` |
| `NGINX_SENDFILE_MAX_CHUNK`         | `512k`                         | Limits the amount of data that can be transferred in a single `sendfile()` call |
| `NGINX_DIRECTIO`                   | `off`                          | Learn more [here](https://nginx.org/en/docs/http/ngx_http_core_module.html#directio) can help with serving large files |
| `NGINX_DIRECTIO_ALIGNMENT`         | `4k`                           | Should be set to 512-byte alignment unless your filesystem is XFS, then 4k is needed |
| `NGINX_OUTPUT_BUFFERS`             | `"2 1m"`                       | Just look at documentation, I've gotten lazy from copy 'n' pasting answers from there |
| `NGINX_TCP_NOPUSH`                 | `"on"`                         | Learn more [here](https://nginx.org/en/docs/http/ngx_http_core_module.html#tcp_nopush) |
| `NGINX_CHARSET`                    | `"UTF-8"`                      | Adds the specified charset to the Content-Type response header field |
| `NGINX_KEEPALIVE_TIMEOUT`          | `60s`                          | The first parameter sets a timeout during which a keep-alive client connection will stay open on the server side |
| `NGINX_GZIP_VARY`                  | `on`                           | Just look at documentation, I've gotten lazy from copy 'n' pasting answers from there |
| ⚠️ `NGINX_VALID_REFS`                 | `<change me>`                  | List of domains and sub-domains that can access `/uploads` path and display it's content. Should be the domain you're serving Chyrp Lite under! |

⚠️ - These variables should be changed to point to your domain that will host Chyrp Lite

## 💾 Data Persistence

Mount following directories, recommendation is to use bind mount with chown attribute to ensure correct permissions:

- `/app/www/chyrp/includes`

Stores your `config.json.php` and many other important files that Chyrp Lite reads. Must be mounted in order for installation to persist!

- `/app/www/chyrp/uploads`

Stores your uploaded files to the web server. Needs correct permission on all files inside, otherwise php-fpm and nginx won't be able to read anything in there.

- `/app/www/chyrp/sitemap.xml`

If you're making use of sitemap, point it to this directory and then mount it. It needs to be in root of your site, to my knowledge at least.

## 🤠 Basic Deployment

### 📦 Existing Chyrp Lite installations

1. Mount `includes/`, `uploads/` and `sitemap.xml` to your container for data persistence
2. Set `NGINX_SERVER_NAME` and `NGINX_VALID_REFS` to your domain that you will be using to serve Chyrp Lite under
3. Create a blank file `touch blank` and mount it against following files inside container via a Volume mount: `/app/www/chyrp/install.php` and `/app/www/chyrp/upgrade.php`
4. Put your container up and your site is accessible via `http://localhost:9001`

You'll need to terminate TLS via another container ex. Caddy web server.

💁 You can also mount your entire Chyrp-Lite site to `/app/www/chyrp`, this will overwrite container installation of Chyrp Lite. Recommended way of doing it is to do it via a bind mount, that way you get proper read/write and ownership between host and container.

### 🗃️ Fresh Chyrp Lite installations

1. Mount `includes/`, `uploads/` and `sitemap.xml` to your container for data persistence
2. Set `NGINX_SERVER_NAME` and `NGINX_VALID_REFS` environmental variables to your domain that you will be using to serve Chyrp Lite under

If you won't be using sqlite3 adapter, prepare a database container beforehand - MariaDB/MySQL or PostgreSQL are supported databases. It is recommended to do this initially as otherwise it can be quite painful switching away from different database formats.

If you will be using sqlite3 adapter, make sure to mount the blank database file to your host **before** continuing further with the `install.php` step as otherwise it will get lost once container restarts.

3. Navigate to `localhost:9001/install.php`
4. Complete the setup process
5. Create a blank file `touch blank` and mount it against following files inside container via a Volume mount: `/app/www/chyrp/install.php` and `/app/www/chyrp/upgrade.php`
6. Restart the container
7. Your site is accessible via `http://localhost:9001`

You'll need to terminate TLS via another container ex. Caddy web server.

## 🤠 Example Quick Deployments

- [Podman Quadlet](https://github.com/MrRubberDucky/rubberverse.xyz/tree/main/Quadlet/chyrp-lite)

The `Volume=` mount spam below Favicon xddd is optional.

- Docker Compose (WIP)
- Run command (WIP)

## ♻️ Updating

Non-lazy route:

1. Remove blank file Volume mounts that points to upgrade.php
2. Update container with `podman auto-update`
3. Visit `localhost:9001/upgrade.php`
4. Run upgrade procedure
5. Re-add the blank file Volume mount and restart the container
6. You're set

Lazy route:

1. Update Chyrp Lite manually on your host and copy your config.json.php to includes/ and your uploads/ folder back to it
2. Mount Chyrp Lite files to `/app/www/chyrp`
3. Restart container
4. Navigate to `localhost:9001/upgrade.php`
5. Remove the file from host with `podman exec -t CONT_ID rm /app/www/chyrp/upgrade.php`

Correct folder structure is `/app/www/chyrp/<root>` and not ex. `/app/www/chyrp/chyrplite-2024.03/<root>`. Verify that your mount are correct.

## 🍒 Troubleshooting

### ERR CONNECTION REFUSED on Database

This error means that it can't reach your MariaDB/MySQL or PostgreSQL database, either physically (not present on same network as container so it's unreachable) or externally (MySQL/MariaDB or PostgreSQL drops remote connection). 
Verify your PostgreSQL or MariaDB logs to be sure which problem exactly touches you, and well, fix that.

In order to fix it, you need to edit your existing configuration that was created after running `install.php`, it's located in `/app/www/chyrp/includes/config.json.php`. Hopefully you set-up data persistence otherwise this is meaningless.

1. Edit `config.json.php` and change `"host"` and `"port"` to match your current database deployment. If you're using container networking, make sure Nginx container is under same bridge network as the MariaDB container (or PostgreSQL)
2. Save it, no need to restart and refresh the page in your browser. If it can connect to your database, it will instantly display content.

```php
<?php header("Status: 403"); exit("Access denied."); ?>
{
    "sql": {
        "host": "IP",
        "port": "PORT",
        "username": "MYSQL_USERNAME",
        "password": "MYSQL_PASSWORD",
        "database": "MYSQL_DATABASE",
        "prefix": "",
        "adapter": "mysql"
    },
(...)
```

### 503 Service Temporarily Unavailable

Refrain from mounting just `config.json.php` into the `includes/` folder, Chyrp Lite hates that. Mount entire directory instead!

In rare cases you might just be getting hit with a lot of traffic, if you're not sure that above is not the problem then try increasing `FPM_PROCESS_MANAGER` environmental variables to handle more load.

### 403 Forbidden on Uploaded media

You didn't change `NGINX_VALID_REFS` environmental variable or it points to a wrong site so it just forbids it from embedding media. 

Just put your site there enclosed by "quotation marks" and it will work again ex.

```bash
Environment=NGINX_VALID_REFS="blog.rubberverse.xyz rubberverse.xyz"
```

Restart container and they will show up properly. Oh, and also make sure to clear browser cache or press shift+f5 to bypass cache.

## 🖌️ Customization

You can customize about anything you want. Just make sure anything you mount inside the container matches their UID and GID, or user.

For example let's say I want to change favicon that displays on my page and I use Umbra theme. I navigate to `themes/umbra/layouts` locally and edit `default.twig` to include following

```bash
(...)
</title>
<meta name="description" content="{{ site.description }}">
<meta name="generator" content="Chyrp Lite">
<meta name="viewport" content="initial-scale=1.0">
<link rel="icon" type="image/png" href="{{ site.chyrp_url }}/favicon-48x48.png" sizes="48x48" />
<link rel="icon" type="image/svg+xml" href="{{ site.chyrp_url }}/favicon.svg" />
<link rel="shortcut icon" href="{{ site.chyrp_url }}/favicon.ico" />
<link rel="apple-touch-icon" sizes="180x180" href="{{ site.chyrp_url }}/apple-touch-icon.png" />
<meta name="apple-mobile-web-app-title" content="Blog" />
<link rel="manifest" href="{{ site.chyrp_url }}/site.webmanifest" />
(...)
```

Now let's say I saved this modified part of the theme in `/home/user/default.twig`, I would mount it in container like so:

```bash
Volume=${HOME]/default.twig:/app/www/chyrp/themes/umbra/layouts/default.twig:rw
```

Yes, this is Podman Quadlet, I'm too used to them to provide any different examples. Anyways, now let's do the same to my favicon files. They need to be read-write for the container user otherwise it will complain. Z flags are there because I'm under SELinux.

```bash
Volume=${HOME}/default.twig:/app/www/chyrp/themes/umbra/layouts/default.twig:rw,Z
Volume=${HOME}/favicon.svg:/app/www/chyrp/favicon.svg:rw,Z
Volume=${HOME}/favicon.ico:/app/www/chyrp/favicon.ico:rw,Z
Volume=${HOME}/favicon-48x48.png:/app/www/chyrp/favicon-48x48.png:rw,Z
Volume=${HOME}/apple-touch-icon.png:/app/www/chyrp/apple-touch-icon.png:rw,Z
Volume=${HOME}/web-app-manifest-192x192.png:/app/www/chyrp/web-app-manifest-192x192.png:rw,Z
Volume=${HOME}/web-app-manifest-512x512.png:/app/www/chyrp/web-app-manifest-512x512.png:rw,Z
Volume=${HOME}/site.webmanifest:/app/www/chyrp/site.webmanifest:rw,Z
```

Reload systemd daemon `systemctl --user daemon-reload` and restart your container afterwards. As shrimple as that! 🦐

## Default configuration parameters

**For PHP 8.2** - `/app/configs/fpm/php.ini`

| Setting                    | Current Value                       |
|----------------------------|-------------------------------------|
| `error_reporting`          | `E_ALL & ~E_DEPRECATED & ~E_STRICT` |
| `display_errors`           | `Off`                               |
| `display_startup_errors`   | `Off`                               |
| `log_errors`               | `On`                                |
| `report_memleaks`          | `On`                                |
| `html_errors`              | `Off`                               |
| `error_log`                | `/app/logs/fpm/php-error.log`       |
| `variables_order`          | `"EGPCS"`                           |
| `register_argc_argv`       | `Off`                               |
| `cgi.force_redirect`       | `1`                                 |
| `doc_root`                 | `${DIRECTORY_PATH}`                 |
| `upload_tmp_dir`           | `/app/temp`                         |
| `sqlite3.defensive`        | `1`                                 |
| `session.save_handler`     | `files`                             |
| `session.save_path`        | `/app/temp/session`                 |
| `session.use_strict_mode`  | `1`                                 |
| `session.use_cookies`      | `1`                                 |
| `session.cookie_secure`    | `1`                                 |
| `session.use_only_cookies` | `1`                                 |

**For PHP8.2-FPM** - `/app/configs/fpm/php-fpm.ini`

| Setting                    | Current Value                       |
|----------------------------|-------------------------------------|
| `error_log`                | `/app/logs/fpm/fpm-error.log`       |
| `daemonize`                | `yes`                               |
| `systemd_interval`         | `0`                                 |
| `include`                  | `/app/configs/fpm/pool.d/*.conf`    |

**For PHP8.2-FPM** - `/app/configs/fpm/pool.d/www.conf`

| Setting                      | Current Value                       |
|------------------------------|-------------------------------------|
| `user`                       | `nginx_user`                        |
| `group`                      | `nginx_user`                        |
| `listen.owner`               | `nginx_user`                        |
| `listen.group`               | `nginx_user`                        |
| `access.log`                 | `/app/logs/fpm/fpm-access.log`      |
| `slowlog`                    | `/app/logs/fpm/fpm-slow.log`        |
| `catch_workers_output`       | `yes`                               |
| `decorate_workers_output`    | `no`                                |
| `clear_env`                  | `yes`                               |
| `php_admin_value[error_log]` | `/app/logs/fpm/fpm-error.log`       |

## 🛠️ Build guide

1. Git clone this repository
2. Navigate to chyrp-lite
3. Copy following files from configs: `fpm.conf`, `www.conf`, `nginx.conf` to chyrp-lite
4. Copy `remove-junk.sh` from scripts to chyrp-lite
5. Run `podman build -f nginx-fpm.Dockerfile -t localhost/chyrplite:latest`
6. Look into the Dockerfile to see environmental variables, you definitely want to customize the `NGINX_` ones to your liking
7. Modify COPY statements in Dockerfile to point to root of the directory where the files are stored (so just remove scripts/ off the COPY statements ex. `COPY scripts/docker-entrypoint.sh` to `COPY docker-entrypoint.sh` instead)
8. Deploy it and navigate to `http://localhost:9001`
