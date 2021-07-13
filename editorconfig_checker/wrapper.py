#!/usr/bin/env python
# -*- coding: utf-8 -*-
from os import listdir, remove, rename
from os.path import abspath, dirname, isfile, join as path_join
from platform import architecture, system
from subprocess import call
from tarfile import open as tar_open

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

    def delete_tarball(tarball_path):
        '''
        Delete the specified tarball.
        '''
        try:
            remove(tarball_path)
        except BaseException:
            pass

    def process_tar(tarballs_path):
        '''
        Extract the directory `bin` contained in the tarball file and remove
        the archive.

        :return: `True` if the tarball has been processed correctly.
                 Otherwise, the function returns `False`.
        :rtype: bool
        '''
        # Look for the correct tarball based on the machine and remove the ones
        # with a different target machine
        targz = '.tar.gz'
        tarballs_files = [f for f in listdir(tarballs_path) if f.endswith(targz)]
        expected_tarball = '{}{}'.format(get_checker_name(), targz)
        tarball_path = None
        for tarball in tarballs_files:
            if tarball == expected_tarball:
                tarball_path = path_join(tarballs_path, tarball)
            else:
                # Tarball does not match the current machine. We can remove it
                delete_tarball(path_join(tarballs_path, tarball))

        if not tarball_path:
            return False

        t = None
        try:
            t = tar_open(tarball_path, 'r')
            t.extractall(path=EXECUTION_PATH)
            t.close()

            # Rename executable based on the version
            old_fn = path_join(EXECUTION_PATH, 'bin', get_checker_name())
            new_fn = path_join(EXECUTION_PATH, 'bin', get_checker_name_with_version())
            rename(old_fn, new_fn)

            delete_tarball(tarball_path)
        except BaseException:
            if t:
                t.close()

            return False

        return True

    # Check if the `editorconfig-checker` executable exists
    edc_path = path_join(EXECUTION_PATH, 'bin', get_checker_name_with_version())
    if not isfile(edc_path):
        # `editorconfig-checker` executable does not exist in the system
        # Try to extract the proper tarball from the directory
        tarballs_path = path_join(EXECUTION_PATH, 'lib')
        if not process_tar(tarballs_path):
            return 1

    return call([edc_path] + args)
