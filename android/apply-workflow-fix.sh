#!/usr/bin/env bash
# Apply the Android CI workflow fix from this branch.
#
# The autonomous agent's GITHUB_TOKEN does not have the `workflows` permission,
# so GitHub rejects pushes/API writes to .github/workflows/.  Run this script
# from a checkout with permission to update workflows, then commit the result.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
git -C "$root" apply --index "$root/android/workflow-android-apk.patch"
echo "Applied android/workflow-android-apk.patch to .github/workflows/android-apk.yml"
