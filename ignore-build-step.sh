#!/bin/bash

echo "VERCEL_ENV: $VERCEL_ENV"
echo "VERCEL_GIT_COMMIT_REF: $VERCEL_GIT_COMMIT_REF"
echo "VERCEL_GIT_COMMIT_SHA: $VERCEL_GIT_COMMIT_SHA"
echo "ALLOW_DEPLOY_HOOK: $ALLOW_DEPLOY_HOOK"

# Function to determine if it's a Deploy Hook build
is_deploy_hook_build() {
    [[ -z "$VERCEL_GIT_COMMIT_SHA" && "$VERCEL_GIT_COMMIT_REF" == "main" ]]
}

# Check if it's a git push or Deploy Hook
if is_deploy_hook_build; then
    echo "This is a Deploy Hook build"
    # Only build if ALLOW_DEPLOY_HOOK is true
    if [[ "$ALLOW_DEPLOY_HOOK" == "true" ]]; then
        echo "✅ - Deploy Hook build allowed for this environment"
        exit 1
    else
        echo "🛑 - Deploy Hook build not allowed for this environment"
        exit 0
    fi
else
    echo "This is a Git push build"
    # Always allow Git push builds
    echo "✅ - Git push build allowed"
    exit 1
fi
