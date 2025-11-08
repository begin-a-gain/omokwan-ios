#!/bin/sh

#  select_google_service_info.sh
#  Manifests
#
#  Created by jumy on 11/9/25.
#  

set -e

CONFIGURATION="${CONFIGURATION}"
SRC_DIR="${SRCROOT}/Resources/Firebase"
DEST_DIR="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"

echo "🔍 Copying GoogleService-Info for configuration: ${CONFIGURATION}"
echo "📁 Source Dir: ${SRC_DIR}"
echo "📦 Destination Dir: ${DEST_DIR}"

case "${CONFIGURATION}" in
    "Dev")
        cp "${SRC_DIR}/GoogleService-Info-Dev.plist" "${DEST_DIR}/GoogleService-Info.plist"
        ;;
    "Prod")
        cp "${SRC_DIR}/GoogleService-Info-Prod.plist" "${DEST_DIR}/GoogleService-Info.plist"
        ;;
    *)
        echo "⚠️ Unknown configuration: ${CONFIGURATION}"
        exit 1
        ;;
esac

echo "✅ Copied GoogleService-Info-${CONFIGURATION}.plist → ${DEST_DIR}/GoogleService-Info.plist"
