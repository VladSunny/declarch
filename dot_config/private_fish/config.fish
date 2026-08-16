function fish_greeting
    fastfetch --logo arch_small --structure title:packages:kernel:uptime:battery:memory:gpu:cpu
end

function openwebui
    set -l container open-webui
    set -l url http://localhost:3000

    if not docker start $container >/dev/null
        echo "Failed to start $container." >&2
        return 1
    end

    for attempt in (seq 60)
        set -l health (docker inspect --format '{{.State.Health.Status}}' $container 2>/dev/null)

        switch $health
            case healthy
                if not xdg-open $url >/dev/null 2>&1
                    echo "Open WebUI is ready at $url, but the browser could not be opened." >&2
                    return 1
                end
                return 0
            case unhealthy
                echo "Open WebUI became unhealthy. Check: docker logs $container" >&2
                return 1
        end

        sleep 1
    end

    echo "Timed out waiting for Open WebUI. Check: docker logs $container" >&2
    return 1
end

if status is-interactive
    starship init fish | source
    
    if test -z (pgrep ssh-agent)
        eval (ssh-agent -c)
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    end

    ssh-add ~/.ssh/id_ed25519 2>/dev/null 
end

if status is-login
    fish_add_path ~/.local/bin
end

if type -q mise
    mise activate fish | source
end

set -gx EDITOR nvim
set -gx VISUAL nvim

alias ls="exa --icons"
alias ll="exa -la --icons"
# alias cat="bat"
alias ff="fastfetch"
alias up="paru -Syu && metapac sync"
alias turnoff="hyprshutdown && poweroff"t
