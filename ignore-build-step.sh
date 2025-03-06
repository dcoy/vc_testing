#!/bin/bash

# Get the current branch name
CURRENT_BRANCH=${VERCEL_GIT_COMMIT_REF:-main}
echo "Current branch: $CURRENT_BRANCH"

# For vc-testing project
if [[ "$VERCEL_PROJECT_NAME" == "vc-testing" ]]; then
  # Check if the branch is based on legacy-docs
  # This checks if legacy-docs is an ancestor of the current branch
  if git merge-base --is-ancestor origin/legacy-docs HEAD 2>/dev/null; then
    echo "Building vc-testing as it's based on legacy-docs branch"
    exit 1  # Continue the build
  else
    echo "Skipping build for vc-testing as it's not based on legacy-docs branch"
    exit 0  # Skip the build
  fi
fi