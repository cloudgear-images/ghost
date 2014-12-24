# Ghost Image

A Ghost image either running with an integrated SQLite db or with an external PostgreSQL. Configureable by environment vars and customizable by adding themes or apps with Docker onbuild instructions.

## Environemnt Variables

* `BLOG_URL` Ghost url setting, e.g. "http://blog.cloudgear.co"
* `DATABASE_URL` PostgreSQL database to connect to, optionally. SQLite is used if omitted. Example: "postgres://ghost:password@localhost:5432/ghost"

## Configured Volumes

* `/usr/src/app/content/images` for uploaded images
* `/usr/src/app/content/data` for SQLite database


## Run with Docker

### Postgres Database

First we need to start a PostgreSQL instance

    $ docker pull postgres:9.3
    $ docker run -d --name ghost-postgres -p 5432/tcp -e POSTGRES_USER=ghost -e POSTGRES_PASSWORD=w9IIynNJaEcBT4FKhSn5BQ postgres:9.3

This creates a PostgreSQL container with a database named `ghost` and user `ghost` with the given password.

### Ghost App

Now we can start the Ghost blogging platform

    $ docker pull cloudgear/ghost:0.5.7
    $ docker run -d --name ghost.1 -p 2368/tcp -e BLOG_URL=http://ghost.10.0.9.10.xip.io -e DATABASE_URL=postgres://ghost:w9IIynNJaEcBT4FKhSn5BQ@10.0.9.10:49244/ghost cloudgear/ghost:0.5.7

Please change the `DATABASE_URL` to the IP and port of the PostgreSQL container you started previously.

### Embedded SQLite

If you don't want to run an extra PostgreSQL database you can start Ghost without a `DATABASE_URL` environment variable. Then the default SQLite database will be used which is stored in the volume `/usr/src/app/content/data`.


## Run with Cloudgear

Running Ghost with Cloudgear is almost the same as with Docker.

### Postgres Database

First, start a PostgreSQL instance

    $ cgear create ghost-demo-postgres postgres:9.3 -p 30120:5432/tcp -e POSTGRES_USER=ghost POSTGRES_PASSWORD=w9IIynNJaEcBT4FKhSn5BQ
    $ cgear dist -n node1:1 -s ghost-demo-postgres

This creates and runs a PostgreSQL container with a database named `ghost` and user `ghost` with the given password.

### Ghost App

Let's create the Ghost application

    $ cgear create ghost-demo geku/ghost:0.5.7 -p 2368/tcp -r -e BLOG_URL=http://ghost.10.0.9.10.xip.io DATABASE_URL=postgres://ghost:w9IIynNJaEcBT4FKhSn5BQ@ghost-demo-postgres:30120/ghost

and run it

    $ cgear dist -n node1:1 -s ghost-demo

Check if it is running

    $ cgear service -s ghost-demo

and open the URL `http://ghost.10.0.9.10.xip.io`. Certainly, you should adapt the URL to your setup.


## Limitations

### Backup

For the moment the only way to backup your blog data is through the Ghost admin interface. Go to Settings, Labs and export your data. Later we will introduce a PostgreSQL image with backup capabilities.

### Redundancy

It's not possible to have multiple Ghost instances running as all uploaded files are stored in the local file system. Right now Cloudgear provides no shared file system. The only option would be to use an Amazon S3 plugin for Ghost.


## TODO

* email settings by env vars (works with no settings but not really reliable)
