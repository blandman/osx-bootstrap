#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh


# create a named pipe
rm -f /tmp/hpipe
mkfifo /tmp/hpipe

# create a background job which takes its input from the named pipe
$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --title "Instaling Required Scripts" --text "Please wait..." < /tmp/hpipe &

# associate file descriptor 3 with that pipe and send a character through the pipe
exec 3<> /tmp/hpipe
echo -n . >&3

# do all of your work here



# install homebrew
`which -s brew`
if [[ $? != 0 ]]; then
    echo ''
    echo '##### Installing Homebrew...'
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
else
    echo ''
    echo '##### Running Homebrew Updates...'
    brew update
    brew doctor
fi

# install helpfull formulas
export formulas='
    git
    git-flow
    hub
    bash-completion
    ssh-copy-id
    wget
    dnsmasq
    nginx
    cowsay
    redis
    geoip
    terminal-notifier
'
i=0
for formula in $formulas
do
    tmp=`brew list | grep $formula`
    ((i += 1))
    if [[ ! $tmp ]]; then
        echo ''
        echo '##### Installing Formula '$formula'...'
        echo "$i We're now at $i%"
        brew install $formula


        if [[ $formula = 'dnsmasq' ]]; then
            # setup dnsmask
            mkdir /usr/local/etc/
            cp -rf $source_dir/templates/dnsmasq.conf /usr/local/etc

            # sudo is required for dnsmasq
            require_sudo

            # setup dnsmask daemon
            sudo ln -sfv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
            sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
            sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

            # setup resolver
            sudo mkdir -p /etc/resolver
            sudo cp -rf $source_dir/templates/dev /etc/resolver
            # empty cache
            dscacheutil -flushcache
            # scutil --dns
        fi

        if [[ $formula = 'nginx' ]]; then
            ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
            launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
        fi

        if [[ $formula = 'redis' ]]; then
            ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
            launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
        fi
    fi
done > >($source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --title "Instaling Required Scripts")

exec 3>&-

wait
rm -f /tmp/hpipe
