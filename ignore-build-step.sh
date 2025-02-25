#!/bin/bash

echo "VERCEL_ENV: $VERCEL_ENV"
echo "VERCEL_GIT_COMMIT_REF: $VERCEL_GIT_COMMIT_REF"
echo "VERCEL_GIT_COMMIT_SHA: $VERCEL_GIT_COMMIT_SHA"

# Function to determine if it's a Deploy Hook build
is_deploy_hook_build() {
    [[ -z "$VERCEL_GIT_COMMIT_SHA" && "$VERCEL_GIT_COMMIT_REF" == "main" ]]
}

# Check if it's a Deploy Hook build
if is_deploy_hook_build; then
    echo "This is a Deploy Hook build"
    # Allow Deploy Hook builds only for preview environment
    if [[ "$VERCEL_ENV" == "preview" ]]; then
        echo "✅ - Deploy Hook build allowed for preview environment"
        exit 1
    else
        echo "🛑 - Deploy Hook build not allowed for $VERCEL_ENV environment"
        exit 0
    fi
else
    echo "This is a Git push build"
    # Always allow Git push builds
    echo "✅ - Git push build allowed for $VERCEL_ENV environment"
    exit 1
fi
