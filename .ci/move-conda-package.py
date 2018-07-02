import os
import re
import glob
import shutil
from conda_build.config import Config

conddir = getattr(Config(), "bldpkgs_dir")
dirs = [i for i in os.listdir() if not re.search(r'\.',i)]

for dir in dirs:
  binary_package_glob = os.path.join(conddir, '{0}*.tar.bz2'.format(dir))
  binary_package = glob.glob(binary_package_glob)[0]
  shutil.move(binary_package, '.')
