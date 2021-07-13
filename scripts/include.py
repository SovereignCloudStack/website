#!/usr/bin/env python3
#
# Parse HTML file and include other file on specific keyword 
# <!--include: FILENAME-->
#
# (w) Kurt Garloff <garloff@osb-alliance.com>
# (c) OSB Alliance, 7/2021
# SPDX-Liencense-Identifier: CC-BY-SA-4.0

import os, sys, re

def main(argv):
    rx = re.compile(r'<!--include: (.*)-->')
    for ln in open(argv[1]):
        m = rx.search(ln)
        if m:
            fn = m.group(1)
            print(rx.sub(r'<!--included: \1-->', ln))
            for nln in open(fn):
                print(nln, end='')
        else:
            print(ln, end='')

if __name__ == "__main__":
    main(sys.argv)

