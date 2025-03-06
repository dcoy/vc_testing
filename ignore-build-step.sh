#!/bin/bash

# Get the current branch name
CURRENT_BRANCH=${VERCEL_GIT_COMMIT_REF:-main}
echo "Current branch: $CURRENT_BRANCH"

# For vc-testing project
if [[ "$VERCEL_PROJECT_NAME" == "vc-testing" ]]; then
  # If the current branch is exactly legacy-docs, build it
  if [[ "$CURRENT_BRANCH" == "legacy-docs" ]]; then
    echo "Building vc-testing as it's the legacy-docs branch itself"
    exit 1  # Continue the build
  fi
  
  # Check if the branch is a child of legacy-docs
  if git merge-base --is-ancestor origin/legacy-docs HEAD 2>/dev/null; then
    # If we reach here, it means the branch is a child of legacy-docs
    echo "Skipping build for vc-testing as it's a child branch of legacy-docs"
    exit 0  # Skip the build
  fi
  
  # For all other branches, continue the build
  echo "Building vc-testing as it's not related to legacy-docs"
  exit 1  # Continue the build
fi

# For all other projects, continue the build
echo "Building other project: $VERCEL_PROJECT_NAME"
exit 1