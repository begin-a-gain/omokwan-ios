#!/bin/sh

set -e

error_handler() {
    ERROR_LINE=$1
    ERROR_TIME=$(date "+%Y-%m-%d %H:%M:%S")
    
    echo ""
    echo "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
    echo "❌ 에러 발생!"
    echo "❌ 시간: $ERROR_TIME"
    echo "❌ 라인: $ERROR_LINE"
    echo "❌ 스크립트가 중단되었습니다."
    echo "❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
    echo ""
    
    exit 1
}

trap 'error_handler $LINENO' ERR

# === 작업 디렉토리 확인 및 이동 ===
echo "📂 Current directory: $(pwd)"
cd ..
echo "📂 Moved to project root: $(pwd)"

START_TIME=$(date "+%Y-%m-%d %H:%M:%S")

echo "📥 Installing mise... (Time: $START_TIME)"
echo "================================================"
curl https://mise.jdx.dev/install.sh | sh || {
    echo "❌ mise 설치 실패!"
    exit 1
}

# === PATH 설정 ===
export PATH="$HOME/.local/bin:$PATH"

echo "📥 Installing Tuist from .mise.toml..."
mise install tuist || {
    echo "❌ Tuist 설치 실패!"
    echo "   .mise.toml 파일이 있는지 확인해주세요."
    exit 1
}

# === mise activate ===
echo "🔧 Activating mise..."
eval 
eval "$(mise activate bash --shims)" || {
    echo "⚠️  mise activate 실패! (계속 진행합니다)"
}

echo "🔍 Running mise doctor..."
mise doctor || {
    echo "⚠️  mise doctor에서 경고가 있지만 계속 진행합니다."
}

echo "🔍 Checking mise version..."
MISE_VERSION=$(mise --version) || {
    echo "❌ mise 버전 확인 실패! mise가 제대로 설치되지 않았을 수 있습니다."
    exit 1
}
echo "✓ mise 버전: $MISE_VERSION"
echo "------------------------------------------------"

echo "🔍 Checking Tuist version..."
TUIST_VERSION=$(mise exec -- tuist version) || {
    echo "❌ Tuist 버전 확인 실패! Tuist가 제대로 설치되지 않았을 수 있습니다."
    exit 1
}
echo "✓ Tuist 버전: $TUIST_VERSION"

END_TIME=$(date "+%Y-%m-%d %H:%M:%S")
echo "================================================"
echo "✅ Tuist installation completed! (완료: $END_TIME)"
echo ""

# Makefile 존재 확인
echo "🔍 Checking for Makefile..."
if [ ! -f "Makefile" ]; then
    echo "❌ Makefile not found in $(pwd)"
    echo "📂 Directory contents:"
    ls -la
    exit 1
fi
echo "✓ Makefile found in $(pwd)"

echo "🧹 Running make clean..."
mise exec -- make clean || {
    echo "❌ make clean 실패!"
    echo "   Makefile이 있는지, clean 타겟이 정의되어 있는지 확인해주세요."
    exit 1
}

echo "✅ Clean completed!"
echo ""

echo "🎬 Running XCConfig creation script..."

if [ -f "ci_scripts/create_xcconfig.sh" ]; then
    chmod +x ci_scripts/create_xcconfig.sh
    
    ./ci_scripts/create_xcconfig.sh || {
        echo "❌ XCConfig creation script failed!"
        echo "   Please check your environment variables in Xcode Cloud:"
        echo "   - KAKAO_NATIVE_APP_KEY_DEV"
        echo "   - API_BASE_URL_DEV"
        echo "   - KAKAO_NATIVE_APP_KEY_PROD"
        echo "   - API_BASE_URL_PROD"
        exit 1
    }
else
    echo "❌ create_xcconfig.sh not found in ci_scripts/"
    exit 1
fi

echo "🔨 Running make generate..."
mise exec -- make generate || {
    echo "❌ make generate 실패!"
    echo "   의존성 설치 또는 프로젝트 생성 중 문제가 발생했습니다."
    echo "   로컬에서 'make generate' 명령어를 실행해서 문제를 확인해주세요."
    exit 1
}

echo "✅ Generate completed!"
