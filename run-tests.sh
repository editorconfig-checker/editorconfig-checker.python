#!/bin/bash

set -e

PY_DOCKER_IMAGES=()
if [ -n "$TEST_PY_VERSION" ]; then
	PY_DOCKER_IMAGES+=("$TEST_PY_VERSION")
else
	PY_DOCKER_IMAGES+=("2.7.16-slim")
	PY_DOCKER_IMAGES+=("3.7.4-slim")
	PY_DOCKER_IMAGES+=("3.8-slim")
	PY_DOCKER_IMAGES+=("3.9-slim")
	PY_DOCKER_IMAGES+=("3.10-slim")
	PY_DOCKER_IMAGES+=("3.11-slim")
	PY_DOCKER_IMAGES+=("3.12-slim")
	PY_DOCKER_IMAGES+=("3.13-slim")
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

    for py_docker_image in "${PY_DOCKER_IMAGES[@]}"; do
        for package in "${PY_PACKAGES[@]}"; do
            echo "Building docker image with python version $py_docker_image and $package package. It could take some time..."
            build_docker_image_and_run "$py_docker_image" "$package"

            # docker image rm "$docker_image" &> /dev/null

            echo -e "\n"
        done
    done
}

main
