#!/bin/sh

set -e

TCA_SWIFT6_MANIFEST=".build/checkouts/swift-composable-architecture/Package@swift-6.0.swift"

if [ -f "$TCA_SWIFT6_MANIFEST" ]; then
    echo "🩹 Disabling TCA Swift 6 manifest for compatibility..."
    mv "$TCA_SWIFT6_MANIFEST" "${TCA_SWIFT6_MANIFEST}.disabled"
    echo "✓ TCA Swift 6 manifest disabled"
fi
