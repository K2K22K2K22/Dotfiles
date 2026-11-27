# ============================================================
# Fish configuration
# Sections: Environment → Interactive → Navigation → Files →
#           Packages → Git → System → Fun → Aliases
# ============================================================

# ---------------------------- Environment --------------------
set -gx QT_QPA_PLATFORM xcb
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Tools and language runtimes.
fish_add_path $HOME/.local/bin $HOME/.bun/bin $HOME/.local/share/nvim/mason/bin

if status is-interactive
    set -g fish_greeting ""

    # smarter cd (z/zi) and fuzzy history (Ctrl-R)
    if type -q zoxide
        zoxide init fish | source
    end
    if type -q fzf
        fzf --fish | source
    end
end

# ---------------------------- Navigation ---------------------
function c -d "Change directory"
    cd $argv
end

function C -d "Go up one directory"
    cd ..
end

function CC -d "Go up two directories"
    cd ../..
end

function home -d "Go to home directory"
    cd ~
end

function mkcd -d "Create a directory and enter it"
    if test (count $argv) -eq 0
        echo "Usage: mkcd <directory>"
        return 1
    end
    mkdir -p $argv[1]; and cd $argv[1]
end

function cfg -d "Jump into a config directory"
    if test (count $argv) -eq 0
        cd $HOME/.config
    else
        cd $HOME/.config/$argv[1]
    end
end

abbr -a .. "cd .."
abbr -a ... "cd ../.."
abbr -a .... "cd ../../.."

# ---------------------------- Files --------------------------
function ls -d "List files with icons"
    command eza --icons --group-directories-first $argv
end

function ll -d "List files with details"
    command eza -lh --icons --group-directories-first $argv
end

function la -d "List all files with details"
    command eza -lah --icons --group-directories-first $argv
end

function lt -d "List files as a tree"
    command eza --tree --level=2 --icons --group-directories-first $argv
end

if type -q bat
    function cat -d "Cat with syntax highlighting"
        command bat --style=plain $argv
    end
end

function grep -d "Grep with colors"
    command grep --color=auto $argv
end

function rm -d "Remove with confirmation"
    command rm -Iv $argv
end

function mv -d "Move with confirmation"
    command mv -iv $argv
end

function cp -d "Copy with confirmation"
    command cp -iv $argv
end

function df -d "Disk usage, human readable"
    command df -h $argv
end

function du -d "File sizes with total"
    command du -h -c $argv
end

function extract -d "Extract any archive"
    if test (count $argv) -eq 0
        echo "Usage: extract <archive>"
        return 1
    end

    set -l file $argv[1]

    switch $file
        case '*.tar.bz2' '*.tbz2'
            tar xvjf "$file"
        case '*.tar.gz' '*.tgz'
            tar xvzf "$file"
        case '*.tar.xz' '*.txz'
            tar xJf "$file"
        case '*.tar.zst'
            tar --zstd -xvf "$file"
        case '*.bz2'
            bunzip2 "$file"
        case '*.xz'
            unxz "$file"
        case '*.zst'
            unzstd "$file"
        case '*.rar'
            unrar x "$file"
        case '*.gz'
            gunzip "$file"
        case '*.tar'
            tar xvf "$file"
        case '*.zip'
            unzip "$file"
        case '*.Z'
            uncompress "$file"
        case '*.7z'
            7z x "$file"
        case -r '.*\.(exe|EXE|fd|FD|bin|BIN)$'
            7z x "$file"
        case '*'
            echo "extract: don't know how to handle '$file'"
            return 1
    end
end

function save -d "Save command output to a file"
    if test (count $argv) -lt 2
        echo "Usage: save <filename> <command> [args...]"
        return 1
    end

    set -l filename $argv[1]
    $argv[2..-1] | tee "$HOME/$filename"
end

function ports -d "Show listening TCP/UDP ports"
    command ss -tulpn
end

function serve -d "Serve current directory over HTTP"
    set -l port 8000
    if test (count $argv) -ge 1
        set port $argv[1]
    end
    if type -q python3
        python3 -m http.server $port
    else
        echo "serve: python3 not found"
        return 127
    end
