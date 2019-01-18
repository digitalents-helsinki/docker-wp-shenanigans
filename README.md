# Docker Wordpress Shenanigans

> The adventures of Wordpress containerization and theme development with Docker.

## Requirements

- Docker 18.09.0
- Docker Compose 1.23.2

If you have node.js (and thus, probably npm) installed, that'd be super nice. We're using npm scripts to build, start, stop and remove containers. In the future, when this whole containerization process is fleshed out properly and the developer experience is smooth, you'll need to have node.js installed either way for theme development.

## Developing

First, create `.env` file to the root of the project directory and use the `.env.example` as a reference. For example;

```sh
DB_USER=digitalents_wp
DB_PASSWORD=supersecret
DB_NAME=digitalents_wp
```

Then make sure that you have created the following folders in same directory where `build.sh` is located:

- themes
- plugins
- uploads
- sqldumps
- `mkdir themes plugins uploads sqldumps` Creates the required folders for the WordPress and MySQL Database integration.

Depending on your operating system, the process of starting up the containers should be either straightforward or slightly annoying. [MacOS](#MacOS) setup is literally one command away from being ready for development purposes, while [Linux](#Linux) requires you to `chown`ing some directories. Don't even ask about Windows, I have literally no clue if it'll work there.

### MacOS

- `npm run build:up mac` builds images and starts the containers specified in `docker-compose.yaml` file.
- Browse to [http://localhost:8080](http://localhost:8080) and finish the WP configuration using your preferred username and password.

### Linux

- `npm run build:up linux` builds images and starts the containers specified in `docker-compose.yaml` file.
- Browse to [http://localhost:8080](http://localhost:8080) and finish the WP configuration using your preferred username and password.

If you need to restart the containers, `npm run build:down` does that for you. You can also check out the `build.sh` shell script on the root directory to see more options, such as stopping and removing both the containers and their respective volumes... Or just do it yourself using `docker-compose`.

## Backups (Import/Export)

Depending on your situation you might want to take backup from your databases or want to import your earlier data to fresh container installation.

Make sure that your .sql-files are located inside `sqldumps`-folder if you need to import database and use the name of wanted file when executing the import command.

- `npm run sql:backup` builds backup file from all of your current databases.
- `npm run sql:import <wp_backup_############>.sql` Imports your backup file to your database container.