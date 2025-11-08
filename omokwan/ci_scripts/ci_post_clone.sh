#!/bin/sh

set -e
export TZ=Asia/Seoul

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

echo "🎬 Starting CI Post Clone Script"
echo "📂 Current directory: $(pwd)"
cd ..
echo "📂 Current directory: $(pwd)"
echo "================================================"

# === 1. 초기 환경 체크 ===
if [ -f "ci_scripts/post_clone/check_initial_environment.sh" ]; then
    chmod +x ci_scripts/post_clone/check_initial_environment.sh
    ./ci_scripts/post_clone/check_initial_environment.sh || {
        echo "❌ Environment check failed!"
        exit 1
    }
else
    echo "❌ ci_scripts/post_clone/check_initial_environment.sh not found!"
    exit 1
fi

# === 2. mise & Tuist 설치 ===
if [ -f "ci_scripts/post_clone/setup_mise_and_tuist.sh" ]; then
    chmod +x ci_scripts/post_clone/setup_mise_and_tuist.sh
    ./ci_scripts/post_clone/setup_mise_and_tuist.sh || {
        echo "❌ mise & Tuist setup failed!"
        exit 1
    }
else
    echo "❌ setup_mise_and_tuist.sh not found!"
    exit 1
fi

# === 3. XCConfig 생성 ===
echo "🎬 Running XCConfig creation script..."

if [ -f "ci_scripts/post_clone/create_xcconfig.sh" ]; then
    chmod +x ci_scripts/post_clone/create_xcconfig.sh
    
    ./ci_scripts/post_clone/create_xcconfig.sh || {
        echo "❌ XCConfig creation script failed!"
        echo "   Please check your environment variables in Xcode Cloud:"
        echo "   - KAKAO_NATIVE_APP_KEY_DEV"
        echo "   - API_BASE_URL_DEV"
        echo "   - KAKAO_NATIVE_APP_KEY_PROD"
        echo "   - API_BASE_URL_PROD"
        exit 1
    }
else
    echo "❌ create_xcconfig.sh not found in ci_scripts/post_clone/"
    exit 1
fi

# === 4. xcode 프로젝트 파일 생성 === 
echo "🧹 Running make clean..."
make clean || {
    echo "❌ make clean 실패!"
    echo "   Makefile이 있는지, clean 타겟이 정의되어 있는지 확인해주세요."
    exit 1
}

echo "✅ Clean completed!"
echo ""

echo "🔨 Running make generate..."
mise exec -- make generate || {
    echo "❌ make generate 실패!"
    echo "   의존성 설치 또는 프로젝트 생성 중 문제가 발생했습니다."
    echo "   로컬에서 'make generate' 명령어를 실행해서 문제를 확인해주세요."
    exit 1
}

echo "✅ Generate completed!"
