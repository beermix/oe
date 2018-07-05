## if the init scipt doesn't exist
#if ! zgen saved; then
#
#  # specify plugins here
#  zgen oh-my-zsh
#
#  # generate the init script from plugins above
#  zgen save
#fi
# Path to your oh-my-zsh installation.

export ZSH=/root/.oh-my-zsh
DISABLE_UPDATE_PROMPT=true

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

#ZSH_THEME="norm"

#ZSH_THEME="geoffgarside"
#ZSH_THEME="jnrowe"
#ZSH_THEME="kafeitu"
#ZSH_THEME="miloshadzic"
#ZSH_THEME="nicoulaj"
#ZSH_THEME="tonotdo"
#ZSH_THEME="muse"
ZSH_THEME="muse"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

#export LS_COLORS='*.swp=-1;44;37:*,v=5;34;93:*.vim=35:no=0:fi=0:di=32:ln=36:or=1;40:mi=1;40:pi=31:so=33:bd=44;37:cd=44;37:*.jpg=1;32:*.jpeg=1;32:*.JPG=1;32:*.gif=1;32:*.png=1;32:*.jpeg=1;32:*.ppm=1;32:*.pgm=1;32:*.pbm=1;32:*.c=1;32:*.C=1;33:*.h=1;33:*.cc=1;33:*.awk=1;33:*.pl=1;33:*.gz=0;33:*.tar=0;33:*.zip=0;33:*.lha=0;33:*.lzh=0;33:*.arj=0;33:*.bz2=0;33:*.tgz=0;33:*.taz=33:*.html=36:*.htm=1;34:*.doc=1;34:*.txt=1;34:*.o=1;36:*.a=1;36'
#export ZLS_COLORS='*.swp=00;44;37:*,v=5;34;93:*.vim=35:no=0:fi=0:di=32:ln=36:or=1;40:mi=1;40:pi=31:so=33:bd=44;37:cd=44;37:*.jpg=1;32:*.jpeg=1;32:*.JPG=1;32:*.gif=1;32:*.png=1;32:*.jpeg=1;32:*.ppm=1;32:*.pgm=1;32:*.pbm=1;32:*.c=1;32:*.C=1;33:*.h=1;33:*.cc=1;33:*.awk=1;33:*.pl=1;33:*.gz=0;33:*.tar=0;33:*.zip=0;33:*.lha=0;33:*.lzh=0;33:*.arj=0;33:*.bz2=0;33:*.tgz=0;33:*.taz=33:*.html=36:*.htm=1;34:*.doc=1;34:*.txt=1;34:*.o=1;36:*.a=1;36'
export CLICOLOR=1       # some shells need this to enable colorized out
export GREP_COLOR=32    # some greps have colorized ouput. enable...
export GREPCOLOR=32     # dito here
PROMPT=$'[%{\e[1;37m%}%n%{\e[0m%}]%# '
RPROMPT=$'[%m : %~]'
autoload -U colors && colors
#autoload -U zmv




#bindkey '\e[A' history-search-backward
#bindkey '\e[B' history-search-forward
bindkey '^K' kill-whole-line
bindkey "\e[H" beginning-of-line        # Home (xorg)
bindkey "\e[1~" beginning-of-line       # Home (console)
bindkey "\e[4~" end-of-line             # End (console)
bindkey "\e[F" end-of-line              # End (xorg)
bindkey "\e[2~" overwrite-mode          # Ins
bindkey "\e[3~" delete-char             # Delete
bindkey '\eOH' beginning-of-line
bindkey '\eOF' end-of-line

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git history zsh-syntax-highlighting-filetypes zsh-syntax-highlighting-filetypes zsh-history-substring-search zsh-256color)

# User configuration

export PATH="/root/go/bin:$PATH:/root/.bin:/root/.binm:/root/.go/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export EDITOR=/bin/nano
export TERM=xterm-256color

