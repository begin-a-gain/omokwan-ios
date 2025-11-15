#!/bin/bash

echo "📂 Current directory: $(pwd)"
INFO_PLIST_PATH="../../Projects/Omokwan/Support/Info.plist"
CURRENT_BUILD_NUMBER=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFO_PLIST_PATH")

echo "Xcode Cloud Build Number: $CURRENT_BUILD_NUMBER"

git config --global user.name "Jumy"
git config --global user.email "kdjun97@gmail.com"

git add "$INFO_PLIST_PATH"
git commit -m "Sync build number to $CURRENT_BUILD_NUMBER [ci skip]"

REPO_URL=$(git config --get remote.origin.url)
if [[ "$REPO_URL" == git@* ]]; then
    REPO_URL=$(echo "$REPO_URL" | sed -E 's/git@(.*):(.*)\.git/https:\/\/\1\/\2.git/')
fi

git push "https://$GIT_TOKEN@${REPO_URL#https://}" HEAD --ff-only

echo "Build number synced to git successfully."
