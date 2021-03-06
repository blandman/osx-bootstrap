#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

installApps(){
    software=`osascript -e 'with timeout of 86400 seconds' -e 'Tell application "System Events" to choose from list {"Adobe CS6", "Sketchup Pro 2013", "Apple Remote Desktop"} with title "Packages to include" with prompt "Hold Command to select multiple packages to install. Press Cancel to skip." with multiple selections allowed' -e 'end'`;

    echo "$software";
    if [[ "$software" == *CS6* ]]
    then
        rm -f /tmp/hpipe
        mkfifo /tmp/hpipe

        # create a background job which takes its input from the named pipe
        $source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar \
        --indeterminate --title "Installing CS6" \
        --text "Please wait... This will take some time..." < /tmp/hpipe &

        # associate file descriptor 3 with that pipe and send a character through the pipe
        exec 3<> /tmp/hpipe
        echo -n . >&3

        # do all of your work here
        wget --progress=dot "https://staticfiles.psd401.net/psimages/Adobe_CS6_Install.pkg.zip"
        
        unzip Adobe_CS6_Install.pkg.zip
        rm -rf Adobe_CS6_Install.pkg.zip
        sudo installer -pkg $source_dir/Adobe_CS6_Install.pkg -target /

        # now turn off the progress bar by closing file descriptor 3
        exec 3>&-

        # wait for all background jobs to exit
        rm -f /tmp/hpipe
    fi
    if [[ "$software" == *Sketchup* ]]
    then
        mkfifo /tmp/hpipe
        $source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar \
        --indeterminate --title "Installing Sketchup Pro 2013" \
        --text "Please wait... This should take a few minutes" < /tmp/hpipe &

        # associate file descriptor 3 with that pipe and send a character through the pipe
        exec 3<> /tmp/hpipe
        echo -n . >&3

        # do all of your work here
        wget "https://staticfiles.psd401.net/psimages/Sketchup-Pro-2013.pkg"
        sudo installer -pkg $source_dir/Sketchup-Pro-2013.pkg -target /

        # now turn off the progress bar by closing file descriptor 3
        exec 3>&-

        # wait for all background jobs to exit
        rm -f /tmp/hpipe
    fi
    if [[ "$software" == *Remote* ]]
    then
        mkfifo /tmp/hpipe
        $source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar \
        --indeterminate --title "Installing Apple Remote Desktop" \
        --text "Please wait... This shouldn't take long at all\nWARNING: With Apple Remote Desktop you must log into the user that will be using it and configure it for them!!!" < /tmp/hpipe &

        # associate file descriptor 3 with that pipe and send a character through the pipe
        exec 3<> /tmp/hpipe
        echo -n . >&3

        # do all of your work here
        wget "https://staticfiles.psd401.net/psimages/Apple-Remote-Desktop.pkg"
        sudo installer -pkg $source_dir/Apple-Remote-Desktop.pkg -target /

        # now turn off the progress bar by closing file descriptor 3
        exec 3>&-

        # wait for all background jobs to exit
        rm -f /tmp/hpipe
    fi

    export caskformulas='
        google-chrome
        firefox
        geektool
    '
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
    for formula in $caskformulas
    do
        tmp=`brew list | grep $formula`
        ((i += 1))
        if [[ ! $tmp ]]; then
            echo "$i Installing $formula  $i%"
            brew cask install $formula --force
        fi
    done > >($source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --title "Installing Required Scripts")


    export packageformulas='
        HPDrivers.pkg
        meraki.pkg
    '
    for formula in $packageformulas
    do
        ((i += 1))
        echo "Installing $formula $i%";
        wget "https://staticfiles.psd401.net/psimages/$formula" 
        sudo installer -store -pkg $formula -target /
        rm -rf $formula
    done > >($source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --title "Installing Larger Applications")

    finish
}


# require sudo password
require_sudo



