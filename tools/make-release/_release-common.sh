#!/usr/bin/env bash
# Shared helpers for make-release-*.sh (Linux + macOS).
# Source this file; it is not meant to run standalone.

# Echo the repo root (two levels up from this file: tools/make-release/ -> repo).
rd_repo_root() {
  ( cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd )
}

# Echo the version string from src/C64D_Version.h. Arg: repo root.
rd_version() {
  local root="$1"
  sed -n 's/.*RETRODEBUGGER_VERSION_STRING[[:space:]]*"\([^"]*\)".*/\1/p' \
    "$root/src/C64D_Version.h"
}

# Create a temp staging dir containing RetroDebugger-v<version>/; echo the staging dir.
# Arg: version.
rd_make_stage() {
  local version="$1" stage
  stage="$(mktemp -d)"
  mkdir -p "$stage/RetroDebugger-v$version"
  echo "$stage"
}

# Copy README, docs/, and tools/ into the release dir.
# Args: repo root, release dir.
rd_copy_common() {
  local root="$1" release_dir="$2"
  cp "$root/README.md" "$release_dir/"
  mkdir -p "$release_dir/docs"
  cp "$root/docs/README-C64-65XE-NES-Debugger.txt" "$release_dir/docs/"
  cp "$root/docs/release-notes.txt" "$release_dir/docs/"
  mkdir -p "$release_dir/tools"
  cp -R "$root/tools/c64d-champ" "$release_dir/tools/"
  cp -R "$root/tools/websockets-debugger-test" "$release_dir/tools/"
  # Never ship node_modules in releases.
  find "$release_dir/tools" -type d -name node_modules -prune -exec rm -rf {} +
}

# Zip the release dir (top-level folder preserved) and move the zip to releases/.
# Echo the final zip path. Args: repo root, staging dir, release name, zip name.
rd_package_and_collect() {
  local root="$1" stage="$2" release_name="$3" zip_name="$4"
  ( cd "$stage" && zip -r "$zip_name" "$release_name" >/dev/null ) || return 1
  mkdir -p "$root/releases"
  mv "$stage/$zip_name" "$root/releases/"
  echo "$root/releases/$zip_name"
}
