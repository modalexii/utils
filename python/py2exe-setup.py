# run as <this script.py> <script to make in to exe.py>
# use resource hacker or similar to set icon later
# todo: multiple files, directories, etc

from distutils.core import setup
import sys
import py2exe

script = sys.argv[1]

setup(
    options = {'py2exe': {'bundle_files': 1, 'compressed': True}},
    windows = [{'script': script}],
    version = '###',
    description = '###',
    author = '###',
    author_email = '###',
    zipfile = None,
)
