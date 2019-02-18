# Path to your oh-my-zsh installation.
export ZSH=/root/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded. avit cloud crunch arrow
#ZSH_THEME="robbyrussell"
#ZSH_THEME="norm"
#ZSH_THEME="alanpeabody"
#ZSH_THEME="flazz"
#ZSH_THEME="miloshadzic"
#ZSH_THEME="smt"
#ZSH_THEME="steeef"
ZSH_THEME="mortalscumbag"

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
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
#IST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup. last-working-dir rsync
plugins=(git history yum web-search wd zsh-navigation-tools colorize systemd)

# User configuration
#export PATH="/storage/50GS/miniconda/bin:$PATH"
export PATH="/root/.local:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/root/.samba/sbin:/root/.samba/bin:/root/go/bin:/root/.go/bin:/root/.local/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
#export LANG=ru_RU.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
export EDITOR='nano'
# fi
# export bindkey $key[Home] beginning-of-line
# export bindkey "${terminfo[khome]}" beginning-of-line
# export bindkey "${terminfo[kend]}" end-of-line
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

#export http_proxy="http://192.168.1.2:8585"

# Delete all stopped containers.
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias dockerclean='dockercleanc || true && dockercleani'

# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias rm='rm -rf'
alias cp='cp -i'
alias mv='mv -i'
alias l='ls -lah'
alias mk='rm -rf ~/.ccache-openelec && ionice -c 3 nice -n19 make'
alias up='sudo apt-get update && sudo apt-get upgrade -y'
alias build='rm -rf ~/.ccache-openelec && PROJECT=Generic ARCH=x86_64 ./scripts/build'
alias clean='rm -rf ~/.ccache-openelec && PROJECT=Generic ARCH=x86_64 ./scripts/clean'
alias create='rm -rf ~/.ccache-openelec && PROJECT=Generic ARCH=x86_64  ./scripts/create_addon'
alias ip2='cd /root/ip2 && linux32 ./make.sh shell'
alias f='find / -name'
alias apt='aptitude install'
#export PATH="/storage/50GS/miniconda3/bin:$PATH"
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
alias a2='aria2c'
alias ai='autoreconf -if'
alias ds='docker info && docker search'
alias vmclean='cd /;cat /dev/zero > zero.fill;sync;sleep 1;sync;rm -f zero.fill'
alias rmc='rm -rf ~/.ccache-openelec'
alias rmi='rm -rf /root/oe/build.OpenELEC-Generic.x86_64-7.0-devel/image'
alias upp='sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y'
alias gr='git reset --hard'
alias gc='git clean -dfx'
alias grrr='git reset --hard && git clean -dfx && git pull'
alias gr='git reset --hard && git pull'
alias gcl='git clone --recursive'
alias ad='apt-get build-dep'
alias tt='tar xvf'
alias pp='lsof -i TCP| fgrep LISTEN'
alias a='apt-file search'
alias rr='systemctl restart kodi'
alias mac="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'"
alias stop='systemctl stop kodi'
alias start='systemctl start kodi'
alias trim='time sh -c "fstrim /storage"'
alias smart='smartctl -a /dev/sdb'
alias iw='iperf3 -c wat.is.my'
alias pipup='pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U'
alias sr='spotify-ripper -l --flat --mp4 -Q 320 -d /storage/spotify-ripper'
alias ip='curl ifconfig.co'
alias boot='systemd-analyze blame'
alias uu='/storage/data/ubuntu/usr/sbin/chroot /storage/data/ubuntu/ /bin/bash'
alias st='speedtest-linux-amd64 --server 4811'
alias scr='kodi-send --action="TakeScreenshot"'
alias btc='cp /usr/lib/python2.7/site-packages/libtorrent.so /storage/.kodi/temp/xbmcup/script.module.libtorrent/python_libtorrent/linux_x86_64/0.16.19/libtorrent.so'
alias s1='nuttcp -l8972 -T30 -u -w4m -Ri300m/100 -i1 wat.is.my'
alias s3='iperf3 -c wat.is.my'
alias iptest='while :; do nc -l -p 4242 > /dev/null;0:51 23.01.2016one'
#export PATH="/storage/50GS/miniconda/bin:$PATH"
alias ports='netstat -nap'
alias rmpyc='find . -name "*.pyc" -exec rm -rf {} \;'
alias ll='lnav /var/log'
#export http_proxy="http://192.168.1.4:777"
#export TMPDIR="/storage/50GS/docker-tmp"
#DOCKER="/storage/.kodi/addons/service.docker/bin/docker"
export LD_LIBRARY_PATH=/storage/lib2
alias ds='docker search'
alias da='docker ps -a'
alias sz='ncdu /'
alias n='nano'
alias logup='cat ~/.kodi/temp/kodi.log | pastebinit'
alias mowat='/storage/.kodi/addons/tools.sshfs-fuse/bin/sshfs root@wat.is.my:/ /storage/50GS/wat.is.my -o password_stdin <~/passwd.txt'
# Kill all running containers.
alias dockerkillall='docker kill $(docker ps -q)'
alias gp='git pull'
alias grgp='git reset --hard && git clean -dfx && git pull'
alias glo='git log --oneline --all --graph --decorate'
alias ddu='dnf update -y'
alias dds='dnf search'
alias ddi='dnf install'
alias yy='yum install'
alias yu='yum update'
alias ff='./scripts/feeds update -a && ./scripts/feeds install -a -p packages'
alias yr='yum remove'
alias tt='tar xvf'
alias sd='systemctl start docker'
alias vi='nano'
alias smb='sudo /root/.samba/sbin/smbd'
alias ddb='dnf builddep'
alias ddr='dnf remove'
alias gogo='export GOPATH=/root/.go'
alias ar='apt-get -y install'
alias clou='nohup cloud &'
alias ip2='curl http://wtfismyip.com/json'
# curl --socks5-hostname 127.0.0.1:9050 http://wtfismyip.com/json
alias legoren='lego --path=/root/.lego --email="andrey.vd@gmail.com" --domains="router.is.my" renew'
alias d='daemonize'
alias mm='make menuconfig'
alias ms='make kernel_menuconfig CONFIG_TARGET=subtarget -j4'
alias ddd='dnf download'
alias dli='dnf list installed | grep'
export GOPATH=/root/.go
#export GOROOT=$HOME/.go
#export GOPATH=$HOME/go
#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin


