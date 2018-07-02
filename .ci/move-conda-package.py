import sys
import os
import re
import yaml
import glob
import shutil
from conda_build.config import Config

conddir = getattr(Config(), "bldpkgs_dir")

for dir in [i for i in os.listdir() if not re.search(r'\.',i)]:
  with open(os.path.join(dir, 'meta.yaml')) as f:
      name = yaml.load(f)['package']['name']

  binary_package_glob = os.path.join(conddir, '{0}*.tar.bz2'.format(name))
  binary_package = glob.glob(binary_package_glob)[0]

  shutil.move(binary_package, '.')