alias a2='aria2c --file-allocation=none --max-connection-per-server=8'
alias aa='apt-get install'
alias abd='apt-get build-dep'
alias ad='apt-get build-dep'
alias afind='ack -il'
alias ai='autoreconf --verbose --install --force -I m4'
alias ar='apt-get -y install'
alias asc='apt-cache search'
alias asf='apt-file find'
alias boot='systemd-analyze blame'
alias bd1='CONCURRENCY_MAKE_LEVEL=1 ./scripts/build'
alias build='./scripts/build'
alias create1='CONCURRENCY_MAKE_LEVEL=1  ./scripts/create_addon'
alias create='./scripts/create_addon'
alias bw='bwm-ng'
alias c='cat'
alias cg='./configure --help | grep'
alias clean='./scripts/clean'
alias clou='nohup cloud &'
alias cp='cp -r -i'
alias cusocks='curl --socks5-hostname'
alias d='docker'
alias da='docker ps -a'
alias ddb='dnf builddep'
alias ddd='dnf download'
alias ddi='dnf install'
alias ddr='dnf remove'
alias dds='dnf search'
alias ddu='dnf update -y'
alias dli='dnf list installed | grep'
alias dost='docker stats $(docker ps --format {{.Names}})'
alias e='exit'
alias f='find / -name'
alias fl='find . -name'
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gb='git branch'
alias gba='git branch -a'
alias gbda='git branch --merged | command grep -vE "^(\*|\s*master\s*$)" | command xargs -n 1 git branch -d'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'
alias gc='git checkout'
alias gca='git commit -v -a'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gcl='git clone --recursive'
alias gcl1='git clone --recursive --depth 1'
alias gclean='git clean -fd'
alias gcm='git checkout master'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcs='git commit -S'
alias gd='git diff'
alias gdca='git diff --cached'
alias gdct='git describe --tags `git rev-list --tags --max-count=1`'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'
alias getsync='aria2c http://download-new.utorrent.com/endpoint/btsync/os/linux-x64/track/stable;tt bittorrent_sync_x64.tar.gz;rm bittorrent_sync_x64.tar.gz;rm LICENSE.TXT;rm README'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'
alias gga='git gui citool --amend'
alias gget='go get -u -v'
alias gget2='go get -u -t -v'
alias ggpull='git pull origin $(git_current_branch)'
alias ggpush='git push origin $(git_current_branch)'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
alias gk='gitk --all --branches'
alias gke='gitk --all $(git log -g --pretty=format:%h)'
alias gl='git pull'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat -p'
alias glo0='git log --oneline --all --graph --decorate'
alias glo='git log -p -2'
alias glo2='git log -p -10'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit'
alias glola='git log --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit --all'
alias glp='_git_log_prettily'
alias glum='git pull upstream master'
alias gm='git merge'
alias gmom='git merge origin/master'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/master'
alias gog='go get -u'
alias gogo='export GOPATH=/root/.go'
alias gp='git pull'
alias gpd='git push --dry-run'
alias gpoat='git push origin --all && git push origin --tags'
alias gpristine='git reset --hard && git clean -dfx'
alias gpu='git push upstream'
alias gpv='git push -v'
alias gr='git reset --hard'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias grgp='git reset --hard && git clean -dfx && git pull'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grmv='git remote rename'
#alias grr='git reset --hard && git clean -dfx && git pull'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'
alias gsb='git status -sb'
alias gsd='git svn dcommit'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status -s'
alias gst='git status'
alias gsta='git stash'
alias gstaa='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gsu='git submodule update'
alias gts='git tag -s'
alias gtv='git tag | sort -V'
alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "--wip--"'
alias h=history
alias hig='history | grep'
alias hh='history | grep'
alias his=history
alias history='fc -il 1'
alias hsi='hs -i'
alias ht='htop'
alias ip='curl ifconfig.co'
alias ip2='curl http://wtfismyip.com/json'
alias iptest='while :; do nc -l -p 4242 > /dev/null;0:51 23.01.2016one'
alias l='l -lah'
alias la='ls -lAh'
alias ll='lnav'
alias llj='journalctl -xef'
alias logup='cat ~/.kodi/temp/kodi.log | pastebinit'
alias ls='ls --color=tty'
alias lsa='ls -lah'
alias mac='openssl rand -hex 6 | sed '\''s/\(..\)/\1:/g; s/.$//'\'
alias md='mkdir -p'
alias mk='rm -rf /root/.ccache-openelec/ && PROJECT=Generic ARCH=x86_64 make'
alias mkdir='mkdir -p'
alias mm='make menuconfig'
alias moow='sshfs root@192.168.1.1:/ /storage/..OWrt -o password_stdin <~/passwd.txt'
alias mowat='sshfs root@185.86.78.154:/ /storage/..Wat -o password_stdin <~/passwd.txt'
alias ms='make kernel_menuconfig -j4 V=s'
alias mv='mv -fv'
alias n=nano
alias ng='netstat -nap | grep'
alias pg='netstat -antup | grep'
alias pipi='pip install'
alias pipu='pip uninstall'
alias pipup='pip freeze --local | grep -v ^-e | cut -d = -f 1  | xargs pip install -U'
alias please=sudo
alias po=popd
alias pog='ports | grep'
alias pon='export http_proxy="http://192.168.1.4:777"'
alias ports='netstat -antup'
alias pp='lsof -i TCP| fgrep LISTEN'
alias pu=pushd
alias pw='ping 185.86.78.154'
alias pyfind='find . -name "*.py"'
alias pygrep='grep --include="*.py"'
alias rd=rmdir
alias reb='shutdown -r 0'
alias rm='rm -rf'
alias rmpyc='/usr/bin/find . -name "*.pyc" -exec rm -rf {} \;' # /usr/bin/find . -type f -exec strip -s {} \;
alias rpyo='/usr/bin/find . -name "*.pyo" -exec rm -rf {} \;'
alias rr='systemctl restart kodi'
alias rsync-copy='rsync -avz --progress -h'
alias rsync-move='rsync -avz --progress -h --remove-source-files'
alias rsync-synchronize='rsync -avzu --delete --progress -h'
alias rsync-update='rsync -avzu --progress -h'
alias s='systemctl'
alias s1='nuttcp -l8972 -T30 -u -w4m -Ri300m/100 -i1 wat.is.my'
alias s2='iperf3 -c wat.is.my && iperf3 -c wat.is.my -R'
alias s3='iperf3 -c wat.is.my'
alias scr='kodi-send --action="TakeScreenshot"'
alias smart='smartctl -a /dev/sdb'
alias sre='systemctl daemon-reload'
alias srup='pip install git+https://github.com/jrnewell/spotify-ripper'
alias start='systemctl start kodi'
alias stop='systemctl stop kodi'
alias sz='du -hs'
alias t='~/.bin/sensors.sh'
alias trim='time -c fstrim -a'
alias tt='tar xpvf'
alias unpack='./scripts/unpack'
alias up='sudo apt-get update && sudo apt-get upgrade -y'
alias uu='ulimit -n 51200'
alias vi='nano'
alias wh='which'
alias ww='/root/.git-webui/release/libexec/git-core/git-webui --port 80 --no-browser --host 192.168.1.200'
alias xxi='xx info'
alias xxu='xx upload'
alias xxm='xx move'
alias yr='yum remove'
alias yu='yum update'
alias yy='yum install'
alias ff='./scripts/feeds update -a; ./scripts/feeds install -a -d m'
alias zb1='docker exec -ti zabbix-db /zabbix-backup/zabbix-mariadb-dump -u zabbix -p ASDewq123 -o /backups'
alias zb2='docker exec -ti zabbix-db bash -c "mysqldump -u zabbix -pASDewq123 zabbix | bzip2 -cq9 > /backups/zabbix_db_dump_$(date +%Y-%m-%d-%H.%M.%S).sql.bz2"'
alias cmake-='cmake -LAH'
alias lsdir="for dir in *;do;if [ -d \$dir ];then;du -hsL \$dir;fi;done"
alias g='grep -Hrn'
alias vmclean='cd /;cat /dev/zero > zero.fill;sync;sleep 1;sync;rm -f zero.fill'
alias zsht="zsh -c 'trap time EXIT; : {1..3000000}'"
alias basht="bash -c 'trap times EXIT; : {1..3000000}'"
alias ss='ionice -c 3 nice -n 20 make V=s CONFIG_DEBUG_SECTION_MISMATCH=y 2>&1 | tee build.log'
alias m='make'
alias mkt6='CONCURRENCY_MAKE_LEVEL=6 ./scripts/build toolchain'
alias mkt5='CONCURRENCY_MAKE_LEVEL=5 ./scripts/build toolchain'
alias mkt='CONCURRENCY_MAKE_LEVEL=7 ./scripts/build toolchain'
alias del='scripts/uninstall'
alias upp='sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y'
alias ags='apt-get source'
alias rmcc='rm -rfv /root/-3SDC/-OE_MY/.ccache'
alias aab='dpkg-buildpackage -us -uc -i -b'
alias bb='PROJECT=Generic ARCH=x86_64 ./scripts/build'
alias bb1='CONCURRENCY_MAKE_LEVEL=1 PROJECT=Generic ARCH=x86_64 ./scripts/build'
alias bb2='CONCURRENCY_MAKE_LEVEL=2 PROJECT=Generic ARCH=x86_64 ./scripts/build'
alias bb3='CONCURRENCY_MAKE_LEVEL=3 PROJECT=Generic ARCH=x86_64 ./scripts/build'
alias bb4='CONCURRENCY_MAKE_LEVEL=4 PROJECT=Generic ARCH=x86_64 ./scripts/build'
alias bb5='CONCURRENCY_MAKE_LEVEL=5 PROJECT=Generic ARCH=x86_64 ./scripts/build'
alias bb6='CONCURRENCY_MAKE_LEVEL=6 PROJECT=Generic ARCH=x86_64 ./scripts/build'
alias ggg="git add -A .;git commit -m '\''autocommit on change'\'"
alias ggetb='go get -u -v -buildmode=exe -ldflags "-s -w"'
alias gofmt="docker run -ti --rm -v $(pwd):/home/developer/workspace jare/go-tools gofmt"
alias brup='git -C /root/.br/arch-community pull; git -C /root/.br/openadk pull; git -C /root/.br/buildroot pull; git -C /root/.br/Entware-ng pull; git -C /root/.br/Optware-ng pull; git -C /root/.br/arch-packages pull; git -C /root/.br/sabotage pull; git -C /root/.br/arch-devtools pull; git -C /root/.br/resolve-march-native pull; git -C /root/.br/cpuid2cpuflags pull; git -C /root/.br/abuild pull; git -C /root/.br/alpine-iso pull; git -C /root/.br/devtools-arch pull; git -C /root/.br/gentoo pull; git -C /root/.br/distcc pull; git -C /root/.br/aur-mirror pull; git -C /root/.br/arch-bootstrap pull; git -C /root/.br/crosstool-ng pull; git -C /root/.br/aports pull; git -C /root/.br/gonative pull'
alias fr='fakeroot debian/rules binary'
alias gg="git add -A .;git commit -m 'autocommit on change';git push -u origin master"
alias gg7="git add -A .;git commit -m 'autocommit on change';git push -u origin oe7"
alias gg8="git add -A .;git commit -m 'autocommit on change';git push -u origin oe8"
alias mc='TERM=xterm-256color mc -u'
alias rec='CCACHE_RECACHE=1'
alias dic='CCACHE_DISABLE=1'

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