#export GOROOT=$HOME/go
#export GOPATH=$HOME/gogs
#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
##source $HOME/.bashrc

#export GOROOT=$HOME/.gogo
#export GOPATH=$HOME/go
#export PATH=$PATH:$GOROOT/bin
#[[ -s "/root/.gvm/scripts/gvm" ]] && source "/root/.gvm/scripts/gvm"export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init -)"
# export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
# export PATH="$HOME/.rbenv/bin:$PATH"
# export PATH="$HOME/.rbenv/versions/2.2.3/bin:$PATH"



export FORCE_UNSAFE_CONFIGURE=1
#export GOPATH=$HOME/work

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

autoload -U compinit promptinit
compinit
promptinit

# This will set the default prompt to the walters theme
#prompt walters
alias mowat='sshfs root@wat.is.my:/ /root/..wat.sshfs -o password_stdin <~/passwd.txt'
alias time='time sh -c'
alias gog='go get -u'
alias pog='ports | grep'
alias hig='history | grep'
alias ff='./scripts/feeds update -a && ./scripts/feeds install -a'
alias mt='make toolchain/compile -j4'
### Bashhub.com Installation
if [ -f ~/.bashhub/bashhub.zsh ]; then
    source ~/.bashhub/bashhub.zsh
fi

alias gw='git webui'
alias sl='ionice -c 3 nice -n19'
alias size='du -hs'
alias ddf='dnf whatprovides'
alias c='cat'
#export http_proxy="http://localhost:8118"
alias webui='python ~/.git-webui/release/libexec/git-core/git-webui'