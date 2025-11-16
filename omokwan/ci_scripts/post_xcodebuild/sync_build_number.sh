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

    # GitHub repo 풀네임 가져오기
    REPO_FULL_NAME=$(git config --get remote.origin.url | sed -E 's#.*github.com[:/](.*)\.git#\1#')
    echo "🔍 Repo Full Name: $REPO_FULL_NAME"

    COMMIT_SHA=$(git rev-parse HEAD)
    echo "🔍 Current Commit SHA: $COMMIT_SHA"

    HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" \
    -H "Authorization: token $GIT_TOKEN" \
    "https://api.github.com/repos/$REPO_FULL_NAME/commits/$COMMIT_SHA/branches-where-head")

    # 마지막 줄이 상태코드, 나머지는 JSON 본문
    HTTP_STATUS=$(echo "$HTTP_RESPONSE" | tail -n1)
    BRANCHES_JSON=$(echo "$HTTP_RESPONSE" | sed '$d')

    echo "🌐 GitHub API Status Code: $HTTP_STATUS"

    if [[ "$HTTP_STATUS" != "200" ]]; then
        echo "❌ GitHub API request failed!"
        echo "Raw response:"
        echo "$BRANCHES_JSON"
        exit 1
    fi

    echo "📩 Raw BRANCHES_JSON response:"
    echo "$BRANCHES_JSON"

    # JSON 유효성 검사
    echo "$BRANCHES_JSON" | jq empty 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "❌ Invalid JSON received!"
        exit 1
    else
        echo "✅ JSON is valid"
    fi

    # 브랜치 목록 파싱
    BRANCHES=$(echo "$BRANCHES_JSON" | jq -r '.[].name')

    echo "🧵 Branch list from API:"
    echo "$BRANCHES"

    BRANCH_COUNT=$(echo "$BRANCHES" | wc -l | tr -d ' ')
    echo "📌 Branch count: $BRANCH_COUNT"

    TARGET_BRANCH=""

    echo "🔎 Applying priority matching..."
    for PRIORITY in release-candidate development; do
        echo " - Checking priority: $PRIORITY"

        for B in $BRANCHES; do
            echo "   > Found branch from API: $B"
            if [[ "$B" == "$PRIORITY"* ]]; then
                TARGET_BRANCH="$B"
                echo "   🎯 Priority match found: $TARGET_BRANCH"
                break 2
            fi
        done
    done

    if [ -z "$TARGET_BRANCH" ]; then
        echo "⚠️  No suitable branch found to push. Exiting."
        exit 1
    fi

    echo "🚀 Final target branch selected: $TARGET_BRANCH"

    echo "📤 Executing: git push HEAD:refs/heads/$TARGET_BRANCH"
    git push "https://$GIT_TOKEN@${REPO_URL#https://}" \
        HEAD:refs/heads/$TARGET_BRANCH

    echo "✅ Build number synced to git successfully."
    fi
else
    echo "Build number already up-to-date, skipping"
fi