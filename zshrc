bindkey -e # emacs mode, allows ctrl+a ctrl+e to go to the start/end of the line

# Git status in prompt (brew install romkatv/gitstatus/gitstatus)
source $(brew --prefix)/opt/gitstatus/gitstatus.prompt.zsh
PROMPT='%m:%1d %(?.$.%F{red}$%f) '
RPROMPT='$GITSTATUS_PROMPT'  # Show git information on the right side :)

# ZSH advanced completion :)
source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

alias vram_usage='output=$(ioreg -c "AGXAccelerator" | grep "PerformanceStatistics"); [[ $output =~ "In use system memory\"=([0-9]*)" ]] && print $(($match[1] / 1024 / 1024))MB'

function watcha {
  watch $(alias "$@" | cut -d\' -f2)
}

# Setup autin
eval "$(atuin init zsh)"
