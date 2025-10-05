---
title: CLI
---

If you want to use the CLI, you can run it with

### Docker Compose

```shell
cd /etc/docker/containers/awg-easy
docker compose exec -it awg-easy cli
```

### Docker Run

```shell
docker run --rm -it \
    -v ~/.awg-easy:/etc/wireguard \
    ghcr.io/evoll/awg-easy:15 \
    cli
```

### Reset Password

If you want to reset the password for the admin user, you can run the following command:

#### By Prompt

```shell
cd /etc/docker/containers/awg-easy
docker compose exec -it awg-easy cli db:admin:reset
```

You are asked to provide the new password

#### By Argument

```shell
cd /etc/docker/containers/awg-easy
docker compose exec -it awg-easy cli db:admin:reset --password <new_password>
```

This will reset the password for the admin user to the new password you provided. If you include special characters in the password, make sure to escape them properly.
