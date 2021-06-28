autoload -Uz compinit && compinit # Autocomplete

PROMPT='%m:%~ %(?.$.%F{red}$%f) '
RPROMPT='$GITSTATUS_PROMPT'  # Show git information on the right side :)