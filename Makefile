.PHONY: help
help:
	@echo "Available targets:"
	@echo "    help                : Print this help message."
	@echo "    check_coding_style  : Run pycodestyle."

.PHONY: all
all: help

.PHONY: check_coding_style
check_coding_style:
	@echo "Running pycodestyle..."
	@pycodestyle --show-source src
