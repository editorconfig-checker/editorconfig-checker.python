#!/usr/bin/env python
# -*- coding: utf-8 -*-
from os import remove
from os.path import abspath, dirname, isfile, join as path_join
from platform import architecture, system
from subprocess import call
from sys import argv, exit
from tarfile import open as tar_open

from requests import get

from . import CORE_VERSION


def get_execution_path():
    '''
    Return the running path.

    :return: running path
    :rtype: str
    '''
    return dirname(abspath(__file__))


def get_checker_name():
    '''
    Return the `editorconfig-checker` executable name based on the:
        1) OS.
        2) Architecture.
        3) Executable extension.

    :return: `editorconfig-checker` executable name
    :rtype: str
    '''
    if isinstance(architecture(), tuple) and len(architecture()) > 0:
        arch = architecture()[0]

    return 'ec-{0}-{1}{2}'.format(
        system().lower(),
        'amd64' if arch == '64bit' else '386',
        '.exe' if system() == 'Windows' else ''
    )


def get_checker_abs_path():
    '''
    Return the absolute path of the `editorconfig-checker` executable.

    :return: `editorconfig-checker` absolute path
    :rtype: str
    '''
    return path_join(
        get_execution_path(),
        'bin',
        get_checker_name()
    )


def main(argc=len(argv), args=argv):
    def checker_exists():
        '''
        Check if the `editorconfig-checker` executable has been download
        in a previous execution.

        :return: `True` if the `editorconfig-checker` executable exists.
                 Otherwise, the function returns `False`.
        :rtype: bool
        '''
        return isfile(get_checker_abs_path())

    def download_tar():
        '''
        Download the tar which contains the `editorconfig-checker` executable
        from Github.

        :return: Absolute path of the tar file if everything goes fine.
                 Otherwise, the function returns `None`.
        :rtype: Optional[str]
        '''
        try:
            tar_name = '{0}.tar.gz'.format(get_checker_name())
            tar_url = (
                'https://github.com/editorconfig-checker/editorconfig-checker'
                '/releases/download/{0}/{1}'.format(CORE_VERSION, tar_name)
            )
            target_path = path_join(get_execution_path(), tar_name)

            response = get(tar_url, stream=True)
            if response.status_code == 200:
                with open(target_path, 'wb') as f:
                    f.write(response.raw.read())

                return target_path

            return None
        except BaseException as be:
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

        correct_execution = True
        tar = None
        try:
            tar = tar_open(tar_path, 'r')
            tar.extractall(path=get_execution_path())
            tar.close()
        except BaseException as be:
            if tar:
                tar.close()
            correct_execution = False

        # No error if 'remove' raises an exception. The aim of the function
        # is to extract the executable from the archive.
        try:
            remove(tar_path)
        except BaseException as be:
            pass

        return correct_execution

    def run_checker(args):
        '''
        Run the actual `editorconfig-checker` executable.

        :return: Return value based on the exit code got from the
                 `editorconfig-checker` executable.
        :rtype: int
        '''
        return call([get_checker_abs_path()] + args)

    if not checker_exists():
        tar_path = download_tar()
        if not tar_path:
            return 1

        if not process_tar(tar_path):
            return 2
    return run_checker(argv[1:])


if __name__ == '__main__':
    exit(main(len(argv), argv))
