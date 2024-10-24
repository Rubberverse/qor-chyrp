# Build Time

| Environmental Variable | Default Value | General Description |
|------------------------|-------------------------|---------------------|
| `IMAGE_REPOSITORY` | `docker.io/library` | Points to registry to pull the base Debian image from. |
| `IMAGE_VERSION` | `18-bookworm-slim` | Pulls certain version of the Debian image. |
| `DEB` | `php8.2` | Name of the PHP package that's preset on Debian repository. |
| `CHYRP_VERSION` | `2024.03` | Chyrp Lite version to pull from creator's GitHub releases. |
| `CONT_USER` | `nginx_user` | Rootless user the container will run as. |
| `CONT_UID` | `1001` | UID of the rootless user the container will run as. |

# Container init

| Environmental Variable | Default Value | General Description |
|------------------------|---------------|---------------------|
| `TINI_SUBREAPER`       | `1`           | [https://github.com/krallin/tini?tab=readme-ov-file#subreaping](https://github.com/krallin/tini?tab=readme-ov-file#subreaping) |

Refrain from changing this one, it's there to be helpful.

# php-fpm

These can be referenced in your `docker-compose.yaml`, `podman run --environment` and `Quadlet` deployments.

| Environmental Variable | Default Value | General Description |
|------------------------|-------------------------|---------------------|
| `LISTEN_ADDRESS`    | `/app/run/php-fpm.sock` | Address php-fpm will listen on. Can be IP:PORT, Socket, Port |
| `CLEAR_ENV`         | `no` | Look at php-fpm documentation. |
| `ALLOWED_CLIENTS`   | `127.0.0.1` | Look at php-fpm documentation. |
| `LOG_ERRORS_FPM` | `on` | php-fpm will log errors it encounters to `/app/logs/fpm/fpm-error.log` |
| `LOG_LEVEL` | `warn` | Look at php-fpm documentation. |
| `LOG_BUFFERING` | `no` | Look at php-fpm documentation. |
| `FASTCGI_LOGGING` | `yes` | Logs failed(?) fastcgi requests. |
| `VARIABLES_ORDER` | `EGCS` | Do not change this one, otherwise environmental variable order will get screwed up and they won't work anymore. |
| `PROCESS_MANAGER` | `static` | - | 
| `PM_MAX_CHILDREN` | `32` | - |
| `PM_START_SERVERS` | `4` | - |
| `PM_MIN_SPARE_SERVERS` | `2` | - |
| `PM_MAX_SPARE_SERVERS` | `8` | - |


php-fpm documentation: [https://www.php.net/manual/en/install.fpm.configuration.php](https://www.php.net/manual/en/install.fpm.configuration.php)

# php

I'm too lazy to document these, just search the variable name + php.ini and you will get the exact option.

| Environmental Variable | Default Value | General Description |
|------------------------|-------------------------|---------------------|
| `DATE_TIMEZONE` | `Europe/Warsaw` | - |
| `ALLOW_URL_FOPEN` | `Off` | - |
| `LOG_ERRORS_MAX_LEN` | `2048` | - |
| `LOG_ERRORS` | `1` | - |
| `MAX_EXECUTION_TIME` | `0` | - |
| `MAX_FILE_UPLOADS` | `20` | - |
| `MAX_INPUT_VARS` | `1000` | - |
| `MEMORY_LIMIT` | `128M` | - |
| `SHORT_OPEN_TAG` | `"On"` | - |
| `OPCACHE_PRELOAD` | `""` | - |
| `OPCACHE_PRELOAD_USER` | `""` | - |
| `OPCACHE_MEMORY_CONSUMPTION` | `128` | - |
| `OPCACHE_MAX_ACCELERATED_FILES` | `10000` | - |
| `OPCACHE_VALIDATE_TIMESTAMPS` | `1`| - |
| `REALPATH_CACHE_SIZE` | `4M` | - |
| `REALPATH_CACHE_TTL` | `120` | - |
| `POST_MAX_SIZE` | `16M` | - |
| `SENDMAIL_PATH` `/usr/sbin/sendmail -t -i -f ${EMAIL_DOMAIN}` | Not installed by default. |
| `SESSION_SAVE_HANDLER` | `files` | - |
| `SESSION_SAVE_PATH` | `/app/php-fpm/session` | - |
| `UPLOAD_MAX_FILESIZE` | `100M` | - |
| `DISPLAY_ERRORS` | `STDOUT` | - |
| `DISPLAY_STARTUP_ERRORS` | `1` | - |
| `EXPOSE_PHP` | `0` | Just dumb little header that lets everyone know you run xyz version of php that's added to requests and error pages. |

# nginx

| Environmental Variable | Default Value | General Description |
|------------------------|-------------------------|---------------------|
| `SERVER_PORT` | `9001` | What port should NGINX server expose your Chyrp Lite instance? |
| `CHYRP_SERVER_NAME` | `blog.rubberverse.xyz www.rubberverse.xyz rubberverse.xyz` | `server_name` directive on Nginx. |
| `FASTCGI_CONNECTION` | `unix:/app/run/php-fpm.sock` | `fastcgi_pass` directive, `address:port` or `unix socket` where php-fpm is listening on. |
| `MULTI_ACCEPT` | `off` | "A worker process accepts one new connection at a time (the default). If enabled, a worker process accepts all new connections at once. We recommend keeping the default value (off)" - [blog.nginx.org](https://blog.nginx.org/blog/performance-tuning-tips-tricks) |
| `WORKER_CONNECTIONS` | `1024` | [nginx.org docs](https://nginx.org/en/docs/ngx_core_module.html#worker_connections) |
| `WORKER_PROCESSES` | `4` | Change this to max amount of cores your CPU has, or less. |
| `VALID_REFS` | `blog.rubberverse.xyz www.rubberverse.xyz rubberverse.xyz cdn.discordapp.com discord.com` | Affects `/uploads/`. Controls who can embed your uploaded media. By choice `chyrp-lite` will return `403` for `/data` and `/includes/`. |
| `GZIP_VARY` | `on` | `gzip_vary` Nginx directive. |
| `SENDFILE` | `on` | - |
| `TCP_NOPUSH` | `on` | - |
| `CLIENT_MAX_BODY_SIZE` | `100M` | - |
| `CHARSET` | `utf-8` | - |
| `KEEPALIVE_TIMEOUT` | `20s` | - |

// todo, make this proper.
