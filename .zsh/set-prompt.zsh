#! zsh

# vim: ts=4 sw=4 et ai

# set prompt, programmatically

[[ -n $ptolemarch_INCLUDE_set_prompt__ ]] && return 0
ptolemarch_INCLUDE_set_prompt__=$(date +%s)

source $ZDOTDIR/basic.zsh
source $ZDOTDIR/identify-machine.zsh


