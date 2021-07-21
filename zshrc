autoload -Uz compinit && compinit # Autocomplete

bindkey -e # emacs mode, allows ctrl+a ctrl+e to go to the start/end of the line

PROMPT='%m:%1d %(?.$.%F{red}$%f) '
RPROMPT='$GITSTATUS_PROMPT'  # Show git information on the right side :)
