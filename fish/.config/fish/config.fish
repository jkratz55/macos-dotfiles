if status is-interactive
    # Commands to run in interactive sessions can go here ...
end

# Enable vi key bindings
fish_vi_key_bindings

# GPG Signing
set GPG_TTY $(tty)

# GO
set GOPATH /Users/$USER/go
set GOBIN $GOPATH/bin

# Bat customizations
set BAT_THEME "Catppuccin Latte"

# Aliases
alias rootme="sudo su -"
alias brewup="brew update && brew upgrade && brew cleanup -s"
alias gopher="go mod tidy && go mod vendor && go fmt ./... && go build ./...  && go test ./..."
alias r="fc -e -"
alias vi="hx"
alias vim="hx"
alias kts="kotlinc -script"
alias python="/opt/homebrew/bin/python3"
alias python3="/opt/homebrew/bin/python3"
alias pip="/opt/homebrew/bin/pip3"
alias pip3="/opt/homebrew/bin/pip3"

# Configure transient prompt
function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience

zoxide init fish | source
starship init fish | source

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/Users/jkratz/.opam/opam-init/init.fish' && source '/Users/jkratz/.opam/opam-init/init.fish' >/dev/null 2>/dev/null; or true
# END opam configuration
