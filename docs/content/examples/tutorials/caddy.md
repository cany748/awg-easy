---
title: Caddy
---

/// note | Opinionated

This guide is opinionated. If you use other conventions or folder layouts, feel free to change the commands and paths.
///

We're using [Caddy](https://caddyserver.com/) here as reserve proxy to serve `awg-easy` on [https://awg-easy.example.com](https://awg-easy.example.com) via TLS.

## Create a docker composition for `caddy`

```txt
.
├── compose.yml
└── Caddyfile

1 directory, 2 files
```

```yaml
# compose.yml

services:
    caddy:
        container_name: caddy
        image: caddy:2.10.0-alpine
        # publish everything you deem necessary
        ports:
            - '80:80/tcp'
            - '443:443/tcp'
            - '443:443/udp'
        networks:
            - caddy
        restart: unless-stopped
        volumes:
            - './Caddyfile:/etc/caddy/Caddyfile:ro'
            - config:/config
            - data:/data

networks:
    caddy:
        name: caddy

volumes:
    config:
    data:
```

```txt
# Caddyfile

{
        # setup your email address
        email mail@example.com
}

awg-easy.example.com {
        # since the container will share the network with awg-easy
        # we can use the proper container name
        reverse_proxy awg-easy:80
        tls internal
}
```

...and start it with:

```shell
sudo docker compose up -d
```

## Adapt the docker composition of `awg-easy`

```yaml
services:
  awg-easy:
    # sync container name and port according to Caddyfile
    container_name: awg-easy
    environment:
      - PORT=80
    # no need to publish the HTTP server anymore
    ports:
      - "51820:51820/udp"
    # add to caddy network
    networks:
      caddy:
    ...

networks:
  caddy:
    external: true
  ...
```

...and restart it with:

```shell
sudo docker compose up -d
```

You can now access `awg-easy` at [https://awg-easy.example.com](https://awg-easy.example.com) and start the setup.
