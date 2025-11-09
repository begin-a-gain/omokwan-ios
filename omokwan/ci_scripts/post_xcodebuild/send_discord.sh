#!/bin/sh

set -e
export TZ=Asia/Seoul

# === 파라미터 받기 ===
TITLE=$1 # (예: "✅ 빌드 성공!")
MESSAGE=$2 # 메시지 내용
VERSION_NAME=$3
COLOR=$4 # 색상 (10진수, 예: 3066993=초록, 15158332=빨강)

if [ -z "$DISCORD_WEBHOOK_URL" ]; then
    echo "⚠️  DISCORD_WEBHOOK_URL이 설정되지 않았습니다."
    echo "   Discord 알림을 건너뜁니다."
    exit 0
fi

WORKFLOW="${CI_WORKFLOW:-Unknown}"
BUILD_NUMBER="${CI_BUILD_NUMBER:-Unknown}"
BUILD_ID="${CI_BUILD_ID:-Unknown}"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S %Z")
COMMIT_SHORT="${COMMIT:0:7}"

PAYLOAD=$(cat <<EOF
{
  "embeds": [
    {
      "title": "$TITLE",
      "description": "$MESSAGE",
      "color": $COLOR,
      "fields": [
        {
          "name": "🔧 Workflow",
          "value": "$WORKFLOW",
          "inline": true
        },
        {
          "name": "🔢 Version Info",
          "value": "$VERSION_NAME ($BUILD_NUMBER)",
          "inline": true
        },
        {
          "name": "💾 Commit",
          "value": "\`$COMMIT_SHORT\`",
          "inline": true
        }
      ],
      "footer": {
        "text": "Xcode Cloud • Build ID: $BUILD_ID"
      },
      "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    }
  ]
}
EOF
)

# === Discord로 전송 ===
echo "📨 Sending Discord notification..."
echo "   Title: $TITLE"
echo "   Workflow: $WORKFLOW"
echo "   Build #: $BUILD_NUMBER"

RESPONSE=$(curl -X POST "$DISCORD_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  -w "\n%{http_code}" \
  -s)

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

if [ "$HTTP_CODE" = "204" ] || [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Discord notification sent successfully! (HTTP $HTTP_CODE)"
else
    echo "⚠️  Discord notification failed (HTTP $HTTP_CODE)"
    echo "   Response: $RESPONSE"
fi

exit 0
