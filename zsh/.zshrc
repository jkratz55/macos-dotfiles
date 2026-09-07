#--------------------------------------------------------------------------------------------------
# Environment
#--------------------------------------------------------------------------------------------------
typeset -U path PATH
path=(
    "$HOME/go/bin"
    $path
)

export GPG_TTY="$(tty)"

eval "$(direnv hook zsh)"

[[ -f "$HOME/.config/zsh/secrets.zsh" ]] &&
    source "$HOME/.config/zsh/secrets.zsh"

#--------------------------------------------------------------------------------------------------
# Shell Options
#--------------------------------------------------------------------------------------------------

bindkey -v
KEYTIMEOUT=10

setopt AUTO_CD

# Colorize ls output
export CLICOLOR=1
export LS_COLORS="$(vivid generate catppuccin-latte)"

#--------------------------------------------------------------------------------------------------
# History
#--------------------------------------------------------------------------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY

source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down
bindkey -M vicmd '^[[A' history-substring-search-up
bindkey -M vicmd '^[[B' history-substring-search-down

#--------------------------------------------------------------------------------------------------
# FZF
#--------------------------------------------------------------------------------------------------

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

source <(fzf --zsh)

#--------------------------------------------------------------------------------------------------
# Autocomplete
#--------------------------------------------------------------------------------------------------

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:descriptions' format '%B%d%b'

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#--------------------------------------------------------------------------------------------------
# Zoxide
#--------------------------------------------------------------------------------------------------

eval "$(zoxide init zsh)"

#--------------------------------------------------------------------------------------------------
# Aliases
#--------------------------------------------------------------------------------------------------

alias please="sudo"
alias rootme="sudo -i"

alias ll="eza -lah --git --icons=auto --group-directories-first"
alias lt="eza --tree --level=2 --icons=auto --group-directories-first"

alias brewup="brew update && brew upgrade && brew cleanup -s"

alias gopher="go mod tidy && go mod vendor && go fmt ./... && go build ./...  && go test ./..."

alias r="fc -e -"
alias vi="hx"
alias vim="hx"

alias reload-zsh="exec zsh"
alias edit-zsh="hx ~/.zshrc"

alias kts="kotlinc -script"

#--------------------------------------------------------------------------------------------------
# Banner
#--------------------------------------------------------------------------------------------------

cat << 'EOF'
__   __   ______ _   _
\ \ / /   | ___ \ | | |
 \ V /___ | |_/ / |_| | __ _
  \ // _ \|    /|  _  |/ _` |
  | | (_) | |\ \| | | | (_| |
  \_/\___/\_| \_\_| |_/\__,_|


 _____ _                    _         ___  ___            _    _           _
|  __ \ |                  | |        |  \/  |           | |  (_)         | |
| |  \/ | ___  _ __ _   _  | |_ ___   | .  . | __ _ _ __ | | ___ _ __   __| |
| | __| |/ _ \| '__| | | | | __/ _ \  | |\/| |/ _` | '_ \| |/ / | '_ \ / _` |
| |_\ \ | (_) | |  | |_| | | || (_) | | |  | | (_| | | | |   <| | | | | (_| |
 \____/_|\___/|_|   \__, |  \__\___/  \_|  |_/\__,_|_| |_|_|\_\_|_| |_|\__,_|
                     __/ |
                    |___/
EOF

#--------------------------------------------------------------------------------------------------
# Prompt
#--------------------------------------------------------------------------------------------------

eval "$(starship init zsh)"

#--------------------------------------------------------------------------------------------------
# Syntax Highlighting
#
# MUST REMAIN LAST.
# zsh-syntax-highlighting should be initialized after all other ZLE widgets/plugins.
#--------------------------------------------------------------------------------------------------

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

