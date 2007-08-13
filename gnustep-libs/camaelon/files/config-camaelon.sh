#!/usr/bin/env bash
echo "Applying Camaelon default theme..."
echo "defaults write NSGlobalDomain GSAppKitUserBundles \"(/usr/GNUstep/System/Library/Bundles/Camaelon.themeEngine)\""
defaults write NSGlobalDomain GSAppKitUserBundles "(/usr/GNUstep/System/Library/Bundles/Camaelon.themeEngine)"
echo "defaults write Camaelon Theme Nesedah"
defaults write Camaelon Theme Nesedah
