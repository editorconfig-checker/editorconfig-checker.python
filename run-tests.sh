#!/bin/bash

set -e

build_docker_image_and_run() {
    local py_docker_image="$1"
    local package="$2"

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

    docker run --rm "$docker_image" ec -version
}

main() {
    echo -e "Running tests...\n\n"

    local py_versions=()
    if [ -n "$TEST_PY_VERSION" ]; then
        py_versions+=("$TEST_PY_VERSION")
    else
        py_versions+=("2.7")
        py_versions+=("3.7")
        py_versions+=("3.8")
        py_versions+=("3.9")
        py_versions+=("3.10")
        py_versions+=("3.11")
        py_versions+=("3.12")
        py_versions+=("3.13")
    fi

    local py_packages=()
    if [ -z "$TEST_LOCAL_PKG" ] || [ "$TEST_LOCAL_PKG" = "true" ]; then
        py_packages+=("local")
    fi
    if [ -z "$TEST_PYPI_PKG" ] || [ "$TEST_PYPI_PKG" = "true" ]; then
        py_packages+=("editorconfig-checker")
    fi

    for py_version in "${py_versions[@]}"; do
        for package in "${py_packages[@]}"; do
            echo "Building docker image with Python version $py_version and $package package. It could take some time..."
            build_docker_image_and_run "$py_version-slim" "$package"
            echo -e "\n"
        done
    done
}

main
