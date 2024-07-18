# Setup homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Number of CPU cores (used for pow config)
export CORES=`sysctl hw.physicalcpu | awk '{print $2}'`

# Default Editor (yay mac vim)
export EDITOR="vim"

# Do not display postgres info unless it is a warning or error.
export PGOPTIONS='-c client_min_messages=WARNING'

# Git status in prompt (brew install romkatv/gitstatus/gitstatus)
source $(brew --prefix)/opt/gitstatus/gitstatus.prompt.zsh

# Setup Mise
eval "$(mise activate zsh --shims)"

# Ferocia specific android setup
if [ -z ${ANDROID_HOME+x} ]; then
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$ANDROID_HOME/emulator:$PATH
  export PATH=$ANDROID_HOME/tools:$PATH
  export PATH=$ANDROID_HOME/tools/bin:$PATH
  export PATH=$ANDROID_HOME/platform-tools:$PATH
  export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
fi

