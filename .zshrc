source ~/.config/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Manual configuration
if [[ "$USER" = "root" ]]; then
    PATH=$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
else
    PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
fi

