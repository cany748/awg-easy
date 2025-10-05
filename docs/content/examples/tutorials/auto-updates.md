---
title: Auto Updates
---

## Docker Compose

With Docker Compose `awg-easy` can be updated with a single command:

```shell
cd /etc/docker/containers/awg-easy
sudo docker compose up -d --pull always
```

### Watchtower

If you want the updates to be fully automatic you can install Watchtower. This will check for updates every day at 4:00 AM and update the container if a new version is available.

File: `/etc/docker/containers/watchtower/docker-compose.yml`

```yaml
services:
    watchtower:
        image: containrrr/watchtower:latest
        volumes:
            - /var/run/docker.sock:/var/run/docker.sock
        env_file:
            - watchtower.env
        restart: unless-stopped
```

File: `/etc/docker/containers/watchtower/watchtower.env`

```env
WATCHTOWER_CLEANUP=true
WATCHTOWER_SCHEDULE=0 0 4 * * *
TZ=Europe/Berlin

# Email
# WATCHTOWER_NOTIFICATIONS_LEVEL=info
# WATCHTOWER_NOTIFICATIONS=email
# WATCHTOWER_NOTIFICATION_EMAIL_FROM=mail@example.com
# WATCHTOWER_NOTIFICATION_EMAIL_TO=mail@example.com
# WATCHTOWER_NOTIFICATION_EMAIL_SERVER=smtp.example.com
# WATCHTOWER_NOTIFICATION_EMAIL_SERVER_USER=mail@example.com
# WATCHTOWER_NOTIFICATION_EMAIL_SERVER_PASSWORD="SuperSecurePassword"
# WATCHTOWER_NOTIFICATION_EMAIL_SERVER_PORT=587
```

```shell
cd /etc/docker/containers/watchtower
sudo docker compose up -d
```

## Docker Run

```shell
sudo docker stop awg-easy
sudo docker rm awg-easy
sudo docker pull ghcr.io/evoll/awg-easy
```

And then run the `docker run -d \ ...` command from [Docker Run][docker-run] again.

[docker-run]: ./docker-run.md

## Podman

To update `awg-easy` (and every container that has auto updates enabled), you can run the following command:

```shell
sudo podman auto-update
```
