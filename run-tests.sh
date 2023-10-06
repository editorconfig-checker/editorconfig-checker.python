#!/bin/bash

set -e

DOCKERFILE_TEMPLATE="tests/Dockerfile.template"

PY_DOCKER_IMAGES=()
PY_DOCKER_IMAGES+=("2.7.16-slim")
PY_DOCKER_IMAGES+=("3.7.4-slim")
PY_DOCKER_IMAGES+=("3.8-slim")
PY_DOCKER_IMAGES+=("3.9-slim")
PY_DOCKER_IMAGES+=("3.10-slim")
PY_DOCKER_IMAGES+=("3.11-slim")

create_docker_file() {
    local package="$1"

    # Generate a valid Dockerfile from a template file
    local dockerfile="tests/Dockerfile-$py_docker_image-$package"
    cp "$DOCKERFILE_TEMPLATE" "$dockerfile"

    # Replace docker image
    sed -i "s/\$IMAGE/$py_docker_image/g" "$dockerfile"

    # Replace package name
    if [[ "$package" == "local" ]]; then
        package="."
    fi
    sed -i "s/\$PACKAGE/$package/g" "$dockerfile"

    echo "$dockerfile"
}

build_docker_image_and_run() {
    local py_docker_image="$1"
    local package="$2"
    local dockerfile="$3"

    # Build
    local docker_image="editorconfig-checker-$py_docker_image-$package:latest"
    docker build -t "$docker_image" -f "$dockerfile" --no-cache --quiet .

    # Run `editorconfig-checker`
    docker run --rm "$docker_image" ec -version
}

main() {
    echo -e "Running tests...\n\n"

    for py_docker_image in "${PY_DOCKER_IMAGES[@]}"; do
        for package in local editorconfig-checker; do
            local dockerfile=$(create_docker_file "$package")
            echo "Dockerfile created at \"$dockerfile\" (\"$py_docker_image\" image and \"$package\" package)"

            echo "Building docker image. It could take some time..."
            build_docker_image_and_run "$py_docker_image" "$package" "$dockerfile"

            # docker image rm "$docker_image" &> /dev/null

            echo -e "\n"
        done
    done
}

main
