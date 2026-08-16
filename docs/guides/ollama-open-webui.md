# Connect Open WebUI to Ollama on the Host

This setup runs Ollama as a systemd service on the host and Open WebUI in a
Docker container. The container reaches Ollama through
`host.docker.internal:11434`.

## Expose Ollama to the Docker bridge

Ollama listens on `127.0.0.1:11434` by default. A Docker container cannot
reach that loopback address, so add a systemd drop-in that binds Ollama to all
host interfaces:

```bash
sudo systemctl edit ollama.service
```

Add the following content:

```ini
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
```

Reload systemd and restart Ollama:

```bash
sudo systemctl daemon-reload
sudo systemctl restart ollama.service
```

Confirm that the service is running and its API responds:

```bash
systemctl status ollama.service
curl --fail http://127.0.0.1:11434/api/tags
```

Binding to `0.0.0.0` exposes the Ollama API on every host network interface.
Use a firewall to limit port `11434` to trusted networks, or block external
access entirely when only local Docker containers need it.

## Configure Open WebUI

The Open WebUI container must map `host.docker.internal` to Docker's host
gateway. For a new container, include:

```text
--add-host=host.docker.internal:host-gateway
```

The existing container mapping can be checked with:

```bash
docker inspect --format '{{json .HostConfig.ExtraHosts}}' open-webui
```

In Open WebUI, open **Admin Settings**, go to **Connections > Ollama**, and
set the connection URL to:

```text
http://host.docker.internal:11434
```

Open WebUI is available at <http://localhost:3000>. In fish, run `openwebui`
to start the container, wait for its health check, and open the page in the
default browser.

## Troubleshooting

Check the Ollama service and Open WebUI container logs:

```bash
journalctl --unit=ollama.service --boot
docker logs open-webui
```

If the service works on the host but Open WebUI cannot reach it, verify both
the container's host-gateway mapping and the connection URL. Do not use
`localhost:11434` in Open WebUI: inside the container, `localhost` refers to
the container itself.

For current upstream details, see the
[Ollama FAQ](https://docs.ollama.com/faq) and the
[Open WebUI Ollama guide](https://docs.openwebui.com/getting-started/quick-start/connect-a-provider/starting-with-ollama/).
