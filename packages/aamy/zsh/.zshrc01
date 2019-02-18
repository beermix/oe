	# Path to your oh-my-zsh installation.
export ZSH=/storage/.cache/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded. avit cloud crunch arrow
DISABLE_UPDATE_PROMPT=true


#ZSH_THEME="cypher" owrt
#ZSH_THEME="afowler"
#ZSH_THEME="sunaku"
#ZSH_THEME="tonotdo"
#ZSH_THEME="bira"
#ZSH_THEME="muse"
#ZSH_THEME="jnrowe"

#ZSH_THEME="awesomepanda"
ZSH_THEME="flazz"

DISABLE_UPDATE_PROMPT=true
export LS_COLORS='*.swp=-1;44;37:*,v=5;34;93:*.vim=35:no=0:fi=0:di=32:ln=36:or=1;40:mi=1;40:pi=31:so=33:bd=44;37:cd=44;37:*.jpg=1;32:*.jpeg=1;32:*.JPG=1;32:*.gif=1;32:*.png=1;32:*.jpeg=1;32:*.ppm=1;32:*.pgm=1;32:*.pbm=1;32:*.c=1;32:*.C=1;33:*.h=1;33:*.cc=1;33:*.awk=1;33:*.pl=1;33:*.gz=0;33:*.tar=0;33:*.zip=0;33:*.lha=0;33:*.lzh=0;33:*.arj=0;33:*.bz2=0;33:*.tgz=0;33:*.taz=33:*.html=36:*.htm=1;34:*.doc=1;34:*.txt=1;34:*.o=1;36:*.a=1;36'
export ZLS_COLORS='*.swp=00;44;37:*,v=5;34;93:*.vim=35:no=0:fi=0:di=32:ln=36:or=1;40:mi=1;40:pi=31:so=33:bd=44;37:cd=44;37:*.jpg=1;32:*.jpeg=1;32:*.JPG=1;32:*.gif=1;32:*.png=1;32:*.jpeg=1;32:*.ppm=1;32:*.pgm=1;32:*.pbm=1;32:*.c=1;32:*.C=1;33:*.h=1;33:*.cc=1;33:*.awk=1;33:*.pl=1;33:*.gz=0;33:*.tar=0;33:*.zip=0;33:*.lha=0;33:*.lzh=0;33:*.arj=0;33:*.bz2=0;33:*.tgz=0;33:*.taz=33:*.html=36:*.htm=1;34:*.doc=1;34:*.txt=1;34:*.o=1;36:*.a=1;36'
export CLICOLOR=1       # some shells need this to enable colorized out
export GREP_COLOR=32    # some greps have colorized ouput. enable...
export GREPCOLOR=32     # dito here
PROMPT=$'[%{\e[1;37m%}%n%{\e[0m%}]%# '
#RPROMPT=$'[%m : %~]'
autoload -U colors && colors
autoload -U zmv

#setopt    GLOB
setopt    EXTENDED_HISTORY
setopt    INC_APPEND_HISTORY
setopt    SHARE_HISTORY
setopt    HIST_IGNORE_DUPS
setopt    HIST_FIND_NO_DUPS
setopt    HIST_IGNORE_SPACE
setopt    HIST_VERIFY
setopt    NO_HIST_BEEP
setopt    NO_BEEP
setopt    NO_HUP
autoload -Uz bracketed-paste-magic
autoload -U zutil
autoload -U compinit


bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey '^K' kill-whole-line
bindkey "\e[H" beginning-of-line        # Home (xorg)
bindkey "\e[1~" beginning-of-line       # Home (console)
bindkey "\e[4~" end-of-line             # End (console)
bindkey "\e[F" end-of-line              # End (xorg)
bindkey "\e[2~" overwrite-mode          # Ins
bindkey "\e[3~" delete-char             # Delete
bindkey '\eOH' beginning-of-line
bindkey '\eOF' end-of-line

# Activation
# compinit

