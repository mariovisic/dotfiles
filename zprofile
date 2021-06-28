export PATH="/opt/homebrew/bin:$PATH"

# Number of CPU cores (used for pow config)
export CORES=`sysctl hw.physicalcpu | awk '{print $2}'`

# Default Editor (yay mac vim)
export EDITOR="vim"

# Do not display postgres info unless it is a warning or error.
export PGOPTIONS='-c client_min_messages=WARNING'

# asdf Setup (brew install asdf)
source $(brew --prefix asdf)/asdf.sh

# Git status in prompt (brew install romkatv/gitstatus/gitstatus)
source $(brew --prefix)/opt/gitstatus/gitstatus.prompt.zsh

# Source the zsh config
source ~/.zshrc