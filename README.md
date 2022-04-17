# editorconfig-checker.python

<p align="center">
    <a href="https://pypi.org/project/editorconfig-checker/"><img src="https://img.shields.io/pypi/v/editorconfig-checker.svg?style=flat&logo=pypi" alt="PyPI Latest Release"></a>
    <a href="https://pepy.tech/project/editorconfig-checker"><img src="https://pepy.tech/badge/editorconfig-checker" alt="Downloads"> </a>
    <a href="http://choosealicense.com/licenses/mit/"><img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="MIT License"></a>
</p>

A Python wrapper to provide a pip-installable [editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker) binary.

Internally, this package provides a convenient way to download the pre-built `editorconfig-checker` binary for your particular platform.

## Installation

- From source code:
  ```
  pip install .
  ```
- From `PyPI`:
  ```
  pip install editorconfig-checker
  ```

## Usage

After installation, the `ec` binary should be available in your environment (or `ec.exe` on Windows):

```
ec -version
```

## Usage with the pre-commit git hooks framework

`editorconfig-checker` can be included as a hook for [pre-commit](https://pre-commit.com/).
The easiest way to get started is to add this configuration to your `.pre-commit-config.yaml`:

```yaml
repos:
-   repo: https://github.com/editorconfig-checker/editorconfig-checker.python
    rev: ''  # pick a git hash / tag to point to
    hooks:
    -   id: editorconfig-checker
        alias: ec
```

The above hook is a python wrapper that automatically downloads and installs
[editorconfig-checker](https://editorconfig-checker.github.io/) binary.
If you manage your tools in some other way, for example, via [ASDF](https://asdf-vm.com/),
you may want to use an alternative pre-commit hook that assumes that
`ec` binary executable is already available on the system path:

```yaml
repos:
-   repo: https://github.com/editorconfig-checker/editorconfig-checker.python
    rev: ''  # pick a git hash / tag to point to
    hooks:
    -   id: editorconfig-checker-system
        alias: ec
```

See the [pre-commit docs](https://pre-commit.com/#pre-commit-configyaml---hooks) to check how to customize this configuration.