alias l='ls -lah --color=auto'
export FORCE_UNSAFE_CONFIGURE=1
export MAKE_JOBS_UNSAFE=1
export GOPATH=/root/.go
export LC_ALL=en_US.UTF-8


bindkey -s '^T' 'exec TERM=xterm-256color mc --nosubshell'
#bindkey -s '^h' 'hig'
export HISTSIZE=2000
#export HISTFILE="$HOME/.zsh-history"

##########



autoload -U colors zsh-mime-setup select-word-style
colors          # colors
zsh-mime-setup  # run everything as if it's an executable
select-word-style bash # ctrl+w on words

##
# Vcs info
##
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats "%{$fg[yellow]%}%c%{$fg[green]%}%u%{$reset_color%} [%{$fg[blue]%}%b%{$reset_color%}] %{$fg[yellow]%}%s%{$reset_color%}:%r"
precmd() {  # run before each prompt
  vcs_info
}

##
# Prompt
##
setopt PROMPT_SUBST     # allow funky stuff in prompt
#color="blue"
if [ "$USER" = "root" ]; then
    color="red"         # root is red, user is blue
fi;
#prompt="%{$fg[$color]%}%n%{$reset_color%}@%U%{$fg[yellow]%}%m%{$reset_color%}%u %T %B%~%b "
#RPROMPT='${vim_mode} ${vcs_info_msg_0_}'

