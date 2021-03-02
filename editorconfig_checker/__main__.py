#!/usr/bin/env python
# -*- coding: utf-8 -*-
from sys import argv, exit as sys_exit

from editorconfig_checker.wrapper import run_editor_config_checker


def main():
    return run_editor_config_checker(argv[1:])


if __name__ == "__main__":
    sys_exit(main())
