.PHONY: help
help:
	@echo "Available targets:"
	@echo "  - help         : Print this help message."
	@echo "  - clean        : Remove generated files."
	@echo "  - coding-style : Run coding style tools."
	@echo "  - publish      : Publish package to PyPI."
	@echo "  - quick-test   : Run coding style tools and only the test for the latest python and the current git revision."
	@echo "  - test         : Run coding style tools and tests."

.PHONY: all
all: help

.PHONY: clean
clean:
	@rm -rf build dist editorconfig_checker.egg-info editorconfig_checker/bin

.PHONY: coding-style
coding-style:
	@flake8 --ignore E501 setup.py

.PHONY: publish
publish: clean test
	@python3 setup.py sdist
	@twine upload dist/*

.PHONY: quick-test
quick-test: coding-style
	docker build -t ec-quick-test .
	docker run ec-quick-test ec -version

.PHONY: test
test: coding-style
	@bash run-tests.sh
