function fish_greeting
    fastfetch --logo arch_small --structure title:packages:kernel:uptime:battery:memory:gpu:cpu
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

alias ls="exa --icons"
alias ll="exa -la --icons"
# alias cat="bat"
alias ff="fastfetch"
# alias up="yay -Syu --devel --timeupdate && metapac sync"