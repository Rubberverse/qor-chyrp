## 🦆 Rubberverse container images

![Image version](https://img.shields.io/badge/Image_Version-v2024.03-purple) ![freshrss version](https://img.shields.io/badge/FreshRSS-1.24.3-brown) ![freshrss pulls](https://img.shields.io/docker/pulls/mrrubberducky/qor-freshrss)

📦 **Currently supported build(s)**: `1.24.3-debian`, `latest-debian`

♻️ **Update Policy**: On new stable releases of FreshRSS

🛡️ **Security Policy**: Everytime there's a patched CVE that arises on the horizon. Unfixable Debian low severity CVEs are not taken into consideration!

## Version Tag information

| 🐳 Image(s) | 📁 Tag(s) | 📓 Description | 💻 Architecture |
|----------|--------|-------------|---------------|
| `docker.io/mrrubberducky/qor-freshrss:latest-debian` | `latest-debian`, `$VERSION-debian` | Runs as `nginx_user`, uses `debian:bookworm-slim` image as base | x86_64 |

## Extensive Image Information

- 👤 Container User: `nginx_user`, UID:GID `1001:1001`
- 🌊 Base Image: `debian/bookworm-slim:latest`
- 📦 Includes following packages: `nginx-1.22.1`, `php-8.2`, `gettext-base`, `ca-certificates`, `curl`, `aptible/supercronic` and `tini`
- ️⚙️ Includes following PHP modules: `php8.2-gd`, `php8.2-zip`, `php8.2-gmp`, `php8.2-xml`, `php8.2-fpm`, `php8.2-exif`, `php8.2-intl`, `php8.2-curl`, `php8.2-iconv`, `php8.2-mysql` (pdo), `php8.2-pgsql` (pdo), `php8.2-sqlite3` (pdo), `php8.2-opcache` and `php8.2-mbstring`
- 🌐 Serves following project: [FreshRSS/FreshRSS](https://github.com/FreshRSS/FreshRSS)

Intended to be ran behind a reverse proxy that will terminate TLS. Nginx communicates with php-fpm via socket inside the container.

## 💲 Environmental Variables

⚙️ **PHP Environmental Variables**

💁 PHP variables are set to sane production values, recommended by `php.ini` configuration that ships with Debian 12. 
Changing them is not recommended unless you need it for your setup, ex. incompatible charset, to set correct timezone.

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
| ⚠️ `PHP_SESSION_COOKIE_DOMAIN`    | `""`              |
| `PHP_SESSION_COOKIE_SAMESITE`     | `"Strict"`        |
| `PHP_MBSTRING_LANGUAGE`           | `""`              |
| `PHP_OPCACHE_ENABLE`              | `1`               |
| `PHP_OPCACHE_MEMORY_CONSUMPTION`  | `128`             |
| `PHP_OPCACHE_INTERNED_STRING_BUFFER` | `8`            |
| `PHP_OPCACHE_MAX_ACCELERATED_FILES`  | `10000`        |
| `PHP_OPCACHE_MAX_WASTED_PERCENTAGE`  | `5`            |
| `PHP_OPCACHE_USE_CWD`             | `1`               |
| `PHP_OPCACHE_BLACKLIST_FILENAME`  | `""`              |
| `PHP_OPCACHE_PRELOAD`             | `""`              |
| `PHP_OPCACHE_PRELOAD_USER`        | `""`              |
| `PDO_MYSQL_CACHE_SIZE`            | `""`              |
| `ICONV_INPUT_ENCODING`            | `""`              |
| `ICONV_INTERNAL_ENCODING`         | `""`              |
| `ICONV_OUTPUT_ENCODING`           | `""`              |

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
| `NGINX_SERVER_NAME`                | `"<change me>"`                | You can set this to your domain or `_;`, you can read more about it [here](https://nginx.org/en/docs/http/server_names.html) |
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

## 💾 Data Persistence

Mount following directories, recommendation is to use bind mount with chown attribute to ensure correct permissions:

- `/app/www/freshrss/data`

Stores FreshRSS configuration files and user data

- `/app/www/freshrss/extensions`

Allows you to install custom extensions by putting them in this folder

## 🤠 Basic Deployment

### 📦 Existing FreshRSS installations (migration to container)

1. Mount existing `data/` and `extensions/` from your host (or NFS etc.) to your container
2. Set `NGINX_SERVER_NAME` environmental variable
3. Modify your `config.php` to point to your new database deployment, or keep it as is. Just make sure your container can reach it.
4. Put your container up
5. Your site is ready to be served under `localhost:9001`

### 🗃️ Fresh, as in new, FreshRSS installations

1. Mount `data/` and `extensions/` from your container to your host (or NFS etc.)
2. Set `NGINX_SERVER_NAME` environmental variable
3. Put your container up and navigate to `localhost:9001` to finish the setup process

## ♻️ Updating

Just run `podman auto-update` or update the image manually and that's it. No need to do anything else.

## 🍒 Troubleshooting

### Database Error

This error means that it can't reach your MariaDB/MySQL or PostgreSQL database, either physically (not present on same network as container so it's unreachable) or externally (MySQL/MariaDB or PostgreSQL drops remote connection). 
Verify your PostgreSQL or MariaDB logs to be sure which problem exactly touches you, and well, fix that.

In some cases it also could mean that the database is corrupt, it will however tell you if that's the case. The exact error message will be displayed on your main FreshRSS instance.

1. Navigate to `data/` and edit `config.php`
2. Scroll down till you see an array that starts with `db``
3. Edit your connection type, put in correct ip:port, user, pass, remotedb and prefix (if you used one)
4. Save and exit, then refresh the page. If it works, your FreshRSS instance will spring back to life.

```bash
  array (
  ),
  'db' =>
  array (
    'type' => 'pgsql',
    'host' => 'ip:port',
    'user' => 'user',
    'password' => 'pass',
    'base' => 'remotedb',
    'prefix' => '',
    'connection_uri_params' => '',
    'pdo_options' =>
```

### 403 Forbidden / Permission Denied on any page

Permissions are wrong on `/app/www/freshrss` folder, or you have incomplete set of files. In case container fails to copy over current files to your bind mount from ex. `data/`, you will need to recreate them manually.

Correct directory structure for `data/` can be found [here](https://github.com/FreshRSS/FreshRSS/tree/edge/data)

This error happens due to it being unable to store user-data and many other things in it's own folder because the directories are missing. Once you add them, your FreshRSS instance is accessible again.

### 404 Not Found

You probably modified nginx.conf or freshrss.conf which now points to the wrong root directory for FreshRSS. Make sure it's `/app/www/freshrss/p` and not `/app/www/freshrss` or any other directory.

## 🖌️ Customization

If you know what to modify, it's possible to do and relatively easy. Just make sure permission on your files matches what FreshRSS needs (UID and GID of 1001)

You can also do anything from FreshRSS anyways, from custom CSS to various extensions, as long as you mount the extensions folder.

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