getName(){
    name=$(osascript -e 'with timeout of 86400 seconds' -e 'Tell application "System Events" to choose from list {"Artondale Elementary School", "Community Transition Program", "Discovery Elementary School", "Educational Service Center", "Evergreen Elementary School", "Gig Harbor High School", "Goodman Middle School", "Harbor Heights Elementary School", "Harbor Ridge Middle School", "Henderson Bay High School", "Key Peninsula Middle School", "Kopachuck Middle School", "Maintenance & Warehouse", "Minter Elementary School", "Peninsula High School", "Purdy Elementary School", "Technical Services", "Transportation", "Vaughn Elementary School", "Voyager Elementary School"} with title "Your Building" with prompt "Please Select your building"' -e 'end')

    if [ $? -ne 0 ]; then
        cancel=$(osascript -e 'with timeout of 86400 seconds' -e 'Tell application "System Events" to display alert "You must enter a name for this computer....." as warning' -e 'end')
        echo "$cancel"
        exit 1 # exit with an error status
    elif [ -z "$name" ]; then
        osascript -e 'Tell application "System Events" to display alert "You must enter a name for this computer....." as warning'
        getName
    fi
    
    case "$name" in
                'Artondale Elementary School')
                        computerlocation="AES"
                ;;
                'Community Transition Program')
                        computerlocation="CTP"
                ;;
                'Discovery Elementary School')
                        computerlocation="DES"
                ;;
                'Educational Service Center')
                        computerlocation="ESC"
                ;;
                'Evergreen Elementary School')
                        computerlocation="EES"
                ;;
                'Gig Harbor High School')
                        computerlocation="GHH"
                ;;
                'Goodman Middle School')
                        computerlocation="GMS"
                ;;
                'Harbor Heights Elementary School')
                        computerlocation="HHE"
                ;;
                'Harbor Ridge Middle School')
                        computerlocation="HRM"
                ;;
                'Henderson Bay High School')
                        computerlocation="HBH"
                ;;
                'Key Peninsula Middle School')
                        computerlocation="KPM"
                ;;
                'Kopachuck Middle School')
                        computerlocation="KMS"
                ;;
                'Maintenance & Warehouse')
                        computerlocation="MTW"
                ;;
                'Minter Elementary School')
                        computerlocation="MES"
                ;;
                'Peninsula High School')
                        computerlocation="PHS"
                ;;
                'Purdy Elementary School')
                        computerlocation="PES"
                ;;
                'Technical Services')
                        computerlocation="TSD"
                ;;
                'Transportation')
                        computerlocation="TRA"
                ;;
                'Vaughn Elementary School')
                        computerlocation="VES"
                ;;
                'Voyager Elementary School')
                        computerlocation="VGE"
                ;;
                *)
                        computerlocation="TSD"
                ;;
        esac

    computername="$computertype$computerlocation$computerbarcode"M"$computerOS"
    getConfirmation
}



getBarcode() {
    
    tempbarcode=$(osascript -e 'with timeout of 86400 seconds' -e 'Tell application "System Events" to display dialog "Please Enter the last 6 digits of your computers barcode.\nPlease call ext. 3711 if you need help." buttons {"Next"} default button 1 default answer ""' -e 'end' | grep "text returned:")
    
    computerbarcode=$(expr "$tempbarcode" : '.*\([0-9][0-9][0-9][0-9][0-9][0-9]\)')
    
    if [ -z "$computerbarcode" ]; then
        getBarcode
        terminal-notifier -title “Whoops” -message “You must enter a valid barcode. Expecting 6 numbers”
    fi
}

getOS(){
    computerOS=$(system_profiler SPSoftwareDataType | grep "System Version" | grep -Eho "[0-9][0-9]\.[0-9]" | tr -d '.')
}

downloadName(){
    serial=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'`;

    echo "This is the serial: $serial and os $computerOS";

    #Query the serial against filemaker.
    nameinfo=`wget -qO- "http://10.0.0.131:8080/query.php?serial=$serial&os=M$computerOS"`
    
    echo "This is the new name: $nameinfo";

    if [ "$serial" == ""]; then
        getBarcode
        getName
    else
        computername=$nameinfo;
        getConfirmation
    fi
}



modelname=$(system_profiler SPHardwareDataType | grep "Model Identifier" | cut -d: -f2)

computertype="DT"

sudo mv /var/db/NetworkInterfaces.xml /var/db/NetworkInterfaces.old
sudo mv /var/db/SystemConfiguration/preferences.xml /var/db/SystemConfiguration/preferences.old
sudo mv /var/db/SystemConfiguration/com.apple.airport.preferences.xml /var/db/SystemConfiguration/com.apple.airport.preferences.old

case "$modelname" in
*Book*)
    computertype="LT"
;;
*mini*)
    computertype="DT"
;;
*iMac*)
    computertype="DT"
;;
*MacPro*)
    computertype="DT"
