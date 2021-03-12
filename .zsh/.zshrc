#! zsh

# startup script order:
#       /etc/zshenv                     (always)
#       $ZDOTDIR/.zshenv    RCS
#       /etc/zprofile       GLOBAL_RCS   login
#       $ZDOTDIR/.zprofile  RCS          login
#       /etc/zshrc          GLOBAL_RCS   interactive
#       $ZDOTDIR/.zshrc     RCS          interactive
#       /etc/zlogin         GLOBAL_RCS   login
#       $ZDOTDIR/.zlogin    RCS          login 
# exit script order:
#       $ZDOTDIR/.zlogout   RCS          login
#       /etc/zlogout        GLOBAL_RCS   login
# Note any of these files can be compiled using `zcompile`. Name appended
# with .zwc (e.g. .zshlogin.zwc, I suppose)

# run Zsh configuration questionnaire:
#       `autoload -U zsh-newuser-install && zsh-newuser-install -f`
# completions configuration questionnaire:
#       `autoload -Uz compinstall && compinstall`

fpath=(~/.zsh/functions $fpath)

autoload -Uz add-zsh-hook  # && add-zsh-hook (not required; dunno why not)
# zsh-async https://github.com/mafredri/zsh-async
autoload -Uz async && async

source $ZDOTDIR/opt/zsh-functional/functional.plugin.zsh
source $ZDOTDIR/startup/basic.zsh
source $ZDOTDIR/startup/identify-machine.zsh

source $ZDOTDIR/startup/set-path.zsh

# -- end general initializaiton ----------------------------------------------

# == compinstall did this ====================================================
# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _oldlist _expand _complete _ignored _match _prefix
zstyle ':completion:*' completions 1
zstyle ':completion:*' format 'completing %d'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' match-original both
zstyle ':completion:*' matcher-list '+' '+r:|[._-]=* r:|=*'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=2
zstyle ':completion:*' original true
zstyle ':completion:*' prompt 'correcting %e>'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle :compinstall filename '/Users/davidhand/.zshrc'

autoload -Uz compinit && compinit
# -- end compinstall ---------------------------------------------------------
# == zsh-newuser-install =====================================================
setopt AUTO_CD BEEP EXTENDED_GLOB NOMATCH
bindkey -v
# -- end zsh-newuser-install -------------------------------------------------

# run-help command provides documentation on builtins and such
unalias run-help && autoload run-help

# use completion system to handle expansion. Works with the _expand completer,
#  above. See zshcompsys(1)
# (by default, '^I' is bound to expand-or-complete)
bindkey '^I' complete-word
# allow shift-tab to be used to go backwards in a completion menu
bindkey '^[[Z' reverse-menu-complete

# allow zsh to correct command names
setopt CORRECT
# but stop suggesting the autocompletion functions for missing commands
CORRECT_IGNORE='_*'
# there's also a CORRECT_IGNORE_FILE parameter that does something similar

# I like using # in interactive shells
setopt INTERACTIVE_COMMENTS

# history
HISTFILE=~/.zsh/history
HISTSIZE=10000
SAVEHIST=100000
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
# still unsure whether I want this or just APPEND_HISTORY
setopt INC_APPEND_HISTORY_TIME

# So ^D won't kill a terminal window
setopt IGNORE_EOF

#zstyle :completion::complete:git-checkout:argument-rest:headrefs command "git for-each-ref --format='%(refname)' refs/heads 2>/dev/null"

zstyle :completion::complete:git-checkout:argument-rest:headrefs command "echo yourmom"

# === Raku ==================================================================
export RAKUBREW_HOME="$HOME/.raku/rakubrew"
if [[ -x $HOME/.raku/rakubrew/bin/rakubrew ]]; then
    eval "$($HOME/.raku/rakubrew/bin/rakubrew init Zsh)"
fi

# === Perl ==================================================================
ptolemarch_perl5_root="$HOME/.perl5"
export PLENV_ROOT="$ptolemarch_perl5_root/plenv"
# documenting this here because not sure where else
# plenv install 5.32.0 --as=teapot --test -j 8 -Doptimize=-O3 -Dlocincpth=/usr/local/include -Dloclibpth=/usr/local/lib

if [[ -d $ptolemarch_perl5_root/minicpan ]]; then
    ptolemarch_cpanm_cpan_mirror="file://$ptolemarch_perl5_root/minicpan/"
    export PERL_CPANM_OPT="--mirror $ptolemarch_cpanm_cpan_mirror --mirror-only"
fi
export PERL_CPANM_HOME="$ptolemarch_perl5_root/cpanm"

if ! [[ -n $ptolemarch_HOST_perceptyx_jail ]]; then
    # initialize plenv, but only if we're NOT on perceptyx jail
    #  (which uses perlbrew)
    eval "$(plenv init - zsh)"
fi

# == rlwrap (readline command wrapper) =======================================
export RLWRAP_HOME="$HOME/.rlwrap"

# === aliases ===============================================================
source $ZDOTDIR/startup/aliases.zsh

# vim: ts=4 sw=4 et ai
