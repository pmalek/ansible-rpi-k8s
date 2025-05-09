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

### paperless-ngx

To ensure that [paperless-ngx](https://docs.paperless-ngx.com/) config is enforced, run:

```bash
make paperless
```

#### Info

Backups from paperless instance are being pushed using [backrest](https://github.com/garethgeorge/backrest) to a remote s3 compatible bucket.

#### Import/export documents from a running instance

Related: <https://github.com/paperless-ngx/paperless-ngx/discussions/6389#discussioncomment-9192427>

```bash
python ./src/manage.py document_exporter /tmp/qqq/

# and then on a clean install (preexisting seems to work as well though)
python ./src/manage.py document_importer /tmp/qqq/
```

#### How to restore from a backup

1. Download the backup directory from backrest

    ![How to retrieve files from backrest backup](static/img/backrest_paperless_restore.png)

1. When downloaded to the machine that runs paperless-ngx run the following commands:

    ```bash
    docker volume create paperless_data paperless_media # delete if they exist
    for dir in media data ; do docker run --rm -v $(pwd)/userdata/paperless_${dir}:/source/ -v paperless_${dir}:/destination busybox sh -c 'cp -r /source/* /destination/' ; done
    ```

1. Run paperless-ngx. 🎉

#### Additional useful materials

- <https://www.linuxserver.io/blog/backup-your-data-to-b2-with-restic-and-backrest>
- <https://docs.paperless-ngx.com/administration/#backup>

## Best practices for running Pi

- <https://www.dzombak.com/blog/2023/12/Disable-or-remove-unneeded-services-and-software-to-help-keep-your-Raspberry-Pi-online.html>
