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
if [ -z ${ANDROID_SDK_ROOT+x} ]; then
  export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
  export PATH=$ANDROID_SDK_ROOT/emulator:$PATH
  export PATH=$ANDROID_SDK_ROOT/tools:$PATH
  export PATH=$ANDROID_SDK_ROOT/tools/bin:$PATH
  export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
  export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH
fi

