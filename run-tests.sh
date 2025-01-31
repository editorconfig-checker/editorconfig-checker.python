#!/bin/bash

set -e

PY_DOCKER_IMAGES=()
if [ -n "$TEST_PY_VERSION" ]; then
	PY_VERSIONS+=("$TEST_PY_VERSION")
else
	PY_VERSIONS+=("2.7.16")
	PY_VERSIONS+=("3.7.4")
	PY_VERSIONS+=("3.8")
	PY_VERSIONS+=("3.9")
	PY_VERSIONS+=("3.10")
	PY_VERSIONS+=("3.11")
	PY_VERSIONS+=("3.12")
	PY_VERSIONS+=("3.13")
fi

PY_PACKAGES=()
if [ -z "$TEST_LOCAL_PKG" ] || [ "$TEST_LOCAL_PKG" = "true" ]; then
	PY_PACKAGES+=("local")
fi
if [ -z "$TEST_PYPI_PKG" ] || [ "$TEST_PYPI_PKG" = "true" ]; then
	PY_PACKAGES+=("editorconfig-checker")
fi


build_docker_image_and_run() {
    local py_docker_image="$1"
    local package="$2"

    # Build
    local docker_image="editorconfig-checker-$py_docker_image-$package:latest"

    docker_package="$package"
    if [[ "$package" == "local" ]]; then
        docker_package="."
    fi

    docker build \
        -t "$docker_image" \
        -f "Dockerfile" \
        --no-cache-filter tester \
        --quiet \
        --build-arg "IMAGE=$py_docker_image" \
        --build-arg "PACKAGE=$docker_package" \
        .

    # Run `editorconfig-checker`
    docker run --rm "$docker_image" ec -version
}

main() {
    echo -e "Running tests...\n\n"

    for py_version in "${PY_VERSIONS[@]}"; do
        for package in "${PY_PACKAGES[@]}"; do
            echo "Building docker image with python version $py_version and $package package. It could take some time..."
            build_docker_image_and_run "$py_version-slim" "$package"

            # docker image rm "$docker_image" &> /dev/null

            echo -e "\n"
        done
    done
}

main
