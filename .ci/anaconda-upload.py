import os
import glob
import subprocess
import traceback

cmd = ['anaconda', 'upload', '--summary' '"Uploaded by Appveyor"' '--force']
cmd.extend(glob.glob('*.tar.bz2'))
try:
    subprocess.check_call(cmd)
except subprocess.CalledProcessError:
    traceback.print_exc()
