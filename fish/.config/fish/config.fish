#--------------------------------------------------------------------------------------------------
# Interactive Shell
#--------------------------------------------------------------------------------------------------

if status is-interactive

    #----------------------------------------------------------------------------------------------
    # Vi Mode
    #----------------------------------------------------------------------------------------------

    fish_vi_key_bindings

    # Cursor shape indicates current vi mode
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual block

    #----------------------------------------------------------------------------------------------
    # Environment
    #----------------------------------------------------------------------------------------------

    # Homebrew + Go binaries
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin

    set -gx GOPATH "$HOME/go"
    set -gx GOBIN "$GOPATH/bin"

    fish_add_path "$GOBIN"

    # GPG signing
    set -gx GPG_TTY (tty)

    # Bat
    set -gx BAT_THEME "Catppuccin Latte"

    set -gx EDITOR hx
    set -gx VISUAL hx

    set -gx MANPAGER "bat -plman"

    #----------------------------------------------------------------------------------------------
    # FZF
    #----------------------------------------------------------------------------------------------

    set -gx FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

    fzf --fish | source

    #----------------------------------------------------------------------------------------------
    # Zoxide
    #----------------------------------------------------------------------------------------------

    zoxide init fish | source

    #----------------------------------------------------------------------------------------------
    # Aliases
    #----------------------------------------------------------------------------------------------

    alias please="sudo"
    alias rootme="sudo -i"

    alias brewup="brew update && brew upgrade && brew cleanup -s"

    alias vi="hx"
    alias vim="hx"

    alias kts="kotlinc -script"

    alias reload-fish="exec fish"
    alias edit-fish="hx ~/.config/fish/config.fish"

    alias ls="eza --icons=auto --group-directories-first"
    alias ll="eza -lah --git --icons=auto --group-directories-first"
    alias la="eza -a --icons=auto --group-directories-first"
    alias lt="eza --tree --level=2 --icons=auto --group-directories-first"

    alias cat="bat --paging=never"

    #----------------------------------------------------------------------------------------------
    # Go Development
    #----------------------------------------------------------------------------------------------

    function gopher
        go mod tidy &&
            go mod vendor &&
            go fmt ./... &&
            go build ./... &&
            go test ./...
    end

    #----------------------------------------------------------------------------------------------
    # Starship
    #----------------------------------------------------------------------------------------------

    function starship_transient_prompt_func
        starship module character
    end

    starship init fish | source
    enable_transience

end

#--------------------------------------------------------------------------------------------------
# OPAM
#--------------------------------------------------------------------------------------------------

test -r "$HOME/.opam/opam-init/init.fish"; and source "$HOME/.opam/opam-init/init.fish" >/dev/null 2>/dev/null
