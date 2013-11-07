#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

# require sudo password
require_sudo





getName(){
    name=$(osascript -e 'Tell application "System Events" to choose from list {"Artondale Elementary School", "Community Transition Program", "Discovery Elementary School", "Educational Service Center", "Evergreen Elementary School", "Gig Harbor High School", "Goodman Middle School", "Harbor Heights Elementary School", "Harbor Ridge Middle School", "Henderson Bay High School", "Key Peninsula Middle School", "Kopachuck Middle School", "Maintenance & Warehouse", "Minter Elementary School", "Peninsula High School", "Purdy Elementary School", "Technical Services", "Transportation", "Vaughn Elementary School", "Voyager Elementary School"} with title "Your Building" with prompt "Please Select your building"')

    if [ $? -ne 0 ]; then
        cancel=$(osascript -e 'Tell application "System Events" to display alert "You must enter a name for this computer....." as warning')
        echo "$cancel"
        exit 1 # exit with an error status
    elif [ -z "$name" ]; then
        osascript -e 'Tell application "System Events" to display alert "You must enter a name for this computer....." as warning'
            getName
        exit 1 # exit with an error status
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
    
    tempbarcode=$(osascript -e 'Tell application "System Events" to display dialog "Please Enter the last 6 digits of your computers barcode.\nPlease call ext. 3711 if you need help." buttons {"Next"} default button 1 default answer ""' | grep "text returned:")
    
    computerbarcode=$(expr "$tempbarcode" : '.*\([0-9][0-9][0-9][0-9][0-9][0-9]\)')
    
    if [ -z "$computerbarcode" ]; then
        getBarcode
        terminal-notifier -title “Whoops” -message “You must enter a valid barcode. Expecting 6 numbers”
    fi
}

getOS(){
    computerOS=$(system_profiler SPSoftwareDataType | grep "System Version" | grep -Eho "[0-9][0-9]\.[0-9]" | tr -d '.')
}



modelname=$(system_profiler SPHardwareDataType | grep "Model Identifier" | cut -d: -f2)

computertype="DT"

networksetup -setnetworkserviceenabled WiFi off
networksetup -removenetworkservice WiFi

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
    formulas=(
        'scutil --set HostName "$computername"'
        'scutil --set LocalHostName "$computername"'
        'networksetup -setcomputername "$computername"'
        'dsconfigad -f -remove -username "martinb" -password "mart8074"'
        'dsconfigad -add peninsula.wednet.edu -computer "$computername" -username "martinb" -password "mart8074" -ou "OU=Computers,OU=""$computerlocation"",OU=PSD,DC=Peninsula,DC=wednet,DC=edu"'
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
            'networksetup -createnetworkservice WiFi Wi-Fi'
            'networksetup -setairportpower en1 on'
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
        finish
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
        finish
    fi
}

complete() {
    terminal-notifier -title 'Initial Configuration Successfull' -message 'Moving on to default settings'
}

echo "the computer type is: $computertype"


getOS
getBarcode
getName



rm -f /tmp/hpipe
mkfifo /tmp/hpipe

# create a background job which takes its input from the named pipe
$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --indeterminate --title "Software Updating" --text "Please wait..." < /tmp/hpipe &

# associate file descriptor 3 with that pipe and send a character through the pipe
exec 5<> /tmp/hpipe
echo -n . >&5

# do all of your work here
sudo softwareupdate -i -a

# update gem versions
sudo gem update --system

# now turn off the progress bar by closing file descriptor 3
exec 5>&-

# wait for all background jobs to exit
wait
rm -f /tmp/hpipe
exit 0