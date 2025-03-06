#!/bin/bash

# Get the current branch name
CURRENT_BRANCH=${VERCEL_GIT_COMMIT_REF:-main}

# Get the parent branch (this is a simplified approach)
PARENT_BRANCH=$(git show-branch -a 2>/dev/null | grep '\*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/.*\[$$.*$$\].*/\1/' | sed 's/[\^~].*//')

# For vc-testing project
if [[ "$VERCEL_PROJECT_NAME" == "vc-testing" ]]; then
  # Only build if parent branch is legacy-docs
  if [[ "$PARENT_BRANCH" == "legacy-docs" ]]; then
    # Return 1 to continue the build
    exit 1
  else
    # Return 0 to skip the build
    echo "Skipping build for vc-testing as parent branch is not legacy-docs"
    exit 0
  fi
fi

# For docs project
if [[ "$VERCEL_PROJECT_NAME" == "docs" ]]; then
  # Skip build if parent branch is legacy-docs
  if [[ "$PARENT_BRANCH" == "legacy-docs" ]]; then
    echo "Skipping build for docs as parent branch is legacy-docs"
    exit 0
  else
    # Return 1 to continue the build
    exit 1
  fi
fi

# For all other projects, continue the build
exit 1