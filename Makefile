.PHONY: help
help:
	@echo "Available targets:"
	@echo "    - help         : Print this help message."
	@echo "    - clean        : Remove generated files."
	@echo "    - coding_style : Run coding style tools."

.PHONY: all
all: help

.PHONY: clean
clean:
	@rm -rf build dist editorconfig_checker.egg-info editorconfig_checker/bin

.PHONY: coding_style
coding_style:
	@pycodestyle --ignore E501 .
	@flake8 --ignore E501 .
