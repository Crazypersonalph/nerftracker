import os
from setuptools import setup
from Cython.Distutils import Extension
import numpy as np


def scandir(direct, files=None):
    if files is None:
        files = []
    for file in os.listdir(direct):
        path = os.path.join(direct, file)
        if os.path.isfile(path) and path.endswith(".pyx"):
            files.append(path.replace(os.path.sep, ".")[:-4])
        elif os.path.isdir(path):
            scandir(path, files) 
    return files


def make_extension(extname):
    ext_path = extname.replace(".", os.path.sep)+".pyx"
    return Extension(
        extname,
        [ext_path],
        include_dirs=[".", np.get_include()],   # adding the '.' to include_dirs is CRUCIAL!!
        extra_compile_args=["/O2"],
        cython_directives={"cdivision": False,
                           "wraparound": False,
                           "boundscheck": False,
                           "language_level": "3str"},
        )


# get the list of extensions
extNames = scandir("utils")

# and build up the set of Extension objects
extensions = [make_extension(name) for name in extNames]
extensions.insert(0,
                  Extension("nerftracker",
                            ["nerftracker.pyx"],
                            include_dirs=[".", np.get_include()],
                            extra_compile_args=["/O2"],
                            cython_directives={"cdivision": False,
                                               "wraparound": False,
                                               "boundscheck": False,
                                               "language_level": "3str"}))

setup(
    name='nerftracker',
    ext_modules=extensions
)
