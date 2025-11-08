#!/bin/bash

set -e
export TZ=Asia/Seoul

echo "Current Workflow Name: $CI_WORKFLOW"
echo "Build Scheme: $CI_XCODEBUILD_SCHEME"
echo "post xcodebuild"