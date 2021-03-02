#!/bin/bash

set -e

PY_DOCKER_IMAGES=("2.7.16-slim" "3.7.4-slim")

# "."                    -> Local package
# "editorconfig-checker" -> PyPI package
PACKAGES=("." "editorconfig-checker")

DOCKERFILE_TEMPLATE=tests/Dockerfile.template

for py_docker_image in "${PY_DOCKER_IMAGES[@]}"; do
    for package in "${PACKAGES[@]}"; do
        is_local="0"
        if [[ "$package" == "." ]]; then
            package_pp=local
            is_local="1"
        elif [[ "$package" == "editorconfig-checker" ]]; then
            package_pp=pypi
        else
            echo "Unknown package '$package'. Valid values are '.' and 'editorconfig-checker'."
            exit 1
        fi

        echo "docker image: $py_docker_image ~ package: $package ($package_pp)"

        # Generate a valid Dockerfile from a template file
        dockerfile=tests/Dockerfile-$py_docker_image-$package_pp
        cp $DOCKERFILE_TEMPLATE $dockerfile
        sed -i '' "s/\$IMAGE/$py_docker_image/g" $dockerfile
        sed -i '' "s/\$PACKAGE/$package/g"       $dockerfile

        echo "Running docker file in $dockerfile"

        # Build & run
        docker_image=editorconfig-checker-$py_docker_image-$package_pp:latest
        docker build -t $docker_image -f $dockerfile --no-cache --quiet .
        docker run --rm $docker_image

        # Run coding style tools
        if [[ "$is_local" == "1" ]]; then
            docker run --rm $docker_image make coding_style
        fi

        # Remove the created image
        docker image rm $docker_image > /dev/null

        echo ""
    done
done