##
# Key bindings
##
# Lookup in /etc/termcap or /etc/terminfo else, you can get the right keycode
# by typing ^v and then type the key or key combination you want to use.
# "man zshzle" for the list of available actions
bindkey -e                      # emacs keybindings
bindkey '\e[1;5C' forward-word            # C-Right
bindkey '\e[1;5D' backward-word           # C-Left
bindkey '\e[2~'   overwrite-mode          # Insert
bindkey '\e[3~'   delete-char             # Del
bindkey '\e[5~'   history-search-backward # PgUp
bindkey '\e[6~'   history-search-forward  # PgDn
bindkey '^A'      beginning-of-line       # Home
bindkey '^D'      delete-char             # Del
bindkey '^E'      end-of-line             # End
bindkey '^R'      history-incremental-pattern-search-backward

##
# Completion
##
autoload -U compinit
compinit
zmodload -i zsh/complist        
setopt hash_list_all            # hash everything before completion
setopt completealiases          # complete alisases
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word    
setopt complete_in_word         # allow completion from within a word/phrase
#setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.

zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' cache-path ~/.zsh/cache              # cache path
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colorz !
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use

# sections completion !
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'\e[00;34m%d'
zstyle ':completion:*:messages' format $'\e[00;31m%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
users=(jvoisin root)           # because I don't care about others
zstyle ':completion:*' users $users

