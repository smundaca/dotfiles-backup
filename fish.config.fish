starship init fish | source
set -g fish_greeting
set -g fish_color_autosuggestion 5c6370
if status is-interactive
    if set -q KITTY_WINDOW_ID
        fastfetch
    end
end
