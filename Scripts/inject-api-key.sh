#!/bin/bash

# Script to inject API key during build time
# This script should be run as a build phase in Xcode

set -e

# Check if API key is provided
if [ -z "$REBRICKABLE_API_KEY" ]; then
    echo "error: REBRICKABLE_API_KEY environment variable is required"
    echo "Please set REBRICKABLE_API_KEY in your build environment"
    exit 1
fi

# Create the APIKeyInjected.swift file with the API key
# Use current directory if SRCROOT is not set (for manual testing)
if [ -z "$SRCROOT" ]; then
    SRCROOT="$(pwd)"
fi
API_KEY_FILE="${SRCROOT}/Brixie/Brixie/APIKeyInjected.swift"

cat > "$API_KEY_FILE" << EOF
//
//  APIKeyInjected.swift
//  Brixie
//
//  This file is generated during build time - DO NOT EDIT MANUALLY
//  DO NOT COMMIT THIS FILE TO VERSION CONTROL
//

import Foundation

let REBRICKABLE_API_KEY_INJECTED = "$REBRICKABLE_API_KEY"
EOF

echo "API key injected successfully"