;;
esac

finish(){
     echo 'Sending computer information to Tech Support......     '

    mac=`ifconfig | grep ether | head -n1 | base64`;
    name=`$computername | base64`;
    sysserial=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'`;
    osid=`echo 50 | base64`;
    imageid=`echo 2 | base64`;
    ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}' | base64`

    data="mac=${mac}&host=${name}&serial=${sysserial}&advanced=1&osid=${osid}&imageid=${imageid}";
    
    res="";

    res=`wget -O - --post-data="${data}" "http://fog.psd401.net/fog/service/auto.register.php" 2>/dev/null`
    echo "${res}"

    formulas=(
        'scutil --set HostName "$computername"'
        'scutil --set LocalHostName "$computername"'
        'networksetup -setcomputername "$computername"'
        'dsconfigad -force -add peninsula.wednet.edu -computer "$computername" -username "martinb" -password "mart8074" -ou "OU=Computers,OU=""$computerlocation"",OU=PSD,DC=Peninsula,DC=wednet,DC=edu"'
        'dsconfigad -groups "PSD-StaffLocalAdmin"'
    )

    i=0
    for formula in "${formulas[@]}"
    do
        ((i += 1))
        percent="$((i * 2))"
        eval $formula
        echo "$percent Setting Authentication Configurations... $percent%"; sleep 0.1
    done > >($source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --title "Configuring System")

    
    if [ "$computertype" = "LT" ]
    then
        echo "running laptop setup"
        ltformulas=(
            'dsconfigad -mobile enable'
            'dsconfigad -mobileconfirm disable'
            'sudo networksetup -createnetworkservice Wi-Fi Wi-Fi'
            'sudo networksetup -setnetworkserviceenabled Wi-Fi on'
            'sudo networksetup -setairportnetwork en0 psd-secure'
        )

        for formula in "${ltformulas[@]}"
        do
            ((i += 1))
            percent="$((i * 2))"
            eval $formula
            echo "$percent Setting Laptop Authentication Configurations... $percent%"; sleep 0.5
        done > >($source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --title "Configuring System")
    else
        networksetup -createnetworkservice Ethernet Ethernet
        sudo networksetup -setnetworkserviceenabled Wi-Fi off
        sudo networksetup -removenetworkservice Wi-Fi
    fi
    
    domain=$( dsconfigad -show | awk '/Active Directory Domain/{print $NF}' )   

    if [[ "$domain" == "peninsula.wednet.edu" ]]; then
        # Check the id of a user
        id -u atest
        # If the check was successful...
        if [[ $? == 0 ]]; then
            echo "The Mac is bound to AD"
            complete
        else
            # If the check failed
            echo "The Mac is NOT bound to AD"
            finish
        fi
    else
        # If the domain returned did not match our expectations
        echo "The Mac is NOT bound to AD"
        rv=`$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --text "Woops" \
            --informative-text "It looks like there was a problem joining to the PSD domain. Try disconnecting from the network and then reconnecting, this often works. Retry?" \
            --button1 "Retry" --button2 "Cancel"`
        if [ "$rv" == "1" ]; then
            echo "User said OK"
            finish
        elif [ "$rv" == "2" ]; then
            echo "Canceling"
            echo "The Mac is NOT bound to AD"
            rv1=`$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --no-newline \
                --text "You will need to manually join this computer to the domain. Please Do so now." \
                --informative-text "When the computer is bound, press continue." \
                --button1 "Continue"`
            if [ "$rv1" == "1" ]; then
                finish
            fi
            exit
        fi
    fi
}

getConfirmation(){
    confirm=$(osascript -e 'Tell application "System Events" to display dialog "'"$computername"' is the name that was generated.\nDoes this look correct?" buttons {"Yes", "No"} default button 1' | grep "Yes")
    echo "$confirm"

    if [[ -z "$confirm" ]]; then
        getOS
        getBarcode
        getName
    else
        installApps
    fi
}

complete() {
    terminal-notifier -title 'Initial Configuration Successfull' -message 'Moving on to default preferences'
}

echo "the computer type is: $computertype"

rv1=`$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --no-newline \
    --text "Ready?" \
    --informative-text "You will be prompted to provide this computers barcode and future location." \
    --button1 "Im ready!!"`
if [ "$rv1" == "1" ]; then
    getOS
    downloadName
    #getBarcode
    #getName
fi