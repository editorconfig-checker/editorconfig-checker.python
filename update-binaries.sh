#!/bin/bash

set -e

# Global variables
CORE_VERSION="2.3.5"

TARBALLS=()
TARBALLS+=("ec-darwin-386.tar.gz")
TARBALLS+=("ec-darwin-amd64.tar.gz")
TARBALLS+=("ec-dragonfly-amd64.tar.gz")
TARBALLS+=("ec-freebsd-386.tar.gz")
TARBALLS+=("ec-freebsd-amd64.tar.gz")
TARBALLS+=("ec-freebsd-arm.tar.gz")
TARBALLS+=("ec-linux-386.tar.gz")
TARBALLS+=("ec-linux-amd64.tar.gz")
TARBALLS+=("ec-linux-arm.tar.gz")
TARBALLS+=("ec-linux-arm64.tar.gz")
TARBALLS+=("ec-linux-mips.tar.gz")
TARBALLS+=("ec-linux-mips64.tar.gz")
TARBALLS+=("ec-linux-mips64le.tar.gz")
TARBALLS+=("ec-linux-mipsle.tar.gz")
TARBALLS+=("ec-linux-ppc64.tar.gz")
TARBALLS+=("ec-linux-ppc64le.tar.gz")
TARBALLS+=("ec-netbsd-386.tar.gz")
TARBALLS+=("ec-netbsd-amd64.tar.gz")
TARBALLS+=("ec-netbsd-arm.tar.gz")
TARBALLS+=("ec-openbsd-386.tar.gz")
TARBALLS+=("ec-openbsd-amd64.tar.gz")
TARBALLS+=("ec-openbsd-arm.tar.gz")
TARBALLS+=("ec-plan9-386.tar.gz")
TARBALLS+=("ec-plan9-amd64.tar.gz")
TARBALLS+=("ec-solaris-amd64.tar.gz")
TARBALLS+=("ec-windows-386.exe.tar.gz")
TARBALLS+=("ec-windows-amd64.exe.tar.gz")


_CHECKER_REPO_URL="https://github.com/editorconfig-checker/editorconfig-checker"

TMP_OUTPUT_DIRECTORY="tmp"
OUTPUT_DIRECTORY="editorconfig_checker/lib"


echo -e "Core version: $CORE_VERSION\n"

# Check if this tag exists
tag_url="$EDITORCONFIG_CHECKER_REPO_URL/releases/tag/$CORE_VERSION"
status_code="$(curl --write-out '%{http_code}' --silent --output /dev/null "$tag_url")"
if [[ "$status_code" != "200" ]]; then
    echo "Error: expecting 200 from \"$tag_url\" but got $status_code"
    exit 1
fi

# Create temporary directory for containing the tarballs
rm -rf "$TMP_OUTPUT_DIRECTORY"
mkdir "$TMP_OUTPUT_DIRECTORY"

# Download tarballs
num_tarballs="${#TARBALLS[@]}"
artifacts_url="$EDITORCONFIG_CHECKER_REPO_URL/releases/download/$CORE_VERSION"
for idx in "${!TARBALLS[@]}"; do
    tarball="${TARBALLS[idx]}"

    echo "[$((idx + 1))/$num_tarballs] Downloading $tarball..."

    tarball_url="$artifacts_url/$tarball"
    tarball_location="$TMP_OUTPUT_DIRECTORY/$tarball"
    status_code="$(curl -L --write-out '%{http_code}' --silent --output "$tarball_location" "$tarball_url")"
    if [[ "$status_code" != "200" ]]; then
        echo "Error: cannot download tarball from \"$tarball_url\" (status_code=$status_code)"
        exit 1
    fi
done

# Move the new tarballs to the proper location
echo -e "\nMoving tarballs from \"TMP_OUTPUT_DIRECTORY\" to \"OUTPUT_DIRECTORY\"..."
rm -rf "$OUTPUT_DIRECTORY"
mv "$TMP_OUTPUT_DIRECTORY" "$OUTPUT_DIRECTORY"
