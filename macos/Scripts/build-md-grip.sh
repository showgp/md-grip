#!/bin/bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/go/bin:$PATH"

# Build the bundled md-grip tool into the app's Contents/MacOS and ad-hoc sign
# it before Xcode signs the bundle. The host loads it only from this location;
# there is no Resources, PATH or source-tree fallback at runtime.
#
# Xcode exports the target architectures as ARCHS: a single arm64 or x86_64
# value builds only that slice, any other value (including the development
# build's default arm64 x86_64) keeps the universal lipo merge.
cd "${SRCROOT}/.."

TOOL="${BUILT_PRODUCTS_DIR}/${CONTENTS_FOLDER_PATH}/MacOS/md-grip"
mkdir -p "$(dirname "${TOOL}")"

build_slice() {  # <arch> <goarch> <output>
  echo "Building md-grip for $1..."
  CGO_ENABLED=0 GOOS=darwin GOARCH="$2" go build -ldflags "-s -w" -o "$3" .
}

case "${ARCHS:-}" in
  arm64)
    build_slice arm64 arm64 /tmp/md-grip-arm64
    cp /tmp/md-grip-arm64 "${TOOL}"
    ;;
  x86_64)
    build_slice x86_64 amd64 /tmp/md-grip-amd64
    cp /tmp/md-grip-amd64 "${TOOL}"
    ;;
  *)
    build_slice arm64 arm64 /tmp/md-grip-arm64
    build_slice x86_64 amd64 /tmp/md-grip-amd64

    echo "Creating universal binary at ${TOOL}..."
    lipo -create /tmp/md-grip-arm64 /tmp/md-grip-amd64 -output "${TOOL}"
    ;;
esac

echo "Ad-hoc signing the bundled tool..."
codesign --force --sign - --identifier com.showgp.MDGrip.md-grip "${TOOL}"

echo "md-grip binary built and signed successfully."
