#!/bin/bash

echo "📂 Current directory: $(pwd)"
INFO_PLIST_PATH="../Projects/Omokwan/Support/Info.plist"
CURRENT_BUILD_NUMBER=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFO_PLIST_PATH")
XCLOUD_BUILD_NUMBER="${CI_BUILD_NUMBER:-$CURRENT_BUILD_NUMBER}"

echo "Info.plist Build Number: $CURRENT_BUILD_NUMBER"
echo "Xcode Cloud Build Number: $XCLOUD_BUILD_NUMBER"

echo "CI_BRANCH: ${CI_BRANCH:-<empty>}"
echo "XCODE_BRANCH: ${XCODE_BRANCH:-<empty>}"

# 다르면 업데이트
if [ "$CURRENT_BUILD_NUMBER" != "$XCLOUD_BUILD_NUMBER" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $XCLOUD_BUILD_NUMBER" "$INFO_PLIST_PATH"
    echo "Info.plist updated to $XCLOUD_BUILD_NUMBER"

    git config --global user.name "Jumy"
    git config --global user.email "kdjun97@gmail.com"

    git add "$INFO_PLIST_PATH"

    # 실제로 staged 변경 사항 있는지 확인
    if git diff --cached --quiet; then
        echo "No changes to commit"
    else
        git commit -m "Sync build number to $XCLOUD_BUILD_NUMBER [ci skip]"

        REPO_URL=$(git config --get remote.origin.url)
        if [[ "$REPO_URL" == git@* ]]; then
            REPO_URL=$(echo "$REPO_URL" | sed -E 's/git@(.*):(.*)\.git/https:\/\/\1\/\2.git/')
        fi

        BRANCHES_JSON=$(curl -s -H "Authorization: token $GIT_TOKEN" \
          "https://api.github.com/repos/$(git config --get remote.origin.url | sed -E 's#.*github.com[:/](.*)\.git#\1#')/commits/$(git rev-parse HEAD)/branches-where-head")

        BRANCHES=$(echo "$BRANCHES_JSON" | jq -r '.[].name')

        TARGET_BRANCH=""

        # 우선순위 적용
        for PRIORITY in release-candidate development; do
            for B in $BRANCHES; do
                if [[ "$B" == "$PRIORITY"* ]]; then
                    TARGET_BRANCH="$B"
                    break 2
                fi
            done
        done

        if [ -z "$TARGET_BRANCH" ]; then
            echo "⚠️  No suitable branch found to push. Exiting."
            exit 1
        fi

        echo "Target branch selected: $TARGET_BRANCH"
        git push "https://$GIT_TOKEN@${REPO_URL#https://}" HEAD:refs/heads/$TARGET_BRANCH
        echo "Build number synced to git successfully."
    fi
else
    echo "Build number already up-to-date, skipping"
fi