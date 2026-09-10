function fish_greeting
    if type -q fortune
        set -l quote (fortune -s | string collect)

        if test -n "$quote"
            set -l lines

            for paragraph in (string split \n -- "$quote")
                set paragraph (string replace --all \t ' ' -- "$paragraph")
                set -l line ''

                for word in (string split ' ' -- $paragraph)
                    if test -z "$word"
                        continue
                    end

                    if test (string length -- "$word") -gt 56
                        if test -n "$line"
                            set --append lines "$line"
                            set line ''
                        end

                        while test (string length -- "$word") -gt 56
                            set --append lines (string sub --length 56 -- "$word")
                            set word (string sub --start 57 -- "$word")
                        end
                    end

                    if test -z "$line"
                        set line "$word"
                    else if test (string length -- "$line $word") -le 56
                        set line "$line $word"
                    else
                        set --append lines "$line"
                        set line "$word"
                    end
                end

                if test -n "$line"
                    set --append lines "$line"
                end
            end

            set -l width 0
            for line in $lines
                set -l line_width (string length -- "$line")
                if test $line_width -gt $width
                    set width $line_width
                end
            end

            set_color B7A7D8
            echo "╭─"(string repeat -n $width '─')"─╮"
            set_color ADB5C5
            for line in $lines
                set -l padding (string repeat -n (math $width - (string length -- "$line")) ' ')
                echo "│ $line$padding │"
            end
            set_color B7A7D8
            echo "╰─"(string repeat -n $width '─')"─╯"
            set_color normal
        end
    end

    fastfetch
end

function openwebui
    set -l container open-webui
    set -l compose_file "$HOME/.config/open-webui/compose.yaml"
    set -l url http://localhost:3001

    if not docker compose --file $compose_file up --detach >/dev/null
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
    # Tide Classic prompt: keep context local to SSH/root shells.
    set --global tide_left_prompt_frame_enabled true
    set --global tide_left_prompt_items context pwd git newline character
    set --global tide_left_prompt_prefix ''
    set --global tide_left_prompt_separator_diff_color ' '
    set --global tide_left_prompt_separator_same_color ' '
    set --global tide_left_prompt_suffix ''
    set --global tide_right_prompt_frame_enabled false
    set --global tide_right_prompt_items cmd_duration status node python rustc go java php terraform docker
    set --global tide_right_prompt_prefix ''
    set --global tide_right_prompt_separator_diff_color ' '
    set --global tide_right_prompt_separator_same_color ' '
    set --global tide_right_prompt_suffix ''

    set --global tide_prompt_add_newline_before false
    set --global tide_prompt_color_frame_and_connection 778093
    set --global tide_prompt_color_separator_same_color 778093
    set --global tide_prompt_icon_connection '─'
    set --global tide_prompt_pad_items false

    set --global tide_context_color_default A6ADBB
    set --global tide_context_color_root A6ADBB
    set --global tide_context_color_ssh A6ADBB

    set --global tide_pwd_color_anchors B7A7D8
    set --global tide_pwd_color_dirs B7A7D8
    set --global tide_pwd_color_truncated_dirs 9B8DBD

    set --global tide_git_color_branch 8FAA9A
    set --global tide_git_color_dirty C3A36F
    set --global tide_git_color_staged C3A36F
    set --global tide_git_color_untracked C3A36F
    set --global tide_git_color_conflicted CF7F89
    set --global tide_git_color_operation CF7F89
    set --global tide_git_color_upstream 8FAA9A

    set --global tide_character_color 8FAA9A
    set --global tide_character_color_failure CF7F89
    set --global tide_character_icon '➜'
    set --global tide_character_vi_icon_default '➜'
    set --global tide_character_vi_icon_replace '➜'
    set --global tide_character_vi_icon_visual '➜'

    set --global tide_cmd_duration_color C3A36F
    set --global tide_cmd_duration_threshold 2000
    set --global tide_status_color_failure CF7F89

    set --global tide_node_color 8FAA9A
    set --global tide_python_color 8FAA9A
    set --global tide_rustc_color 8FAA9A
    set --global tide_go_color 8FAA9A
    set --global tide_java_color 8FAA9A
    set --global tide_php_color 8FAA9A
    set --global tide_terraform_color 8FAA9A
    set --global tide_docker_color 8FAA9A

    if test -z (pgrep ssh-agent)
        eval (ssh-agent -c)
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    end

    ssh-add ~/.ssh/id_ed25519 2>/dev/null 
end

fish_add_path ~/.local/bin

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
alias turnoff="hyprshutdown && poweroff"
alias v2ray="~/ExternalTools/v2rayN-linux-64/v2rayN"
