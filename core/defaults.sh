# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh
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
        'defaults write com.apple.finder AppleShowAllFiles FALSE'
        'defaults write com.apple.finder EmptyTrashSecurely -bool true'
        'defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false'
        'defaults write com.apple.Finder FXPreferredViewStyle -string "Nlsv"'
        'defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"'
        'defaults write com.apple.finder _FXShowPosixPathInTitle -bool NO'
        'defaults write com.apple.finder QLEnableTextSelection -bool true'
        'defaults write com.apple.finder ShowPathbar -bool true'
        'defaults write com.apple.finder ShowStatusBar -bool true'
        'defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true'
        '/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist'
        '/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist'
        'defaults write com.apple.dock tilesize -int 36'
        'defaults write com.apple.dock expose-animation-duration -float 0.5'
        'defaults write com.apple.dock "expose-group-by-app" -bool true'
        'defaults write com.apple.dock itunes-notifications -bool true'
        'defaults write com.apple.dock show-process-indicators -bool true'
        'defaults write com.apple.dock showhidden -bool true'
        'find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete'
        'defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2'
        'defaults write com.apple.Safari IncludeInternalDebugMenu -bool true'
        'defaults write com.apple.Safari ProxiesInBookmarksBar "()"'
        'defaults write com.apple.Safari IncludeDevelopMenu -bool true'
        'defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true'
        'defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true'
        'defaults write NSGlobalDomain WebKitDeveloperExtras -bool true'
        'defaults write com.apple.Terminal StringEncodings -array 4'
        'defaults write com.apple.Terminal ShellExitAction 2'
        'defaults write com.apple.Terminal FontAntialias 1'
        'defaults write com.apple.Terminal Shell "/bin/zsh"'
        'defaults write com.apple.Terminal "Default Window Settings" "Pro"'
        'defaults write com.apple.Terminal "Startup Window Settings" "Pro"'
        'defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true'
        'hash tmutil &> /dev/null && sudo tmutil disablelocal'
        'defaults write com.apple.screensaver askForPassword -int 0'
        'defaults write com.apple.screensaver askForPasswordDelay -int 0'
        'defaults write com.apple.LaunchServices LSQuarantine -bool false'
        'sudo rm /private/var/vm/sleepimage'
        'sudo touch /Private/var/vm/sleepimage'
        'sudo chflags uchg /Private/var/vm/sleepimage'
        'sudo pmset -a hibernatemode 0'
        'sudo pmset -a standbydelay 86400'
        'sudo touch /private/var/db/.AccessibilityAPIEnabled'
        'defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true'
        'defaults write com.apple.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1'
        'defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1'
        'defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1'
        'defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40'
        'sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false'
        'sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false'
        'defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true'
        'defaults write com.apple.menuextra.battery ShowPercent -string "YES"'
        'defaults write com.apple.BezelServices kDim -bool true'
        'defaults write com.apple.BezelServices kDimTime -int 300'
        'defaults write com.apple.iTunes disablePingSidebar -bool true'
        'defaults write com.apple.iTunes disablePing -bool true'
        'defaults write com.apple.menuextra.battery ShowPercent -string "YES"'
        'defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" "/System/Library/CoreServices/Menu Extras/AirPort.menu" "/System/Library/CoreServices/Menu Extras/Battery.menu" "/System/Library/CoreServices/Menu Extras/Clock.menu"'
        'defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2'
        'systemsetup -setcomputersleep Off > /dev/null'
        'defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1'
        'defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"'
        'defaults write com.apple.dashboard mcx-disabled -bool true'
        'defaults write com.apple.dock dashboard-in-overlay -bool true'
        'defaults write com.apple.dock autohide-delay -float 0'
        'defaults write com.apple.dock autohide -bool false'
        'sudo defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser'
    )

    i=15
    for formula in "${formulas[@]}"
    do
        ((i += 1))
        percent="$((i))"
        eval $formula
        echo "$percent Setting Defaults... $percent%"; sleep 0.05
    done > >($source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --title "Defaulting System")
    
    osascript -e 'tell Application "Finder"' -e 'set the desktop picture to {"$source_dir/extras/Large.jpg"} as alias' -e 'end tell'

    for app in Finder Dock Mail Safari iTunes
    do
        killall "$app" > /dev/null 2>&1
    done

    $source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar --indeterminate --title "Performing System Updates" & sudo softwareupdate -i -a

    rv=`$source_dir/extras/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --no-newline \
        --text "Take a moment and customize the perferences." \
        --informative-text "Dock apps, system prefrences, etc. What you see for this user is what students and staff will see. Press 'continue' when you are ready." \
        --button1 "Continue"`
    if [ "$rv" == "1" ]; then
        echo "User likes Macs"
    fi
fi
