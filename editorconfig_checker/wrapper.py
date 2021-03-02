#!/usr/bin/env python
# -*- coding: utf-8 -*-
from os import remove, rename
from os.path import abspath, dirname, isfile, join as path_join
from platform import architecture, system
from subprocess import call
from tarfile import open as tar_open

from requests import get

from editorconfig_checker import __version__

EXECUTION_PATH = dirname(abspath(__file__))


def run_editor_config_checker(args):
    def get_checker_name():
        '''
        Return the `editorconfig-checker` executable name based on the:
            1) OS.
            2) Architecture.
            3) Executable extension.

        :return: `editorconfig-checker` executable name
        :rtype: str
        '''
        if isinstance(architecture(), tuple) and len(architecture()):
            arch = architecture()[0]

        return 'ec-{}-{}{}'.format(
            system().lower(),
            'amd64' if arch == '64bit' else '386',
            '.exe' if system() == 'Windows' else ''
        )

    def get_checker_name_with_version():
        '''
        Return the `editorconfig-checker` executable name together with its version.

        :return: `editorconfig-checker` executable name with its version
        :rtype: str
        '''
        return '{}-{}'.format(get_checker_name(), __version__)

    def download_tar():
        '''
        Download the tar which contains the `editorconfig-checker` executable
        from Github.

        :return: Absolute path of the tar file if everything goes fine.
                 Otherwise, the function returns `None`.
        :rtype: Optional[str]
        '''
        try:
            tar_name = '{}.tar.gz'.format(get_checker_name())
            tar_url = (
                'https://github.com/editorconfig-checker/editorconfig-checker'
                '/releases/download/{}/{}'.format(__version__, tar_name)
            )
            tar_path = path_join(EXECUTION_PATH, tar_name)

            response = get(tar_url, stream=True)
            if response.status_code == 200:
                with open(tar_path, 'wb') as fp:
                    fp.write(response.raw.read())

                return tar_path

            return None
        except BaseException:
            return None

    def process_tar(tar_path):
        '''
        Extract the directory `bin` contained in the tar file and remove
        the archive.

        :return: `True` if the tar has been processed correctly.
                 Otherwise, the function returns `False`.
        :rtype: bool
        '''
        if not isfile(tar_path):
            return 1

        ok = True
        tar = None
        try:
            tar = tar_open(tar_path, 'r')
            tar.extractall(path=EXECUTION_PATH)
            tar.close()

            # Rename executable based on the version
            old_fn = path_join(EXECUTION_PATH, 'bin', get_checker_name())
            new_fn = path_join(EXECUTION_PATH, 'bin', get_checker_name_with_version())
            rename(old_fn, new_fn)
        except BaseException:
            if tar:
                tar.close()
            ok = False

        # No error if 'remove' raises an exception. The aim of the function
        # is to extract the executable from the archive.
        try:
            remove(tar_path)
        except BaseException:
            pass

        return ok

    # Check if the `editorconfig-checker` exists
    edc_path = path_join(EXECUTION_PATH, 'bin', get_checker_name_with_version())
    if not isfile(edc_path):
        # `editorconfig-checker` does not exist in the system. Try to download it
        tar_path = download_tar()
        if not tar_path:
            return 1

        if not process_tar(tar_path):
            return 2

    return call([edc_path] + args)