#generic completion with --help
compdef _gnu_generic gcc
#compdef _gnu_generic gdb

##
# Pushd
##
setopt auto_pushd               # make cd push old dir in dir stack
setopt pushd_ignore_dups        # no duplicates in dir stack
setopt pushd_silent             # no dir stack after pushd or popd
setopt pushd_to_home            # `pushd` = `pushd $HOME`
#
##
# History
##
HISTFILE=~/.zsh_history         # where to store zsh config
HISTSIZE=10024                   # big history
SAVEHIST=10024                   # big history
setopt append_history           # append

#setopt hist_ignore_all_dups     # no duplicate

#unsetopt hist_ignore_space      # ignore space prefixed commands
setopt hist_reduce_blanks       # trim blanks
#setopt hist_verify              # show before executing history commands
#setopt inc_append_history       # add commands as they are typed, don't wait until shell exit 
setopt share_history            # share hist between sessions
#setopt bang_hist                # !keyword

autoload -U colors
colors

source ~/.alias                 # aliases

export REPORTTIME=1 # display commands with execution time >= 3 seconds
#setopt xtrace

zmodload zsh/datetime
setopt promptsubst
PS4='+$EPOCHREALTIME %N:%i> '
alias p1='patch -Np1 <'
alias mm1='CONCURRENCY_MAKE_LEVEL=1 make'
alias mm2='CONCURRENCY_MAKE_LEVEL=2 make'
alias mm3='CONCURRENCY_MAKE_LEVEL=3 make'
alias mm4='CONCURRENCY_MAKE_LEVEL=4 make'
alias mm5='CONCURRENCY_MAKE_LEVEL=5 make'
alias mm6='CONCURRENCY_MAKE_LEVEL=6 make'
alias mm7='CONCURRENCY_MAKE_LEVEL=7 make'

alias tor="export http_proxy="http://192.168.1.4:9055";export https_proxy="http://192.168.1.4:9055""

export FORCE_UNSAFE_CONFIGURE=1
export CONFIG_DEBUG_SECTION_MISMATCH=y
#export DEB_BUILD_OPTIONS="nocheck dpkg-buildpackage"

source "${HOME}/.zgen/zgen.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export HISTSIZE=20000
#export HISTFILE="$HOME/.cache/.zsh-history"

autoload -U promptinit
promptinit

# press "ctrl-e d" to insert the actual date in the form yyyy-mm-dd
insert-datestamp() { LBUFFER+=${(%):-'%D{%Y-%m-%d}'}; }
zle -N insert-datestamp

#source ~/.zsh-powerline.sh
export NOTI_DEFAULT="pushbullet"
export NOTI_PUSHBULLET_TOK="o.7GV16UXFK0MyWUcg9itzDEcGuXzoeNEg"