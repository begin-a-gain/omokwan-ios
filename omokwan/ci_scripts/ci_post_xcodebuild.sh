#!/bin/bash

set -e
export TZ=Asia/Seoul

echo "📦 Starting CI Post Xcodebuild Script"
echo "📂 Current directory: $(pwd)"
echo "================================================"
echo ""

# === 빌드 성공/실패 판단 ===
EXIT_CODE="${CI_XCODEBUILD_EXIT_CODE:-1}"

if [ "$EXIT_CODE" = "0" ]; then
    BUILD_STATUS="success"
    echo "✅ Build succeeded!"
else
    BUILD_STATUS="failure"
    echo "❌ Build failed with exit code: $EXIT_CODE"
fi

echo ""

# === 빌드 결과 정보 ===
INFOPLIST_FILE="../Projects/Omokwan/Support/Info.plist"
VERSION_NAME=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")

echo "📊 Build Result Information:"
echo "   Workflow: ${CI_WORKFLOW:-Unknown}"
echo "   Build Version: ${VERSION_NAME}
echo "   Build Number: ${CI_BUILD_NUMBER:-Unknown}"

# === Discord 알림 전송 ===
if [ -f "post_xcodebuild/send_discord.sh" ]; then
    chmod +x post_xcodebuild/send_discord.sh
    
    if [ "$BUILD_STATUS" = "success" ]; then
        ./post_xcodebuild/send_discord.sh \
            "✅ 빌드 성공!" \
            "Xcode Cloud 빌드가 성공적으로 완료되었습니다.\n곧 TestFlight에 업로드됩니다." \
            "${VERSION_NAME}" \
            3066993
    else
        ./post_xcodebuild/send_discord.sh \
            "❌ 빌드 실패" \
            "Xcode Cloud 빌드가 실패했습니다.\n로그를 확인해주세요." \
            "${VERSION_NAME}" \
            15158332
    fi
else
    echo "⚠️  send_discord.sh not found, skipping Discord notification"
fi

echo ""
echo "================================================"
echo "✅ CI Post Xcodebuild Script Completed!"
echo "================================================"

if [ "$BUILD_STATUS" = "failure" ]; then
    exit 1
fi

exit 0
