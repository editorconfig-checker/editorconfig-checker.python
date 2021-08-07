# editorconfig-checker.python
A Python wrapper to provide a pip-installable [editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker) binary.

Internally, this package provides a convenient way to download the pre-built `editorconfig-checker` binary for your particular platform.


## Installation
```
$ pip install .                     # from source code
$ pip install editorconfig-checker  # from PyPI
```


## Usage
After installation, the `ec` binary should be available in your environment (or `ec.exe` on Windows):

```
$ ec -version
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
```

See the [pre-commit docs](https://pre-commit.com/#pre-commit-configyaml---hooks) to check how to customize this configuration.
