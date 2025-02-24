#!/bin/bash

echo "VERCEL_GIT_COMMIT_REF: $VERCEL_GIT_COMMIT_REF"
echo "VERCEL_GIT_COMMIT_SHA: $VERCEL_GIT_COMMIT_SHA"

if [[ -z "$VERCEL_GIT_COMMIT_SHA" && "$VERCEL_GIT_COMMIT_REF" == "main" ]] ; then
  echo "✅ - Build triggered by Deploy Hook"
  exit 1;
else
  echo "🛑 - Build not triggered by Deploy Hook"
  exit 0;
fi
