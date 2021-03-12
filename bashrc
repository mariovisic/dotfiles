        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${RED}\$${COLOR_NONE}"
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  LAST_EXIT_STATUS=$?
  update_terminal_cwd 2> /dev/null

  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $LAST_EXIT_STATUS

  # Set the bash prompt variable.
  PS1="\h:\w ${GITSTATUS_PROMPT}${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'set_bash_prompt'
