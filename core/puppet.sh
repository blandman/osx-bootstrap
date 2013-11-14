#!/usr/bin/env bash

source_dir=~/.osx-bootstrap

#echo "curl -O http://downloads.puppetlabs.com/mac/facter-$facter_version.dmg"
#curl -O http://downloads.puppetlabs.com/mac/puppet-$puppet_version.dmg

#echo "curl -O http://downloads.puppetlabs.com/mac/facter-$facter_version.dmg"
#curl -O http://downloads.puppetlabs.com/mac/facter-$facter_version.dmg

#echo "curl -O http://downloads.puppetlabs.com/mac/hiera-$hiera_version.dmg"
#curl -O http://downloads.puppetlabs.com/mac/hiera-$hiera_version.dmg
 
#echo "hdiutil attach facter-$facter_version.dmg"
#hdiutil attach facter-$facter_version.dmg

#echo "hdiutil attach puppet-$puppet_version.dmg"
#hdiutil attach puppet-$puppet_version.dmg

#echo "hdiutil attach hiera-$hiera_version.dmg"
#hdiutil attach hiera-$hiera_version.dmg
 
 
#echo "sudo installer -package /Volumes/facter-$facter_version/facter-$facter_version.pkg -target $target_volume"
#sudo installer -package /Volumes/facter-$facter_version/facter-$facter_version.pkg -target "$target_volume"
 
#echo "sudo installer -package /Volumes/puppet-$puppet_version/puppet-$puppet_version.pkg -target $target_volume"
#sudo installer -package /Volumes/puppet-$puppet_version/puppet-$puppet_version.pkg -target "$target_volume"

#echo "sudo installer -package /Volumes/hiera-$hiera_version/puppet-$hiera_version.pkg -target $target_volume"
#sudo installer -package /Volumes/hiera-$hiera_version/hiera-$hiera_version.pkg -target "$target_volume"
rm -f /tmp/hpipe
mkfifo /tmp/hpipe

# create a background job which takes its input from the named pipe
$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --indeterminate --title "Puppet" --text "Installing Puppet, Please wait..." < /tmp/hpipe &

# associate file descriptor 3 with that pipe and send a character through the pipe
exec 3<> /tmp/hpipe
echo -n . >&3

# do all of your work here
sudo gem install puppet > /Users/administrator/Desktop/imagelog.txt

# now turn off the progress bar by closing file descriptor 3
exec 3>&-

# wait for all background jobs to exit
wait
rm -f /tmp/hpipe


rm -f /tmp/hpipe
mkfifo /tmp/hpipe

# create a background job which takes its input from the named pipe
$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --indeterminate --title "Puppet" --text "Configuring Puppet, Please wait..." < /tmp/hpipe &

# associate file descriptor 3 with that pipe and send a character through the pipe
exec 3<> /tmp/hpipe
echo -n . >&3

# do all of your work here

echo "Creating /etc/puppet/puppet.conf"

mkdir /etc/puppet/

sudo sh -c "echo \"[main]
logdir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=$vardir/lib/factor
templatedir=$confdir/templates
server=vmnocwspuppet01.psd401.net
report=true
certname = `hostname | tr [:upper:] [:lower:]`.psd401.net

[master]
ssl_client_header = SSL_CLIENT_S_IN
ssl_client_verify_header = SSL_CLIENT_VERIFY

\" > /etc/puppet/puppet.conf"

sudo puppet resource group puppet ensure=present

sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'

sudo cp $source_dir/extras/com.puppetlabs.puppet.plist /Library/LaunchDaemons/

sudo chown root:wheel /Library/LaunchDaemons/com.puppetlabs.puppet.plist
sudo chmod 644 /Library/LaunchDaemons/com.puppetlabs.puppet.plist

sudo launchctl load -w /Library/LaunchDaemons/com.puppetlabs.puppet.plist

exec 3>&-

wait
rm -f /tmp/hpipe