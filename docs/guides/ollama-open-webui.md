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

## Global context length

On `declarch-pc`, chezmoi manages
`/etc/systemd/system/ollama.service.d/20-context-length.conf` through
`run_onchange_after_115-configure-ollama-context.sh.tmpl`. It sets the Ollama
server's default context length to 64K tokens:

```ini
[Service]
Environment="OLLAMA_CONTEXT_LENGTH=65536"
```

The script reloads systemd and restarts Ollama when this drop-in changes. A
request-level `num_ctx` option or a model-specific `PARAMETER num_ctx` can
still override the server default. Larger contexts consume more VRAM; use
`ollama ps` while a model is loaded to check the allocated context and whether
the model is offloading to the CPU.

## Configure Open WebUI

Chezmoi manages the container definition in
`~/.config/open-webui/compose.yaml`. The container runs without authentication,
publishes its internal port `8080` on host loopback port `3001`, and maps
`host.docker.internal` to Docker's host gateway. Binding to `127.0.0.1` keeps
the unauthenticated interface inaccessible from the LAN.

The equivalent Docker options are:

```text
--env=WEBUI_AUTH=false
--publish=127.0.0.1:3001:8080
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

Open WebUI is available at <http://localhost:3001>. In fish, run `openwebui`
to create or start the container from the managed Compose configuration, wait
for its health check, and open the page in the default browser.

## Connect through SSH

Keep port `3001` bound to loopback and forward it over SSH instead of exposing
the unauthenticated interface on the network. On the connecting device, run:

```bash
ssh -N -L 3001:127.0.0.1:3001 <user>@<workstation>
```

While the SSH session is open, use <http://localhost:3001> on that device. If
its local port `3001` is already occupied, choose another local port, for
example `-L 13001:127.0.0.1:3001`, and open <http://localhost:13001>.

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
