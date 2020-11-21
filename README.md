# editorconfig-checker

![Logo](https://raw.githubusercontent.com/editorconfig-checker/editorconfig-checker.python/master/docs/logo.png "Logo")

<a href="https://www.buymeacoffee.com/mstruebing" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

## What?

This is a tool to check if your files consider your `.editorconfig`.
Most tools - like linters for example - only test one filetype and need an extra configuration.
This tool only needs your editorconfig to check all files.

![Sample Output](https://raw.githubusercontent.com/editorconfig-checker/editorconfig-checker.python/master/docs/sample-output.png "Sample output")

## Important

This is only a wrapper for the core [editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker).
You should have a look at this repository to know how this tool can be used and what possibilities/caveats are there.
This version can be used in the same way as the core as every argument is simply passed down to it.

## Installation

```
$ pip install .                     # from cloned repo
$ pip install editorconfig-checker  # from PyPI
```

## Usage

```
$ editorconfig-checker -help
USAGE:
  -config string
        config
  -debug
        print debugging information
  -disable-end-of-line
        disables the trailing whitespace check
  -disable-indentation
        disables the indentation check
  -disable-insert-final-newline
        disables the final newline check
  -disable-trim-trailing-whitespace
        disables the trailing whitespace check
  -dry-run
        show which files would be checked
  -exclude string
        a regex which files should be excluded from checking - needs to be a valid regular expression
  -h    print the help
  -help
        print the help
  -ignore-defaults
        ignore default excludes
  -init
        creates an initial configuration
  -no-color
        dont print colors
  -v    print debugging information
  -verbose
        print debugging information
  -version
        print the version number
```

## Usage with the pre-commit git hooks framework

editorconfig-checker can be included as a hook for [pre-commit](https://pre-commit.com/). The easiest way to get started is to add this configuration to your `.pre-commit-config.yaml`:

```yaml
repos:
-   repo: https://github.com/editorconfig-checker/editorconfig-checker.python
    rev: ''  # pick a git hash / tag to point to
    hooks:
    -   id: editorconfig-checker
```

See the [pre-commit docs](https://pre-commit.com/#pre-commit-configyaml---hooks) for how to customize this configuration.

## Run tests

The test script uses `docker`. After installing it, you can run the test with:
```
$ ./test.sh
```

## Support

If you have any questions or just want to chat join #editorconfig-checker on
freenode(IRC).
If you don't have an IRC-client set up you can use the
[freenode webchat](https://webchat.freenode.net/?channels=editorconfig-checker).