end

function mdp -d "Preview a Markdown file in the terminal"
    if test (count $argv) -eq 0
        echo "Usage: mdp <file.md>"
        return 1
    end
    if not test -f $argv[1]
        echo "mdp: not a file: $argv[1]"
        return 1
    end
    python3 -m rich.markdown $argv[1]
end

# ---------------------------- Packages -----------------------
function i -d "Install packages"
    sudo dnf install -y $argv
end

function s -d "Search packages"
    sudo dnf search $argv
end

function nuke -d "Remove packages"
    sudo dnf remove -y $argv
end

function update -d "Upgrade all packages"
    sudo dnf upgrade --refresh -y
end

function search -d "Search packages"
    dnf search $argv
end

function info -d "Show package info"
    dnf info $argv
end

function autoremove -d "Remove unused dependencies"
    sudo dnf autoremove -y
end

function clean -d "Clean package cache"
    sudo dnf clean all
end

# ---------------------------- Git ----------------------------
function gs -d "Git status"
    git status
end

function gst -d "Git short status"
    git status --short
end

function ga -d "Git add"
    git add $argv
end

function gc -d "Git commit with message"
    git commit -m "$argv"
end

function gp -d "Git push"
    git push $argv
end

function gl -d "Git log graph"
    git log --oneline --graph --decorate --all
end

function gd -d "Git diff"
    git diff $argv
end

function gco -d "Git checkout"
    git checkout $argv
end

function gsw -d "Git switch"
    git switch $argv
end

function cl -d "Git clone"
    git clone $argv
end

function pull -d "Git pull"
    git pull
end

# ---------------------------- System -------------------------
function run -d "Auto chmod and run files or commands"
    if test (count $argv) -eq 0
        echo "Usage: run <file-or-command> [args...]"
        return 1
    end

    set -l target $argv[1]
    set -l args $argv[2..-1]

    if test -e "$target"
        if not test -x "$target"
            chmod +x "$target"
        end
        "$target" $args
        return
    end

    if type -q "$target"
        command "$target" $args
        return
    end

    echo "run: '$target' not found"
    return 127
end

function lid -d "Configure laptop lid behavior"
    if test (count $argv) -ne 1
        echo "Usage: lid <ignore|suspend|hibernate|poweroff>"
        return 1
    end

    set -l action $argv[1]

    switch $action
        case ignore suspend hibernate poweroff
            # valid
        case '*'
            echo "Invalid action: $action"
            echo "Valid actions: ignore suspend hibernate poweroff"
            return 1
    end

    sudo mkdir -p /etc/systemd/logind.conf.d

    printf "[Login]\nHandleLidSwitch=%s\nHandleLidSwitchExternalPower=%s\nHandleLidSwitchDocked=%s\n" \
        $action $action $action \
        | sudo tee /etc/systemd/logind.conf.d/lid.conf >/dev/null

    echo
    echo "Current configuration:"
    cat /etc/systemd/logind.conf.d/lid.conf
    echo

    read -P "Restart logind now? (y/N): " answer

    if test "$answer" = y -o "$answer" = Y
        echo "Restarting logind..."
        sudo systemctl restart systemd-logind
    else
        echo "Reboot later for the change to take effect."
    end
end

function cls -d "Clear the screen"
    clear
end

function p -d "Power off"
    poweroff
end

function r -d "Reboot"
    reboot
end

function show -d "Show an image in the terminal"
    kitty +kitten icat $argv
end

# ---------------------------- Fun ----------------------------
function coin -d "Flip a coin"
    shuf -n 1 -e Heads Tails
end

# ---------------------------- Config helpers -----------------
function fishy -d "Edit fish config"
    nvim $HOME/.config/fish/config.fish
end

function nvimy -d "Edit nvim config"
    nvim $HOME/.config/nvim/init.lua
end

function reload -d "Reload fish config"
    source $HOME/.config/fish/config.fish
end

# ---------------------------- Aliases ------------------------
function vencord -d "Install Vencord"
    sh -c "$(curl -sS https://vencord.dev/install.sh)"
end

function x -d "Exit the shell"
    exit
end
