#!/bin/bash

echo "VERCEL_ENV: $VERCEL_ENV"
echo "VERCEL_GIT_COMMIT_REF: $VERCEL_GIT_COMMIT_REF"
echo "VERCEL_GIT_COMMIT_SHA: $VERCEL_GIT_COMMIT_SHA"
echo "VERCEL_TARGET_ENV: $VERCEL_TARGET_ENV"
echo "ALLOW_DEPLOY_HOOK: $ALLOW_DEPLOY_HOOK"

# Function to determine if it's a production Deploy Hook build
is_deploy_hook_build() {
    [[ -z "$VERCEL_TARGET_ENV" || "$VERCEL_TARGET_ENV" == "production" && "$ALLOW_DEPLOY_HOOK" == "false" ]]
}

# Check if it's a production Deploy Hook build
if is_deploy_hook_build; then
    echo "This is a production Deploy Hook build"
    echo "🛑 - Deploy Hook build not allowed for production environment"
    exit 0
else
# This could be a preview Deploy Hook build or any Git push build
  echo "✅ - Build allowed for $VERCEL_TARGET_ENV environment"
  exit 1
fi