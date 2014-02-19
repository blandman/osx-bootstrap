#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo ''
echo 'OSX Bootstrap 1.2.3'
echo '-------------------'
echo ''

# define variables
source_dir=~/.osx-bootstrap
source_file=$source_dir/.osx-bootstrap
source_file_tmp=$source_dir/.osx-bootstrap-tmp

# define helpers
source $source_dir/core/helpers.sh

# install brew

mkdir ~/Desktop/Finish\ image\ logs/

source `su administrator ~/.osx-bootstrap/core/brew.sh > /dev/tty`



source $source_dir/core/system.sh $1 &> ~/Desktop/Finish\ image\ logs/finish-system-log.txt 
# install python
#source $source_dir/core/python.sh
# install mysql
#source $source_dir/core/mysql.sh
# install postgres
#source $source_dir/core/postgres.sh
# install compass
#source $source_dir/core/compass.sh
# install zsh
#source $source_dir/core/zsh.sh
# install defaults
source $source_dir/core/defaults.sh &> ~/Desktop/Finish\ image\ logs/finish-defaults-log.txt
# install puppet
source $source_dir/core/puppet.sh &> ~/Desktop/Finish\ image\ logs/finish-puppet-log.txt

echo "DONE!"
# place your extras here

# create bootstrap file
[[ ! -f $source_file ]] && mv $source_file_tmp $source_file && chmod +x $source_file

rv1=`$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --no-newline \
    --text "Image Complete!" \
    --informative-text "The image is ready to go, lets logout, then log in as yourself and confirm that everything looks good." \
    --button1 "Logout"`
if [ "$rv1" == "1" ]; then
	rm -rf $source_dir
    osascript -e 'tell application \"System Events\" to log out'
fi

# done