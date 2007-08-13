#!/bin/bash
echo "Setting NSUseRunningCopy..."
defaults write NSGlobalDomain NSUseRunningCopy YES
echo "Setting some GWorkspace settings in Etoile context"
defaults write GWorkspace NoWarnOnQuit YES
defaults write NSGlobalDomain GSWorkspaceApplication "NotExist.app"
