#!/usr/bin/python3
# -*- coding: utf-8 -*-
from io import open as io_open
from os import path as os_path
from re import search as re_search

from setuptools import setup

with io_open('README.md', 'rt', encoding='utf8') as fp:
    readme = fp.read()

with io_open(os_path.join('editorconfig_checker', '__init__.py'), 'rt', encoding='utf8') as fp:
    version = re_search(r'__version__ = \'(.*?)\'', fp.read()).group(1)

setup(
    name='editorconfig-checker',
    version=version,
    url='https://editorconfig-checker.github.io',
    project_urls={
        'Documentation': 'https://editorconfig-checker.github.io',
        'Code': 'https://github.com/editorconfig-checker/editorconfig-checker.python',
        'Issue tracker': 'https://github.com/editorconfig-checker/editorconfig-checker/issues',
    },
    license='MIT',
    author='Marco M.',
    author_email='mmicu.github00@gmail.com',
    maintainer='Marco M., Max Strübing',
    maintainer_email='mmicu.github00@gmail.com, mxstrbng@gmail.com',
    description='A tool to verify that your files are in harmony with your .editorconfig',
    long_description=readme,
    long_description_content_type='text/markdown',
    classifiers=[
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Topic :: Text Processing',
        'Topic :: Utilities'
    ],
    packages=['editorconfig_checker'],
    include_package_data=True,
    python_requires='>=2.7',
    install_requires=[
        'requests>=2.22'
    ],
    extras_require={
        'dev': [
            'flake8',
            'pycodestyle'
        ]
    },
    entry_points={
        'console_scripts': [
            'editorconfig-checker = editorconfig_checker.__main__:main'
        ]
    }
)
