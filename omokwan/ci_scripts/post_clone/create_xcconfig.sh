#!/bin/sh

set -e

echo "🔧 Creating XCConfig files..."
echo "================================================"

# XCConfig 디렉토리 생성
echo "📁 Creating XCConfig directory..."
mkdir -p XCConfig || {
    echo "❌ Failed to create XCConfig directory"
    exit 1
}
echo "✓ XCConfig directory ready"

# === 1. Shared.xcconfig 생성 ===
echo ""
echo "📝 Creating Shared.xcconfig..."
cat > XCConfig/Shared.xcconfig << 'EOF'
ENABLE_USER_SCRIPT_SANDBOXING = NO
OTHER_LDFLAGS = -ObjC
EOF

# 파일 생성 확인
if [ ! -f "XCConfig/Shared.xcconfig" ]; then
    echo "❌ Failed to create Shared.xcconfig"
    exit 1
fi
echo "✓ Shared.xcconfig created"

# === 2. Dev.xcconfig 생성 ===
echo ""
echo "📝 Creating Dev.xcconfig..."

# 필수 환경 변수 확인
if [ -z "$KAKAO_NATIVE_APP_KEY_DEV" ]; then
    echo "❌ Error: KAKAO_NATIVE_APP_KEY_DEV environment variable is not set"
    echo "   Please set it in Xcode Cloud Environment settings"
    exit 1
fi

if [ -z "$API_BASE_URL_DEV" ]; then
    echo "❌ Error: API_BASE_URL_DEV environment variable is not set"
    echo "   Please set it in Xcode Cloud Environment settings"
    exit 1
fi

cat > XCConfig/Dev.xcconfig << EOF
#include "./Shared.xcconfig"

BUNDLE_IDENTIFIER = com.begin-a-gain.omokwang
BUNDLE_NAME = 오목완 DEV
ENV = Dev
SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEV

KAKAO_NATIVE_APP_KEY = ${KAKAO_NATIVE_APP_KEY_DEV}
API_BASE_URL = ${API_BASE_URL_DEV}
EOF

if [ ! -f "XCConfig/Dev.xcconfig" ]; then
    echo "❌ Failed to create Dev.xcconfig"
    exit 1
fi
echo "✓ Dev.xcconfig created"

# === 3. Prod.xcconfig 생성 ===
echo ""
echo "📝 Creating Prod.xcconfig..."

# 필수 환경 변수 확인
if [ -z "$KAKAO_NATIVE_APP_KEY_PROD" ]; then
    echo "❌ Error: KAKAO_NATIVE_APP_KEY_PROD environment variable is not set"
    echo "   Please set it in Xcode Cloud Environment settings"
    exit 1
fi

if [ -z "$API_BASE_URL_PROD" ]; then
    echo "❌ Error: API_BASE_URL_PROD environment variable is not set"
    echo "   Please set it in Xcode Cloud Environment settings"
    exit 1
fi

cat > XCConfig/Prod.xcconfig << EOF
#include "./Shared.xcconfig"

BUNDLE_IDENTIFIER = com.begin-a-gain.omokwang.prod
BUNDLE_NAME = 오목완
ENV = Prod
SWIFT_ACTIVE_COMPILATION_CONDITIONS = Prod

KAKAO_NATIVE_APP_KEY = ${KAKAO_NATIVE_APP_KEY_PROD}
API_BASE_URL = ${API_BASE_URL_PROD}
EOF

if [ ! -f "XCConfig/Prod.xcconfig" ]; then
    echo "❌ Failed to create Prod.xcconfig"
    exit 1
fi
echo "✓ Prod.xcconfig created"

# === 4. Release.xcconfig 생성 (Prod 복사) ===
echo ""
echo "📝 Creating Release.xcconfig (copying from Prod)..."

cp XCConfig/Prod.xcconfig XCConfig/Release.xcconfig || {
    echo "❌ Failed to copy Prod.xcconfig to Release.xcconfig"
    exit 1
}

if [ ! -f "XCConfig/Release.xcconfig" ]; then
    echo "❌ Failed to create Release.xcconfig"
    exit 1
fi
echo "✓ Release.xcconfig created (copied from Prod)"

echo "================================================"
echo "✅ All XCConfig files created successfully!"
echo "📂 XCConfig directory contents:"
ls -la XCConfig/

echo ""
echo "📄 File sizes:"
du -h XCConfig/*
