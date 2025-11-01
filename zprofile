# Setup homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Number of CPU cores (used for pow config)
export CORES=`sysctl hw.physicalcpu | awk '{print $2}'`

# Use Neovim as the default editor
export EDITOR="nvim"

# Do not display postgres info unless it is a warning or error.
export PGOPTIONS='-c client_min_messages=WARNING'

# Setup Mise
export PATH="$HOME/.local/bin:$PATH"
if (( $+commands[mise] )); then
  eval "$(mise activate zsh --shims)"
fi

# Load additional zprofile configs!
zprofile_configs=( $HOME/.zprofile.*(N) )
if (( ${#zprofile_configs[@]} > 0 )); then
  for file in "${zprofile_configs[@]}"; do
    source "$file"
  done
fi

