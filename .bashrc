# ~/.bashrc: executed by bash(1) for interactve, non-login shells.
#   (also sourced at the beginning of my .profile)

# BASH_ENV is used to initialize non-interactive shells
BASH_ENV=~/.bashenv

# If not running interactively, don't do anything
# This is less ridiculous than it seemed to me at first:
#   - this file is sourced by ~/.profile
#   - ~/.profile is executed when "bash is invoked as an interactive login
#     shell, or as a non-interactive shell with the --login option
case $- in
    *i*) ;;
      *) return;;
esac

# I should remember to do various useful things with stty(1)
# AND NOW I HAVE
stty \
    stop undef \
    start undef

# I want to run this on work machines,
#   BUT NOT HERE AT HOME:
#ssh-add -L | perl -anE '$F[2] =~ s{^.*/.ssh/}{$ENV{HOME}/.ssh/}; $FH=">$F[2].pub"; open FH or die; $,=" "; say FH @F; close FH or die'

# functions I might use here
# see end of .bashrc for .aliases
if [[ -f ~/.functions ]]; then
    source ~/.functions
fi

# == paths ===================================================================
export PATH="\
$HOME/bin\
:$HOME/.rakudobrew/bin\
:$HOME/bin/work\
:/opt/kubernetes/platforms/linux/amd64\
:/opt/android-sdk-update-manager/tools\
:/opt/android-sdk-update-manager/platform-tools\
:/usr/local/bin\
:/usr/local/sbin\
:/usr/games/bin\
:/opt/X11/bin\
:/usr/X11/bin\
:/usr/bin\
:/usr/sbin\
:/bin\
:/sbin\
"
#:$HOME/.../bin\

# seems to do more harm than good on OSX
#export MANPATH="\
#$HOME/share/man\
#:/usr/local/share/man\
#:/usr/games/man\
#:/opt/X11/share/man\
#:/usr/X11/man\
#:/usr/share/man\
#"

export INFOPATH="\
$HOME/share/info\
:/usr/local/share/info\
:/usr/games/info\
:/usr/X11/info\
:/usr/share/info\
"

export LIBRARY_PATH="\
$HOME/lib\
:/usr/local/lib\
:/usr/games/lib\
"

export INCLUDE="\
$HOME/include\
:/usr/local/include\
:/usr/games/include\
"
export CPATH="$INCLUDE"

# == mail ====================================================================
MAILCHECK=10
newmail="\e[97;41mNEW MAIL\e[m"
MAILPATH="\
~/Mail/_INCOMING?$newmail (main):\
~/Mail/IN-S-pm_to?$newmail (ThousandOaks.pm):\
~/Mail/IN-S-pm_la?$newmail (LosAngeles.pm):\
~/Mail/IN-O-cpan?$newmail (CPAN):\
~/Mail/IN-O-sigh?$newmail (DreamHost alternate):\
~/Mail/IN-O-webmaster?$newmail (webmaster):\
~/Mail/IN-O-wow?$newmail (World of Warcraft)\
"

MAIL=~/Mail/_INCOMING
MAILREADER='/usr/local/bin/mutt'
export MAIL MAILREADER

EMAIL='davidhand@davidhand.com'
REPLYTO='davidhand@davidhand.com'
PGPPATH="$HOME/.gnupg"
export EMAIL REPLYTO PGPPATH

# == configuration for Bash itself ===========================================

shopt -u dotglob  # don't include dotfiles in pathname expansion
shopt -s globstar # ** matches through subdirectories
shopt -s extglob  # turn on extended pattern matching 
am_case_sensitive || shopt -s nocaseglob # on a case-insensitive system

# filename completion ignore list
FIGNORE='.*.sw?:*~:#*#:.o:.class:.:.c.html:.java.html:.html.html:.DB_Store:._:CVS:.svn'
GLOBIGNORE="$FIGNORE"

# \e[36m : cyan (Theophany)
# TODO: for dhand, 33m (orange)
PS1='\[\e[36m\]\D{%k;%M,%S} \W \$\[\e[m\] '
PS2='\[\e[36m\]\D{%k;%M,%S} >\[\e[m\] '

#PROMPT_COMMAND=__ptolemarch_prompt_command

HISTSIZE=10000  # why the hell not
HISTIGNORE='&:##*:*(k):cd:exit:ls:ll:la:lal:uptime:from:frm:fm:fm;tfm:tfm:fmq:fmq;efm:efm:mutt:finger:users:clear:date:sb:dh.c'
HISTFILE=~/.history
shopt -s histappend  # append history; don't overwrite

