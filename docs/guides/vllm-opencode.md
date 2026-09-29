# Connect OpenCode to Local vLLM

This setup connects OpenCode 2.0.x to the Qwen profile served by
`~/Projects/Tools/vlad-vllm`. Both applications run on the same workstation;
vLLM remains bound to `127.0.0.1:8000`.

## Prepare vLLM

Complete the initial setup described in the `vlad-vllm` README first. Its
`.env` file must contain a non-empty `VLLM_API_KEY` and remain outside this
chezmoi repository with mode `0600`.

Run the lightweight Qwen profile:

```bash
cd ~/Projects/Tools/vlad-vllm
make preflight PROFILE=qwen2.5-3b-instruct
make serve PROFILE=qwen2.5-3b-instruct
```

Keep that terminal open. The profile exposes the model as
`qwen2.5-3b-instruct`, enables automatic tool selection with the Hermes parser,
and listens at `http://127.0.0.1:8000/v1`.

In another terminal, run the project's smoke test:

```bash
cd ~/Projects/Tools/vlad-vllm
make smoke PROFILE=qwen2.5-3b-instruct
```

The smoke test covers the authenticated API path, streaming, tool calling,
and rejection of an invalid key.

## Apply the OpenCode configuration

Chezmoi manages `~/.config/opencode/opencode.jsonc` from
`dot_config/opencode/opencode.jsonc`. It defines:

- provider ID `local-vllm`;
- the OpenAI-compatible endpoint `http://127.0.0.1:8000/v1`;
- model `qwen2.5-3b-instruct` with text input/output and tool support;
- a 32,768-token context limit and an 8,192-token output limit;
- `local-vllm/qwen2.5-3b-instruct` as the default model.

Review and apply only this target:

```bash
chezmoi diff ~/.config/opencode/opencode.jsonc
chezmoi apply --dry-run --verbose ~/.config/opencode/opencode.jsonc
chezmoi apply ~/.config/opencode/opencode.jsonc
opencode reload
```

The adjacent `~/.config/opencode/service.json` is runtime state and is not
managed by chezmoi.

## Store the API key

Do not add `VLLM_API_KEY`, an `apiKey` value, or the `vlad-vllm/.env` file to
chezmoi. Store the existing key in OpenCode's credential store instead:

1. Start OpenCode and run `/connect`.
2. Select **Other**.
3. Enter `local-vllm` as the provider ID. It must exactly match the ID in
   `opencode.jsonc`.
4. Paste the `VLLM_API_KEY` value from `~/Projects/Tools/vlad-vllm/.env`.

Confirm that OpenCode has a stored credential without printing its value:

```bash
opencode auth list
```

The output should contain `Local vLLM` with status `stored`.

## Verify OpenCode

Confirm that the configured model is available:

```bash
opencode models | rg '^local-vllm/qwen2\.5-3b-instruct$'
```

Run a normal request explicitly against the local model:

```bash
opencode run --model local-vllm/qwen2.5-3b-instruct \
  "Reply with exactly: local vLLM is ready"
```

Then require a real tool call. Run this in a disposable directory so the
model cannot confuse repository contents with the expected result:

```bash
tmp_dir=$(mktemp -d)
cd "$tmp_dir"
opencode run --model local-vllm/qwen2.5-3b-instruct --auto \
  "Use the shell tool to run pwd, then report only the absolute path returned by the tool."
cd -
```

The trace must show a shell-tool invocation, and the final answer must match
the temporary directory. A plausible path written without a tool invocation
does not validate tool calling.

Finally, verify authentication independently with a deliberately invalid key:

```bash
curl --silent --show-error --output /dev/null --write-out '%{http_code}\n' \
  --header 'Authorization: Bearer invalid' \
  http://127.0.0.1:8000/v1/models
```

The expected status is `401`.

## Troubleshooting

- **The model is absent from `opencode models`:** run `opencode reload`, then
  inspect `opencode debug config`. The output must include the global
  `opencode.jsonc` document and provider `local-vllm`.
- **OpenCode reports missing credentials or receives `401`:** repeat
  `/connect`, select **Other**, and use the exact provider ID `local-vllm`.
  Make sure the pasted value is the current key from `vlad-vllm/.env`.
- **The endpoint is unreachable:** confirm that `make serve
  PROFILE=qwen2.5-3b-instruct` is still running and that no other process owns
  port `8000`.
- **Text works but tools do not:** check the vLLM startup log for
  `--enable-auto-tool-choice` and `--tool-call-parser hermes`. Do not remove
  `capabilities.tools: true` from the OpenCode model entry.
- **The key was exposed:** replace `VLLM_API_KEY` in `vlad-vllm/.env`, restart
  vLLM, and reconnect `local-vllm` in OpenCode. Never place the replacement
  value in shell history, Git, documentation, or issue logs.

For the current configuration contract, see the official OpenCode
[models](https://opencode.ai/v2/docs/models) and
[providers](https://opencode.ai/v2/docs/providers) documentation.
