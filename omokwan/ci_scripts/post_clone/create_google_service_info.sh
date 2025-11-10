#!/bin/sh

set -e
export TZ=Asia/Seoul

# === 환경 변수 검증 함수 ===
check_required_vars() {
    local missing_vars=""
    
    for var_name in "$@"; do
        eval var_value=\$$var_name
        
        if [ -z "$var_value" ]; then
            missing_vars="$missing_vars\n  - $var_name"
        fi
    done
    
    if [ -n "$missing_vars" ]; then
        echo "❌ 필수 환경 변수가 설정되지 않았습니다:"
        echo -e "$missing_vars"
        return 1
    fi
    
    return 0
    # return 0: 함수가 성공했음을 알림
}

create_firebase_plist() {
    local env=$1
    
    local filename="GoogleService-Info-${env}.plist"
    
    local bundle_id
    if [ "$env" = "Dev" ]; then
        local env_upper="DEV"
        bundle_id="com.begin-a-gain.omokwang.dev"
    else
        local env_upper="PROD"
        bundle_id="com.begin-a-gain.omokwang.prod"
    fi
    
    echo "📝 Creating $filename..."
    
    eval api_key=\$FIREBASE_API_KEY
    eval gcm_sender_id=\$GCM_SENDER_ID
    eval project_id=\$FIREBASE_PROJECT_ID
    eval storage_bucket=\$FIREBASE_STORAGE_BUCKET
    eval app_id=\$FIREBASE_GOOGLE_APP_ID_${env_upper}
    
    cat > "$FIREBASE_DIR/$filename" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>API_KEY</key>
	<string>${api_key}</string>
	<key>GCM_SENDER_ID</key>
	<string>${gcm_sender_id}</string>
	<key>PLIST_VERSION</key>
	<string>1</string>
	<key>BUNDLE_ID</key>
	<string>${bundle_id}</string>
	<key>PROJECT_ID</key>
	<string>${project_id}</string>
	<key>STORAGE_BUCKET</key>
	<string>${storage_bucket}</string>
	<key>IS_ADS_ENABLED</key>
	<false></false>
	<key>IS_ANALYTICS_ENABLED</key>
	<false></false>
	<key>IS_APPINVITE_ENABLED</key>
	<true></true>
	<key>IS_GCM_ENABLED</key>
	<true></true>
	<key>IS_SIGNIN_ENABLED</key>
	<true></true>
	<key>GOOGLE_APP_ID</key>
	<string>${app_id}</string>
</dict>
</plist>
EOF

    if [ ! -f "$FIREBASE_DIR/$filename" ]; then
        echo "❌ Failed to create $filename"
        return 1
    fi
    
    echo "✓ $filename created"
    echo ""
    return 0
}

echo "🔥 Creating Firebase configuration files..."
echo "================================================"

# Firebase 디렉토리 생성
FIREBASE_DIR="Projects/Omokwan/Resources/Firebase"
echo "📁 Creating Firebase directory..."
mkdir -p "$FIREBASE_DIR" || {
    echo "❌ Failed to create Firebase directory"
    exit 1
}
echo "✓ Firebase directory ready: $FIREBASE_DIR"

check_required_vars \
    FIREBASE_API_KEY \
    FIREBASE_GOOGLE_APP_ID_DEV \
    FIREBASE_GOOGLE_APP_ID_PROD \
    FIREBASE_PROJECT_ID \
    FIREBASE_STORAGE_BUCKET \
    GCM_SENDER_ID || {
    echo ""
    echo "❌ Dev 환경 변수가 설정되지 않았습니다."
    exit 1
}

create_firebase_plist "Dev" || exit 1
create_firebase_plist "Prod" || exit 1

# === 생성 완료 ===
echo ""
echo "================================================"
echo "✅ All Firebase config files created successfully!"
echo ""
echo "📂 Firebase directory contents:"
ls -la "$FIREBASE_DIR"
echo ""