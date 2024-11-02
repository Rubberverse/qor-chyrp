## Chyrp Lite

Nginx, PHP-FPM and Chyrp Lite, bundled and ready to rumble.

- 👤 Container User: `nginx_user`, UID:GID `1001:1001`
- 🌊 Base Image: `debian/bookworm-slim:latest`
- 📦 With following packages: `curl`, `envsubst`, `ca-certificates`, `tini`, `nginx` and `php8.2`
- 🌐 Serves following project: [xenocrat/chyrp-lite](https://github.com/xenocrat/chyrp-lite/)

Intended to be ran behind a reverse proxy providing TLS.

## ⚙️ PHP Modules

Includes following bare minimum to run FreshRSS: `php-gd`, `php-fpm`, `php-intl`, `php-curl`, `php-mysql`, `php-pgsql`, `php-sqlite3`, `php-mbstring` and `php-opcache`

## 🛠️ Build guide

1. Git clone this repository
2. Navigate to chyrp-lite
3. Copy following files from configs: `fpm.conf`, `www.conf`, `nginx.conf` to chyrp-lite
4. Copy `remove-junk.sh` from scripts to chyrp-lite
5. Run `podman build -f nginx-fpm.Dockerfile -t localhost/chyrplite:latest`
6. Look into the Dockerfile to see environmental variables, you definitely want to customize the `NGINX_` ones to your liking
7. Deploy it and navigate to `http://localhost:9001`

## 🤠 (Basic) Deployment

### 💾 Data Persistence

Mount `/app/www/chyrp/includes/`, `/app/www/chyrp/uploads/` and  `/app/www/chyrp/sitemap.xml` to your host. The rest will be saved to database of your choice, please use MariaDB or PostgreSQL.

### 📦 Existing Chyrp Lite installations

1. Mount `includes/` and `uploads/` to `/app/www/chyrp/includes` and `/app/www/chyrp/uploads` respectively.
2. Create a blank file `touch blank` and mount it against `/app/www/chyrp/install.php` and `/app/www/chyrp/upgrade.php` (If not upgrading from old installation)
3. Your site is ready to be served under `localhost:9001`

💁 You can also mount your entire Chyrp-Lite site to `/app/www/chyrp`, this will overwrite container installation of Chyrp Lite. Recommended way of doing it is to do it via a bind mount, that way you get proper read/write between host and container.

### 🗃️ Fresh Chyrp Lite installations

1. Mount `/app/www/chyrp/includes` and `/app/www/chyrp/uploads` to host for data persistence
2. Navigate to `localhost:9001/install.php`
3. Complete the setup process
4. Your site is ready to be served under `localhost:9001`

If you won't be using sqlite3 adapter, prepare a database container beforehand - MariaDB/MySQL or PostgreSQL are supported databases. 
It is recommended to do this initially as otherwise it can be quite painful switching away from different database formats.

It is also recommended to mount blank files over `install.php` and `upgrade.php` respectively. Look at Existing Chyrp Lite Installation for steps.

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

### 403 Forbidden on Uploaded media

Somebody forgot to change `NGINX_VALID_REFS` environmental variable. Just put your site there enclosed by "quotation marks" and it will work again ex.

```bash
Environment=NGINX_VALID_REFS="blog.rubberverse.xyz rubberverse.xyz"
```

Restart container and they will show up properly. Oh, and also make sure to clear browser cache or press shift+f5 to bypass cache.

## ♻️ Updating

Non-lazy route:

1. Remove blank file Volume mounts that point to `upgrade.php`
2. Update container `podman auto-update`
3. Visit `localhost:9001/upgrade.php`
4. Run upgrade procedure
5. Re-add the blank file Volume mount and restart the container
6. You're set

Lazy route:

1. Update Chyrp Lite manually on your host and copy your config.json.php to `includes/` and your `uploads/` folder back to it
2. Mount Chyrp Lite files to `/app/www/chyrp`
3. Restart container
4. Navigate to `localhost:9001/upgrade.php`
5. Remove the file from host with `podman exec -t CONT_ID rm /app/www/chyrp/upgrade.php`

Correct folder structure is `/app/www/chyrp/<root>` and not ex. `/app/www/chyrp/chyrplite-2024.03/<root>`. Verify that your mount is correct.

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

Reload systemctl and restart your container afterwards. As shrimple as that! 🦐
