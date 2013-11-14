# define helpers
source_dir=~/.osx-bootstrap
require_sudo
if [[ ! -f ~/.osx-bootstrap/.osx-bootstrap ]]; then
    echo ''

    formulas=(
        'defaults write NSGlobalDomain AppleFontSmoothing -int 2'
        'defaults write NSGlobalDomain AppleKeyboardUIMode -int 3'
        'defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false'
        'defaults write NSGlobalDomain AppleShowAllExtensions -bool false'
        'defaults write NSGlobalDomain InitialKeyRepeat -int 12'
        'defaults write NSGlobalDomain AppleShowScrollBars -string “Always”'
        'defaults write NSGlobalDomain KeyRepeat -int 0'
        'defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool true'
        'defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false'
        'defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true'
        'defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false'
        'defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true'
        'defaults write NSGlobalDomain NSScrollAnimationEnabled -bool true'
        'defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false'
        'defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true'
        'defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true'
        'defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true'
        'defaults write NSGlobalDomain com.apple.finder AppleShowAllFiles FALSE'
        'defaults write NSGlobalDomain com.apple.finder EmptyTrashSecurely -bool true'
        'defaults write NSGlobalDomain com.apple.finder FXEnableExtensionChangeWarning -bool false'
        'defaults write NSGlobalDomain com.apple.Finder FXPreferredViewStyle -string "Nlsv"'
        'defaults write NSGlobalDomain com.apple.finder FXDefaultSearchScope -string "SCcf"'
        'defaults write NSGlobalDomain com.apple.finder _FXShowPosixPathInTitle -bool NO'
        'defaults write NSGlobalDomain com.apple.finder QLEnableTextSelection -bool true'
        'defaults write NSGlobalDomain com.apple.finder ShowPathbar -bool true'
        'defaults write NSGlobalDomain com.apple.finder ShowStatusBar -bool true'
        'defaults write NSGlobalDomain com.apple.desktopservices DSDontWriteNetworkStores -bool true'
        '/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist'
        '/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist'
        'defaults write NSGlobalDomain com.apple.dock tilesize -int 28'
        'defaults write NSGlobalDomain com.apple.dock expose-animation-duration -float 0.5'
        'defaults write NSGlobalDomain com.apple.dock "expose-group-by-app" -bool true'
        'defaults write NSGlobalDomain com.apple.dock itunes-notifications -bool true'
        'defaults write NSGlobalDomain com.apple.dock show-process-indicators -bool true'
        'defaults write NSGlobalDomain com.apple.dock showhidden -bool true'
        'find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete'
        'defaults write NSGlobalDomain com.apple.Safari DebugSnapshotsUpdatePolicy -int 2'
        'defaults write NSGlobalDomain com.apple.Safari IncludeInternalDebugMenu -bool true'
        'defaults write NSGlobalDomain com.apple.Safari ProxiesInBookmarksBar "()"'
        'defaults write NSGlobalDomain com.apple.Safari IncludeDevelopMenu -bool true'
        'defaults write NSGlobalDomain com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true'
        'defaults write NSGlobalDomain com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true'
        'defaults write NSGlobalDomain WebKitDeveloperExtras -bool true'
        'defaults write NSGlobalDomain com.apple.Terminal StringEncodings -array 4'
        'defaults write NSGlobalDomain com.apple.Terminal ShellExitAction 2'
        'defaults write NSGlobalDomain com.apple.Terminal FontAntialias 1'
        'defaults write NSGlobalDomain com.apple.Terminal Shell "/bin/zsh"'
        'defaults write NSGlobalDomain com.apple.Terminal "Default Window Settings" "Pro"'
        'defaults write NSGlobalDomain com.apple.Terminal "Startup Window Settings" "Pro"'
        'defaults write NSGlobalDomain com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true'
        'hash tmutil &> /dev/null && sudo tmutil disablelocal'
        'defaults write NSGlobalDomain com.apple.screensaver askForPassword -int 0'
        'defaults write NSGlobalDomain com.apple.screensaver askForPasswordDelay -int 0'
        'defaults write NSGlobalDomain com.apple.LaunchServices LSQuarantine -bool false'
        'sudo pmset -a hibernatemode 0'
        'sudo pmset -a standbydelay 86400'
        'sudo touch /private/var/db/.AccessibilityAPIEnabled'
        'defaults write NSGlobalDomain com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking true'
        'defaults write NSGlobalDomain com.apple.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag 1'
        'defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior 1'
        'defaults write NSGlobalDomain com.apple.mouse.tapBehavior 1'
        'defaults write NSGlobalDomain com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 40'
        'sudo defaults NSGlobalDomain write /Library/Preferences/com.apple.AppleFileServer guestAccess false'
        'sudo defaults NSGlobalDomain write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess false'
        'defaults write NSGlobalDomain com.apple.NetworkBrowser BrowseAllInterfaces true'
        'defaults write NSGlobalDomain com.apple.menuextra.battery ShowPercent "YES"'
        'defaults write NSGlobalDomain com.apple.BezelServices kDim true'
        'defaults write NSGlobalDomain com.apple.BezelServices kDimTime 300'
        'defaults write NSGlobalDomain com.apple.iTunes disablePingSidebar true'
        'defaults write NSGlobalDomain com.apple.iTunes disablePing true'
        'defaults write NSGlobalDomain com.apple.menuextra.battery ShowPercent -string "YES"'
        'defaults write NSGlobalDomain com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" "/System/Library/CoreServices/Menu Extras/AirPort.menu" "/System/Library/CoreServices/Menu Extras/Battery.menu" "/System/Library/CoreServices/Menu Extras/Clock.menu"'
        'defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2'
        'systemsetup -setcomputersleep Off > /dev/null'
        'defaults write NSGlobalDomain com.apple.SoftwareUpdate ScheduleFrequency -int 1'
        'defaults write NSGlobalDomain com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"'
        'defaults write NSGlobalDomain com.apple.dashboard mcx-disabled -bool true'
        'defaults write NSGlobalDomain com.apple.dock dashboard-in-overlay -bool true'
        'defaults write NSGlobalDomain com.apple.dock autohide-delay -float 0'
        'defaults write NSGlobalDomain com.apple.dock autohide -bool false'
        'sudo defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser'
        'sudo ln -sfv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons'
        'sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist'
        'sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist'
        'sudo mkdir -p /etc/resolver'
        'sudo cp -rf $source_dir/templates/dev /etc/resolver'
        'dscacheutil -flushcache'
        'sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName'
        'defaults write com.apple.dock persistent-apps -array'
        'defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Safari.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"'
    )
    

    i=15
    for formula in "${formulas[@]}"
    do
        ((i += 1))
        percent="$((i))"
        eval $formula
        echo "$percent $formula $percent%"; sleep 0.1
    done > >($source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --title "Defaulting System")

    defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
    defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'
    
    cp $source_dir/extras/Large.jpg /Library/Desktop\ Pictures/

    echo "-------- Setting Startup Apps"
    osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/GeekTool.app", hidden:false}'
    

    echo "-------- Killing Finder and dock"
    for app in Finder Dock Mail Safari iTunes
    do
        killall "$app" > /dev/null 2>&1
    done

    rm -f /tmp/hpipe
    mkfifo /tmp/hpipe

    echo "-------- Software updates"
    $source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --indeterminate --title "Software Updates" --text "Please wait..." < /tmp/hpipe &
    exec 3<> /tmp/hpipe
    echo -n . >&3

    sudo softwareupdate -i -a

    echo "-------- Setting Background"
    osascript -e 'tell Application "Finder" to set desktop picture to {"Macintosh HD:Library:Desktop Pictures:Large.jpg"} as alias'

    exec 3>&-
    
    rm -f /tmp/hpipe
    
    rv=`$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --no-newline \
        --text "Is this a 'shared' computer (e.g Lab) or a 'single use' computer (e.g teaching station)?" \
        --button1 "Shared" --button2 "Single use"`
    if [ "$rv" == "1" ]; then
        rv=`$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --no-newline \
            --text "Take a moment and customize the perferences." \
            --informative-text "Dock apps, system prefrences, etc. What you see for this user is what students and staff will see. Press 'continue' when you are ready." \
            --button1 "Continue"`
        if [ "$rv" == "1" ]; then
            rm -f /tmp/hpipe
            mkfifo /tmp/hpipe

            $source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --indeterminate --title "Customizing Profiles" --text "Copying configurations ..." < /tmp/hpipe &
            exec 3<> /tmp/hpipe
            echo -n . >&3

            sudo rm -rf /System/Library/User\ Template/English.lproj/Library/*
            sudo rsync -r /Users/administrator/Library/* /System/Library/User\ Template/English.lproj/Library/

            exec 3>&-
            
            rm -f /tmp/hpipe
        fi
    fi

    sudo rm -rf /System/Library/User\ Template/English.lproj/Library/Keychain
    sudo rm -rf /System/Library/User\ Template/English.lproj/Library/Saved\ Application\ State
fi