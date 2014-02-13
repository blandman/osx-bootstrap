#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh


# create a named pipe
rm -f $source_dir/tmp/hpipe
mkdir $source_dir/tmp
mkfifo $source_dir/tmp/hpipe

# create a background job which takes its input from the named pipe
$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --title "Installing Required Scripts" --indeterminate --text "Updating..." < $source_dir/tmp/hpipe &

# associate file descriptor 3 with that pipe and send a character through the pipe
exec 3<> $source_dir/tmp/hpipe
echo -n . >&3

# do all of your work here




# install homebrew
`which -s brew`
if [[ $? != 0 ]]; then
    echo ''
    echo '##### Installing Homebrew...'
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)" < <(echo 1)
    brew tap phinze/homebrew-cask
else
    echo ''
    echo '##### Running Homebrew Updates...'
    brew update
    brew doctor
fi

exec 3>&-

wait
rm -f $source_dir/tmp/hpipe

# install helpfull formulas
export formulas='
    bash-completion
    ssh-copy-id
    wget 
    cowsay
    redis
    geoip
    terminal-notifier
    brew-cask
'
i=0
for formula in $formulas
do
    tmp=`brew list | grep $formula`
    ((i += 1))
    if [[ ! $tmp ]]; then
        echo 'Installing Formula '$formula'...'
        brew install $formula
        echo "$i Installing $formula  $i%"; sleep 0.05


        if [[ $formula = 'dnsmasq' ]]; then
            # setup dnsmask
            mkdir /usr/local/etc/
            cp -rf $source_dir/templates/dnsmasq.conf /usr/local/etc
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
done > >($source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --title "Installing Required Scripts")