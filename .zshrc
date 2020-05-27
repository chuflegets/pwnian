source ~/.config/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Manual configuration
if [[ "$USER" = "root" ]]; then
    PATH=$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
else
    PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
fi

# Manual aliases
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lah --group-dirs=first'
alias ls='lsd --group-dirs=first'

alias cat='/usr/bin/bat'
alias catn='/usr/bin/cat'
alias catnl='/usr/bin/bat --paging=never'

# Functions
function mkt () {
    mkdir {nmap,content,exploits,scripts}
}

function rmk () {
    scrub -p schneier $1 1> /dev/null; shred -zun 10 $1
}

SAVEHIST=1000
HISTFILE=~/.zsh_history
