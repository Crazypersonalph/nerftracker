import sys, os
from Cython.Distutils import build_ext
from setuptools import setup, Extension
from Cython.Build import cythonize

def scandir(dir, files=[]):
    for file in os.listdir(dir):
        path = os.path.join(dir, file)
        if os.path.isfile(path) and path.endswith(".pyx"):
            files.append(path.replace(os.path.sep, ".")[:-4])
        elif os.path.isdir(path):
            scandir(path, files) 
    return files


def makeExtension(extName):
    extPath = extName.replace(".", os.path.sep)+".pyx"
    return Extension(
        extName,
        [extPath],
        include_dirs = ["."],   # adding the '.' to include_dirs is CRUCIAL!!
        extra_compile_args = ["-O3", "-Wall"],
        extra_link_args = ['-g']
        )

# get the list of extensions
extNames = scandir("utils")

# and build up the set of Extension objects
extensions = [makeExtension(name) for name in extNames]
extensions.insert(0, Extension("nerftracker", ["nerftracker.pyx"], include_dirs = ["."], extra_compile_args = ["-O3", "-Wall"], extra_link_args = ['-g']))

setup(
    name = 'nerftracker',
    ext_modules = extensions
)