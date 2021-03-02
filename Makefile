.PHONY: help
help:
	@echo "Available targets:"
	@echo "    - help         : Print this help message."
	@echo "    - coding_style : Run coding style tools."

.PHONY: all
all: help

.PHONY: coding_style
coding_style:
	@pycodestyle --ignore E501 .
	@flake8 --ignore E501 .
