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

# logos per row
lpr = 4

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
        if ctr%lpr == 0:
            print(' <div class="row d-flex align-items-baseline">')
        print('  <div class="col-md-3 col-sm-6">')
        print('   <a href="%s">' % logo['link'])
        prop = ''
        if 'height' in logo:
            prop += ' height="%s"' % logo['height']
        if 'width' in logo:
            prop += ' width="%s"' % logo['width']
        print('   <img src="/images/%s" alt="%s Logo" title="%s"%s />' \
                % (logo["filename"], key, key, prop))
        print('  </div>')
        ctr += 1
        if ctr%lpr == 0:
            print(' </div>')
    while ctr%lpr:
        print('  <div class="col-md-3 col-sm-6">')
        print('  </div>')
        ctr += 1
        if ctr%lpr == 0:
            print(' </div>')

if __name__ == "__main__":
    main(sys.argv)
