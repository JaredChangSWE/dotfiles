# Environment initialization
# Set function nesting limit to prevent recursion issues
export FUNCNEST=500

# Homebrew initialization
[[ ! -f /opt/homebrew/bin/brew ]] || eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(zoxide init zsh)"

# Key bindings
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word

# Warp terminal integration
printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh"}}\x9c'