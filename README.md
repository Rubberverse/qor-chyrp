# qor-chyrp
Experimental rootless container running php-fpm, NGINX and serving Chyrp Lite.

## Prerequisites

- Already set-up and ready database used on prior Chyrp Lite installation (MariaDB, PostgreSQL)
- You have installed Chyrp Lite once and configured it before on your host

## Dockerfile

- Debloats the image by removing a lot of tools and system utilities, resulting in a huge decrease of final image size: 592MB to 292MB which is 50% decrease in total image size.
- Runs by default as a unprivileged user called `nginx_user` and both php-fpm & Nginx are started as this user.
- Nginx communicates with php-fpm via unix socket.
- Includes a special Chyrp Lite configuration for Nginx, enabling clean paths and adding proper routing along with extra protection against embedding or accessing `/uploads/`, `/includes/`, `/data/` by unauthorized clients, or using any other unsupported HTTP method.
- This image can be used with other PHP projects, you can mount any configuration into `/app/configs/nginx/site-enabled` and your PHP sites into `/app/www/<name>`.
- Log files are accessible in `/app/configs/fpm/fpm-access.log`, `/app/configs/fpm/fpm-error.log`, `/app/configs/fpm/php-error.log`, `/app/configs/nginx/error.log` and `/app/configs/nginx/access.log`.
- PID files and socket files are accessible in `/app/run/php-fpm.pid`, `/app/run/nginx.pid` and `/app/run/php-fpm.sock`.

## Assumptions

- You will only use this to reverse proxy traffic, no TLS will be done on Nginx side.
- More environmental variable options will be added with time. They're only ran during container start-up as Nginx doesn't support environmental variables in configuration, so the way it works is it uses `envsubst` against a `.template` file and then writes it into a otherwise blank `nginx.conf` & `chyrp.conf`.

## Build

1. Clone this git repository: `git clone https://github.com/Rubberverse/qor-chyrp.git`.
2. Enter the directory and move `nginx-fpm.Dockerfile` from qor-chyrp/debian to root of this directory: `mv qor-chyrp/debian/nginx-fpm.Dockerfile .`.
3. Move contents of scripts and configs to root of this directory: `mv scripts/* .; mv configs/* .`.

💁 If you want to mount your own nginx.conf, open `docker-entrypoint.sh` and comment out line 14 to prevent the entrypoint script from overwriting it.

4. Make yourself accustomed to build arguments.
5. Build the image with `podman build -f nginx-fpm.Dockerfile -t localhost/nginx:latest`.
6. Use the image and make sure to customize Environmental Variables to your own liking.
