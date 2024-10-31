## 🦆 Rubberverse Dockerfiles

Experimental rootless containers running specific per-service configurations, utilizing Nginx and PHP-FPM. Intended for specific php-focused projects.

Every image makes use of `tini` and runs both Nginx and php-fpm as rootless user, while encompassing special configuration files to make them plug-n-play when moving from bare-metal deployment.

It's as simple as building the image from the Dockerfile and then running it.

## 🛑 Prerequisites

- You must have already used the project
- It means you must have already correctly set-up database for the project you wish to containerize instead
- It also means you have the bare-metal web/php files at hand as you will need to mount them inside the container, they don't come bundled with core projects they're supposed to serve as some of them don't support such approach

## 🐳 General Dockerfile Configuration

- If Debian base image, debloats the image by removing a lot of system utilities and left-overs from apt, this means that systemd is also in turn purged away from the base image
- Runs by default as unprivileged user called `nginx_user` with both UID and GID of `1001`
- Both Nginx and php-fpm processes run as unprivileged user
- Nginx communicates with php-fpm via it's unix socket, which can be found in `/app/run/php-fpm.sock`, PID files can be found in same directory
- Log files are accessible in following directories: `/app/configs/fpm` and `/app/configs/nginx`
- These images are made in mind that you will only host a certain service it's made for and nothing else
- Clean URLs support via a custom nginx configuration for services that support it

## 💁 Project Assumptions

- This will be only used to reverse traffic to another web server such as Caddy that will terminate TLS, and in turn expose the service out to the world
- You won't modify core Nginx configuration as it's already set in a good-enough, production-ready manner. Although you're free to modify entrypoint script to change that and customize the Dockerfile to your liking, it's self-documented with CLI commands so shouldn't be too hard. (Create GitHub issue if you need help!)

## Build

1. Clone this git repository: `git clone https://github.com/Rubberverse/qor-chyrp.git`.
2. Enter the directory and move `nginx-fpm.Dockerfile` from qor-chyrp/debian to root of this directory: `mv qor-chyrp/debian/nginx-fpm.Dockerfile .`.
3. Move contents of scripts and configs to root of this directory: `mv scripts/* .; mv configs/* .`.

💁 If you want to mount your own nginx.conf, open `docker-entrypoint.sh` and comment out line 14 to prevent the entrypoint script from overwriting it.

4. Make yourself accustomed to build arguments.
5. Build the image with `podman build -f nginx-fpm.Dockerfile -t localhost/nginx:latest`.
6. Use the image and make sure to customize Environmental Variables to your own liking.