# ^D doesn't log you out (unless you do it 50 times in a row)
IGNOREEOF=50

# == color ===================================================================
# I think CLICOLOR is/was used in OS X?  Otherwise not sure why I have this.
export CLICOLOR='yessir'  # ls and such

if type dircolors > /dev/null 2>&1 ; then
        [[ -r ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# == general options =========================================================
## Locale stuff that perl wants set
#LANG='en_US.UTF-8'
#export LANG

EDITOR='vim'
VISUAL="$EDITOR"
PAGER='less'
LESS='-R'
HACKPAGER='less'  # for nethack
#MANPAGER='manpager'
export EDITOR VISUAL PAGER LESS HACKPAGER #MANPAGER

GTK_IM_MODULE='xim' 
export GTK_IM_MODULE

HUGSFLAGS='-E"vim +%d %s"'
export HUGSFLAGS

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# == development =============================================================

# from homebrew: The OpenSSL provided by OS X is too old for some software.
#
# Generally there are no consequences of this for you. If you build your
# own software and it requires this formula, you'll need to add to your
# build variables:
# LDFLAGS:  -L/usr/local/opt/openssl/lib
# CPPFLAGS: -I/usr/local/opt/openssl/include

# == Homebrew ================================================================
if type -p brew > /dev/null 2>&1; then
    homebrew_present="yes";
    homebrew_prefix="$(brew --prefix)"

    # allows hitting the GitHub API way harder, 'cuz signed-in
    export HOMEBREW_GITHUB_API_TOKEN=91d3c97f56952a4e4dd7de62b60c19d5196201c5

    # otherwise it's /opt/homebrew-cask/Caskroom ?!?
    export HOMEBREW_CASK_OPTS="--caskroom=$homebrew_prefix/Caskroom"
fi

# bash completion
if [ -v homebrew_prefix ]; then
    brew_bash_cmpl="$homebrew_prefix/share/bash-completion/bash_completion"
    if [ -f "$brew_bash_cmpl" ]; then
        source "$brew_bash_cmpl"
    fi
fi

# == Perlbrew & MiniCPAN =====================================================
#PERLBREW_CONFIGURE_FLAGS='-Duse64bitall -Dusethreads -Duseshrplib -Dlocincpth=/usr/local/include -Dloclibpth=/usr/local/lib -des'
#PERLBREW_CONFIGURE_FLAGS='-Duse64bitall -Duseshrplib -Dlocincpth=/usr/local/include -Dloclibpth=/usr/local/lib -des'
_pb_mc_parent="$HOME/.perl5"
PERLBREW_CPAN_MIRROR="http://ftp.wayne.edu/CPAN/"
PERLBREW_ROOT="$_pb_mc_parent/perlbrew"
PERLBREW_HOME="$PERLBREW_ROOT"
[[ -s "$PERLBREW_ROOT/etc/bashrc" ]] && source "$PERLBREW_ROOT/etc/bashrc"
export PERLBREW_CONFIGURE_FLAGS PERLBREW_ROOT PERLBREW_HOME PERLBREW_CPAN_MIRROR

minicpan_root="$_pb_mc_parent/minicpan"
cpanm_cpan_mirror="file://$minicpan_root/"
export PERL_CPANM_OPT="--mirror $cpanm_cpan_mirror --mirror-only"
# also there's an alias (in ~/.aliases) so cpan-outdated respects the
#   $cpanm_cpan_mirror

# == Rakudobrew ==============================================================
# for now, Gentoo seems to be tracking Rakudo quite nicely
# but maybe I'll play with rakudobrew some more
if [[ -e ~/.rakudobrew/bin/rakudobrew ]]; then
    eval "$(~/.rakudobrew/bin/rakudobrew init -)"
fi

# == git-hub (by Ingy döt Net) ===============================================
#[[ -s ~/Code/_/git-hub/init ]] && source ~/Code/_/git-hub/init

# == rlwrap (readline command wrapper) =======================================
export RLWRAP_HOME="$HOME/.rlwrap"

# == Android SDK Update Manager ==============================================
export ANDROID_SWT='/usr/share/swt-3.7/lib'

# == aliases =================================================================
if [[ -f ~/.aliases ]]; then
    source ~/.aliases
fi

# == command completion ======================================================
# (straight from Ubuntu's .bashrc)
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
