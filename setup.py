#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""
This setup logic is highly ispired to the one used in `https://github.com/shellcheck-py/shellcheck-py`.

After `https://github.com/editorconfig-checker/editorconfig-checker.python/issues/15` was opened,
we decided to move the wrapper logic directly in the setup phase.

During setup, the tarball that contains the executable will be downloaded based on
the target machine and its content extracted in the proper output directory.

Once the setup is complete, the `ec` executable should be available on your machine.
"""

from io import BytesIO
from distutils.command.build import build as orig_build
from distutils.core import Command
from os import chmod, makedirs, path, stat
from platform import architecture, system
from setuptools import setup
from setuptools.command.install import install as orig_install
from stat import S_IXUSR, S_IXGRP, S_IXOTH
from tarfile import open as tarfile_open

try:
    # Python 3
    from urllib.request import urlopen
except ImportError:
    # Python 2.7
    from urllib2 import urlopen


WRAPPER_VERSION = '2.3.52'
EDITORCONFIG_CHECKER_CORE_VERSION = '2.3.5'
EDITORCONFIG_CHECKER_EXE_NAME = 'ec'


def get_tarball_url():
    def get_ec_name_by_system():
        if isinstance(architecture(), tuple) and len(architecture()) > 0:
            arch = architecture()[0]
        else:
            raise ValueError('Cannot obtain architecture')

        return 'ec-{}-{}{}'.format(
            system().lower(),
            'amd64' if arch == '64bit' else '386',
            '.exe' if system() == 'Windows' else ''
        )

    return 'https://github.com/editorconfig-checker/editorconfig-checker/releases/download/{}/{}'.format(
        EDITORCONFIG_CHECKER_CORE_VERSION,
        '{}.tar.gz'.format(get_ec_name_by_system())
    )


def download_tarball(url):
    sock = urlopen(url)
    code = sock.getcode()

    if code != 200:
        sock.close()
        raise ValueError('HTTP failure. Code: {}'.format(code))

    data = sock.read()
    sock.close()

    return data


def extract_tarball(url, data):
    with BytesIO(data) as bio:
        if '.tar.' in url:
            with tarfile_open(fileobj=bio) as tarf:
                for info in tarf.getmembers():
                    if info.isfile() and info.name.startswith('bin/ec-'):
                        return tarf.extractfile(info).read()

    raise AssertionError('unreachable `extract` function')


def save_executables(data, base_dir):
    exe = EDITORCONFIG_CHECKER_EXE_NAME
    if system() == 'Windows':
        exe += '.exe'

    output_path = path.join(base_dir, exe)
    makedirs(base_dir)

    with open(output_path, 'wb') as fp:
        fp.write(data)

    # Mark as executable ~ https://stackoverflow.com/a/14105527
    mode = stat(output_path).st_mode
    mode |= S_IXUSR | S_IXGRP | S_IXOTH
    chmod(output_path, mode)


class build(orig_build):
    sub_commands = orig_build.sub_commands + [('fetch_binaries', None)]


class install(orig_install):
    sub_commands = orig_install.sub_commands + [('install_editorconfig_checker', None)]


class fetch_binaries(Command):
    build_temp = None

    def initialize_options(self):
        pass

    def finalize_options(self):
        self.set_undefined_options('build', ('build_temp', 'build_temp'))

    def run(self):
        # save binary to self.build_temp
        url = get_tarball_url()
        archive = download_tarball(url)
        data = extract_tarball(url, archive)
        save_executables(data, self.build_temp)


class install_editorconfig_checker(Command):
    description = 'install the editorconfig-checker executable'
    outfiles = ()
    build_dir = install_dir = None

    def initialize_options(self):
        pass

    def finalize_options(self):
        # this initializes attributes based on other commands' attributes
        self.set_undefined_options('build', ('build_temp', 'build_dir'))
        self.set_undefined_options('install', ('install_scripts', 'install_dir'))

    def run(self):
        self.outfiles = self.copy_tree(self.build_dir, self.install_dir)

    def get_outputs(self):
        return self.outfiles


command_overrides = {
    'install': install,
    'install_editorconfig_checker': install_editorconfig_checker,
    'build': build,
    'fetch_binaries': fetch_binaries,
}


try:
    from wheel.bdist_wheel import bdist_wheel as orig_bdist_wheel
except ImportError:
    pass
else:
    class bdist_wheel(orig_bdist_wheel):
        def finalize_options(self):
            orig_bdist_wheel.finalize_options(self)
            # Mark us as not a pure python package
            self.root_is_pure = False

        def get_tag(self):
            _, _, plat = orig_bdist_wheel.get_tag(self)
            # We don't contain any python source, nor any python extensions
            return 'py2.py3', 'none', plat

    command_overrides['bdist_wheel'] = bdist_wheel


setup(version=WRAPPER_VERSION, cmdclass=command_overrides)
