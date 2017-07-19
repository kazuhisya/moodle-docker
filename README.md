# moodle docker

This repository provides moodle environment for docker compose.

## System Requirements

- Docker Engine 1.10.0+
- Docker Compose 1.6.0+

## Get started


```bash
$ cd moodle-docker/
```

First, edit `MOODLE_URL` in your `docker-compose.yml`.

like this:

```yaml
~~ snip ~~
    environment:
      TZ: Asia/Tokyo
      POSTGRES_HOST: moodle_db
      POSTGRES_PORT: 5432
      POSTGRES_DB: moodle
      POSTGRES_USER: moodle
      PGPASSWORD: moodle
      MOODLE_URL: "http://localhost:8080/moodle" # edit this line!
~~ snip ~~
```

Usually, `MOODLE_URL` sets FQDN of your Docker host.

Next, you can `build` and `up` (launch).


```bash
$ docker-compose build
$ docker-compose up -d
$ docker-compose logs -f moodle  # and wait for the finish output...
```

```bash
# Sample finish output
moodle_1     | インストールが正常に完了しました。
moodle_1     | Admin account: admin/admin
moodle_1     | first setup done.
```

After seeing the finish output, open `http://<docker host>:<port>/` in your browser.


## Disclaimer

This repository and all files that are included in this, there is no relationship at all with the upstream and vendor.

