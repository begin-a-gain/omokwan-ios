#!/bin/sh

set -e

echo "🏗️  Check inital environment..."
echo "================================================"

## 필수 파일 체크
echo "🔍 Checking required files..."

echo "🔍 Checking for Makefile..."
if [ ! -f "Makefile" ]; then
    echo "❌ Makefile not found in $(pwd)"
    echo "📂 Directory contents:"
    ls -la
    exit 1
fi
echo "✓ Makefile found in $(pwd)"

if [ ! -f ".mise.toml" ]; then
    echo "❌ .mise.toml not found in $(pwd)"
    exit 1
fi
echo "✓ .mise.toml found"

echo ""
echo "✅ Environment check and setup completed!"
echo "================================================"