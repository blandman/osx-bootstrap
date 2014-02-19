#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap

# create a named pipe
rm -f $source_dir/tmp/hpipe
mkdir $source_dir/tmp
mkfifo $source_dir/tmp/hpipe

log=~/Desktop/Finish\ image\ log/finish-brew-log.sh

# create a background job which takes its input from the named pipe
$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --title "Installing Required Scripts" --indeterminate --text "Managing Brew..." < $log &

# associate file descriptor 3 with that pipe and send a character through the pipe
exec 3<> $log
echo -n . >&3

# do all of your work here



# install homebrew
`which -s brew`
if [[ $? != 0 ]]; then
    echo '##### Installing Homebrew...'
    ruby -e "$(curl -fsSLk https://raw.github.com/mxcl/homebrew/go/install)" < <(echo 1)
    brew doctor
    brew tap phinze/homebrew-cask
else
    echo '##### Running Homebrew Updates...'
    brew update
    brew doctor
fi

exec 3>&-

# install helpfull formulas
export formulas='
    bash-completion
    ssh-copy-id
    wget 
    cowsay
    geoip
    terminal-notifier
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
    fi
done > >($source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --indeterminate --title "Installing Required Scripts")



