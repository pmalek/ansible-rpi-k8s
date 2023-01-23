# ansible-rpi-k8s

Ansible playbook for setting up a local network (and not only) environment.

This sets up:

- Unifi controller running [linuxserver/docker-unifi-network-application][github_linuxserver_unifi] in a Docker container

> NOTE: Everything else in this repo is highly experimental.

[github_linuxserver_unifi]: https://github.com/linuxserver/docker-unifi-network-application

## How to run

Ensure that your Pi's IP/hostname is set in `inventory/all.yaml`.

Run:

```
make run
```

### Unifi

To ensure that the Unifi controller config is enforced, run:

```
make unifi
```

The following environment variables are required:

- `BWS_ACCESS_TOKEN`
- `BWS_SERVER_URL` (e.g. `https://vault.bitwarden.com`)
- `BWS_PROJECT_ID`

## Best practices for running Pi

- <https://www.dzombak.com/blog/2023/12/Disable-or-remove-unneeded-services-and-software-to-help-keep-your-Raspberry-Pi-online.html>
