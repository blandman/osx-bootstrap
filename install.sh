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

# we need to download the repo for the absolute paths
#rm -rf ~/.osx-bootstrap

#if [[ ! -d ~/.osx-bootstrap ]]; then
    #echo '##### Downloading Bootstrap...'
	# autoupdate bootstrap file
	#git clone https://github.com/blandman/osx-bootstrap.git $source_dir
	# hide folder
	chflags hidden $source_dir
#else
	# update repo
#    echo '##### Running Bootstrap Updates...'
#	cd $source_dir
#	git pull origin master
#fi

# define helpers
source $source_dir/core/helpers.sh

# create bootstrap tmp
[[ ! -f $source_file ]] && cp -rf $source_dir/install.sh $source_file_tmp

# include system with param $1

# install brew
sudo bash $source_dir/core/brew.sh  

source $source_dir/core/system.sh $1
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
source $source_dir/core/defaults.sh
# install puppet
source $source_dir/core/puppet.sh
# place your extras here

# create bootstrap file
[[ ! -f $source_file ]] && mv $source_file_tmp $source_file && chmod +x $source_file

# done