# Resource files
#for file in $HOME/.zsh/rc/*.rc; do
#	source $file
#done

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=6

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
#DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
#ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker history rsync python)
export PATH="$PATH:/opt/bin"
# User configuration
export PATH="$HOME/node_modules/.bin/:/usr/bin:/usr/sbin:$PATH:$HOME/.bin"
# export MANPATH="/usr/local/man:$MANPATH" :/storage/50GS/miniconda/bin
#export PATH="/storage/miniconda2/bin:$PATH"
source $ZSH/oh-my-zsh.sh

alias rm='rm -rf'
alias cp='cp -i'
alias mv='mv -i'
alias l='ls -lah'
alias mk='rm -rf /root/.ccache-openelec && ionice -c 3 nice -n19 make'
alias up='sudo apt-get update && sudo apt-get upgrade -y'
alias build='rm -rf /root/.ccache-openelec && PROJECT=Generic ARCH=x86_64 ./scripts/build'
alias clean='rm -rf /root/.ccache-openelec && PROJECT=Generic ARCH=x86_64 ./scripts/clean'
alias create='rm -rf /root/.ccache-openelec && PROJECT=Generic ARCH=x86_64  ./scripts/create_addon'
alias ip2='cd /root/ip2 && linux32 ./make.sh shell'
alias f='/usr/bin/find / -name'
alias apt='aptitude install'
alias pipu='pip uninstall'
alias pipi='pip install'
alias pipup="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U"
alias cb='conda build'
alias reb='sudo shutdown -r 0'
#alias sr='spotify-ripper -l --mp4 -Q 320 spotify:track:4eysqhxOWoDiSbM8BU0GCH'
alias unpack='PROJECT=Generic ARCH=x86_64 ./scripts/unpack'
alias asc='apt-cache search'
alias asf='apt-file find'
alias aa='apt-get install'
alias cg='./configure --help | grep'
alias e='exit'
alias hisg='history | grep'
alias his='history'
alias a2='aria2c --file-allocation=none --max-connection-per-server=8'
alias ai='autoreconf -if'
alias ai4='autoreconf -i -I m4'
alias ds='docker info && docker search'
alias vmclean='cd /;cat /dev/zero > zero.fill;sync;sleep 1;sync;rm -f zero.fill'
alias rmc='rm -rf ~/.ccache-openelec'
alias rmi='rm -rf /root/oe/build.OpenELEC-Generic.x86_64-7.0-devel/image'
alias upp='sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y'
alias gr='git reset --hard'
#alias grrr='git reset --hard && git clean -dfx && git pull'
alias gr='git reset --hard && git pull'
alias gcl='git clone --recursive'
alias ad='apt-get build-dep'
alias tt='tar xvf'
alias pp='lsof -i TCP| fgrep LISTEN'
alias a='apt-file search'
alias mac="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'"
alias stop='systemctl stop kodi'
alias start='systemctl start kodi'
alias trim='time sh -c "fstrim /storage"'
alias smart='smartctl -a /dev/sdb'
alias pipup='pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U'
alias ip='curl ifconfig.co'
alias boot='systemd-analyze blame'
alias uu='/storage/data/ubuntu/usr/sbin/chroot /storage/data/ubuntu/ /bin/bash'
alias scr='kodi-send --action="TakeScreenshot"'
alias btc='cp /usr/lib/python2.7/site-packages/libtorrent.so /storage/.kodi/temp/xbmcup/script.module.libtorrent/python_libtorrent/linux_x86_64/0.16.19/libtorrent.so'
alias s1='nuttcp -l8972 -T30 -u -w4m -Ri300m/100 -i1 wat.is.my'
alias s3='iperf3 -c wat.is.my'
alias iptest='while :; do nc -l -p 4242 > /dev/null;0:51 23.01.2016one'
alias ports='netstat -nap'
alias rmpyc='/usr/bin/find . -name "*.pyc" -exec rm -rf {} \;'
alias ll='lnav /var/log'
alias ds='docker search'
alias da='docker ps -a'
alias sz='du -hs'
alias n='nano'
alias logup='cat ~/.kodi/temp/kodi.log | pastebinit'
alias mowat='/storage/.kodi/addons/tools.sshfs-fuse/bin/sshfs root@wat.is.my:/ /storage/50GS/wat.is.my -o password_stdin <~/passwd.txt'
alias dockerkillall='docker kill $(docker ps -q)'
alias grgp='git reset --hard && git clean -dfx && git pull'
alias glo='git log --oneline --all --graph --decorate'
alias ddu='dnf update'
alias dds='dnf search'
alias ddi='dnf install'
alias yy='yum install'
alias yu='yum update'
alias ff='./scripts/feeds update -a && ./scripts/feeds install -a -p packages'
alias yr='yum remove'
alias sd='systemctl start docker'
alias vi='nano'
alias smb='sudo /root/.samba/sbin/smbd'
alias ddb='dnf builddep'
alias ddr='dnf remove'
alias gogo='export GOPATH=/root/.go'
alias ar='apt-get -y install'
alias clou='nohup cloud &'
alias ip2='curl http://wtfismyip.com/json'
alias legoren='lego --path=/root/.lego --email="andrey.vd@gmail.com" --domains="router.is.my" renew'
alias mm='make menuconfig'
alias ms='make kernel_menuconfig CONFIG_TARGET=subtarget -j4'
alias ddd='dnf download'
alias dli='dnf list installed | grep'
alias mowat='sshfs root@wat.is.my:/ /root/..wat.sshfs -o password_stdin <~/passwd.txt'
alias time='time -c'
alias gog='go get -u'
alias pog='ports | /usr/bin/grep'
alias hig='history | /usr/bin/grep'
alias hh='history | /usr/bin/grep'
alias ff='./scripts/feeds update -a && ./scripts/feeds install -a'
alias mt='make toolchain/compile -j4'
alias sl='ionice -c 3 nice -n19'
alias size='/usr/bin/du -hs'
alias ddf='dnf whatprovides'
alias c='cat'
alias repoc='gpk-prefs'
alias rr='rpmbuild --rebuild'
alias ddre='dnf reinstall -y'
alias srup='pip install git+https://github.com/jrnewell/spotify-ripper'
alias nn='nano /etc/dnf/dnf.conf'
alias fl='/usr/bin/find . -name'
alias pk='pkcon -v'
alias pks='pkcon search'
alias gc='git checkout'
alias gl='git pull'
alias gd='git diff'
alias gget='go get -v -t -u'
alias mw='make world'
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias abd='apt-get build-dep'
alias afind='ack -il'
alias ai='autoreconf --verbose --install --force -I m4'
alias build='rm -rf /root/.ccache-openelec/ && PROJECT=Generic ARCH=x86_64 ./scripts/build'
alias bw='bwm-ng'
alias clean='rm -rf /root/.ccache-openelec/ && PROJECT=Generic ARCH=x86_64 ./scripts/clean'
alias create='rm -rf /root/.ccache-openelec/ && PROJECT=Generic ARCH=x86_64  ./scripts/create_addon'
alias cusocks='curl --socks5-hostname'
alias d=docker
alias ddu='dnf update -y'
alias dost='docker stats $(docker ps --format {{.Names}})'
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
alias gca='git commit -v -a'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gclean='git clean -fd'
alias gcm='git checkout master'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcs='git commit -S'
alias gdca='git diff --cached'
alias gdct='git describe --tags `git rev-list --tags --max-count=1`'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'
alias getsync='aria2c http://download-new.utorrent.com/endpoint/btsync/os/linux-x64/track/stable;tt bittorrent_sync_x64.tar.gz;rm bittorrent_sync_x64.tar.gz;rm LICENSE.TXT;rm README'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'
alias gg='git gui citool'
alias gga='git gui citool --amend'
alias gget='go get -u -v'
alias gget2='go get -u -t -v'
alias ggpull='git pull origin $(git_current_branch)'
alias ggpur=ggu
alias ggpush='git push origin $(git_current_branch)'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
alias gk='\gitk --all --branches'
alias gke='\gitk --all $(git log -g --pretty=format:%h)'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat -p'
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
alias gp='git pull'
alias gpd='git push --dry-run'
alias gpoat='git push origin --all && git push origin --tags'
alias gpristine='git reset --hard && git clean -dfx'
alias gpu='git push upstream'
alias gpv='git push -v'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
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
alias h='history'
alias history='fc -il 1'
alias hsi='hs -i'
alias ht='htop'
alias l='l -lah'
alias la='ls -lAh'
alias ll='lnav'
alias llj='journalctl -xef'
alias ls='ls -F --color=tty'
alias lsa='ls -lah'
alias mac='openssl rand -hex 6 | sed '\''s/\(..\)/\1:/g; s/.$//'\'
alias md='mkdir -p'
alias mk='rm -rf /root/.ccache-openelec/ && PROJECT=Generic ARCH=x86_64 make'
alias mkdir='mkdir -p'
alias mowat='sshfs root@185.86.78.154:/ /storage/..Wat -o password_stdin <~/passwd.txt'
alias ms='make kernel_menuconfig -j4'
alias n='nano'
alias ng='netstat -nap | grep'
alias pg='netstat -antup | grep'
alias pipup='pip freeze --local | grep -v ^-e | cut -d = -f 1  | xargs pip install -U'
alias pon='export http_proxy="http://192.168.1.4:777"'
alias ports='netstat -antup'
alias pu=pushd
alias pw='ping 185.86.78.154'
alias pyfind='find . -name "*.py"'
alias pygrep='grep --include="*.py"'
alias reb='shutdown -r 0'
alias rmc='rm -rf /root/.ccache*'
alias rpyo='/usr/bin/find . -name "*.pyo" -exec rm -rf {} \;'
alias rr='systemctl restart kodi'
alias rsync-copy='rsync -avz --progress -h'
alias rsync-move='rsync -avz --progress -h --remove-source-files'
alias rsync-synchronize='rsync -avzu --delete --progress -h'
alias rsync-update='rsync -avzu --progress -h'
alias s='systemctl'
alias s2='iperf3 -c wat.is.my && iperf3 -c wat.is.my -R'
alias sre='systemctl daemon-reload'
alias t='~/.bin/sensors.sh'
alias trim='time -c fstrim'
alias tt='tar xpvf'
alias uu='ulimit -n 51200'
alias wh='which'
alias xxi='xx info'
alias xxu='xx upload'
alias xxx='xx move'
alias ff='./scripts/feeds update -a; ./scripts/feeds install -a'
alias zb1='docker exec -ti zabbix-db /zabbix-backup/zabbix-mariadb-dump -u zabbix -p ASDewq123 -o /backups'
alias zb2='docker exec -ti zabbix-db bash -c "mysqldump -u zabbix -pASDewq123 zabbix | bzip2 -cq9 > /backups/zabbix_db_dump_$(date +%Y-%m-%d-%H.%M.%S).sql.bz2"'
alias cmake-='cmake . -LH'
alias lsdir="for dir in *;do;if [ -d \$dir ];then;du -hsL \$dir;fi;done"
alias g='grep -Hrn'
alias l='ls -lah --color=auto'
alias bb='/storage/data/ubuntu/usr/sbin/chroot /storage/data/ubuntu/ /bin/bash'
alias trim='time -c "fstrim ~"'
alias ss='strip -s'
alias debiana='sshfs root@192.168.1.215:/ /storage/50GS/-Debiana'
alias iptest='while :; do nc -l -p 4242 > /dev/null; done'
alias ll='lnav /storage/.kodi/temp/kodi.log'
alias grr='git reset --hard && git clean -dfx && git pull'
alias a2='/usr/bin/aria2c --file-allocation=none --optimize-concurrent-downloads'
alias reb='reboot'
alias wa='sshfs root@192.168.1.215:/ /storage/50GS/-wat.is.my'
alias ddd='dd of=/dev/sdd if='
alias mowat='sshfs -o reconnect,ServerAliveInterval=15 root@185.86.78.154:/ /storage/..Wat -o password_stdin <~/passwd.txt'
alias ch='proxychains4'
alias e='exit;exit'
alias pp='iperf3 -c te.s.co; iperf3 -c te.s.co -R'
alias mofe='bash /storage/mofe'
alias unfe='bash /storage/unfe'
alias ff='/storage/data/fedora/usr/sbin/chroot /storage/data/fedora/ /bin/zsh'
alias moow='sshfs -o reconnect,ServerAliveInterval=15 root@192.168.1.1:/ /storage/..OWrt -o password_stdin <~/passwd.txt'
alias prch='proxychains4 -f /storage/.config/proxychains/proxychains.conf'
alias dost='docker stats $(docker ps --format '{{.Names}}')'
alias wui='/storage/.git-webui/release/libexec/git-core/git-webui --no-browser --host 192.168.1.4'
#alias gc='git clean -dfx'
alias trim='time -c 'fstrim -a''
alias gogo='export GOPATH=/storage/.bin/.go'
alias gog='go get -u -v'
alias ms='make kernel_menuconfig' ## CONFIG_TARGET=subtarget
alias rmc='rm -rf /root/.ccache-openelec/'
alias bu='/storage/data/ubuntu/usr/sbin/chroot /storage/data/ubuntu/ /bin/zsh'
alias d='docker'
alias ww='/storage/.bin/.git-webui/release/libexec/git-core/git-webui --port 80 --no-browser --host 192.168.1.4'
alias ht='htop'
#alias yt='/bin/bash /storage/.bin/yt'
alias sreb='systemctl daemon-reload'
alias sstat='systemctl status'
alias lib2='export LD_LIBRARY_PATH=/storage/lib2'
alias ar='arch-chroot ~/chroot/arch zsh'
alias ub='arch-chroot ~/chroot/ubuntu zsh'
alias fe='arch-chroot ~/chroot/fedora zsh'
alias al='arch-chroot ~/chroot/alpine zsh'
alias sr='systemctl daemon-reload'
alias vtop='intel_gpu_top'
alias zsht="zsh -c 'trap time EXIT; : {1..3000000}'"
alias basht="bash -c 'trap times EXIT; : {1..3000000}'"
alias pskin="cd /storage/.kodi/addons/skin.aczg;  patch -p1 < /storage/skin.aczg-51mode-new.patch;cd ~"
alias dms='dmesg | lnav'
alias am='airmon-ng start wlan0'
alias crashlog='paste $(ls -1art /storage/.kodi/temp/kodi_crashlog* | tail -1)'
alias lg='journalctl -xe | lnav'
alias gcl1='git clone --recursive --depth 1'
alias dyt='daemonize /storage/.bin/yt'


ulimit -n 51200
#export http_proxy="http://127.0.0.1:7777"
#export http_proxy="socks5://127.0.0.1:9696"
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LSCOLORS=Gxfxcxdxbxegedabagacad



# Delete all stopped containers and untagged images.
### Bashhub.com Installation


bindkey -s '^T' ''$(date +%Y%m%d_%H%M%S)''



if [[ ! -f ~/.cache/.zpm/zpm.zsh ]]; then
    git clone --recursive https://github.com/horosgrisa/ZPM ~/.cache/.zpm
fi

#export LC_ALL=C
#export LC_ALL=en_US.UTF-8
#export EDITOR=/usr/bin/nano
export TERM=xterm-256color
#export CLICOLOR=1
#export GREP_COLOR=24
#export LC_CTYPE=en_US.UTF-8


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export HISTSIZE=2000
export HISTFILE="$HOME/.cache/.zsh-history"

export REPORTTIME=3 # display commands with execution time >= 3 seconds
#setop xtrace

export PATH="$PATH:/storage/.bin"
