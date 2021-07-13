#!/usr/bin/env python3
#
# Script to generate supporter logo table
# 4 in a row
# Input: Logos.yaml
# Output: Logos.html
# 
# (w) Kurt Garloff <garloff@osb-alliance.com>, 7/2021
# (c) OSB Alliance e.V.
# SPDX-License-Identifier: CC-BY-SA-4.0

import yaml
import os, sys

def usage():
    print("Usage: gen-logos.py in.yaml > out.html")
    sys.exit(1)

def main(argv):
    if len(argv) < 2:
        usage()
    ylist = yaml.safe_load(open(argv[1]))
    logos = ylist["Logos"]
    ctr = 0
    for key in logos.keys():
        logo = logos[key]
        if ctr%4 == 0:
            print(' <div class="row d-flex align-items-baseline">')
        print('  <div class="col-md-3 col-sm-6">')
        print('   <a href="%s">' % logo["link"])
        if 'height' in logo:
            print('   <img src="images/%s" alt="%s Logo" title="%s" height=%s />' \
                % (logo["filename"], key, key, logo["height"]))
        else:
            print('   <img src="images/%s" alt="%s Logo" title="%s" width=%s />' \
                % (logo["filename"], key, key, logo["width"]))
        print('  </div>')
        if ctr%4 == 3:
            print(' </div>')
        ctr += 1
    while ctr%4:
        print('  <div class="col-md-3 col-sm-6">')
        print('  </div>')
        if ctr%4 == 3:
            print(' </div>')
        ctr += 1

if __name__ == "__main__":
    main(sys.argv)
