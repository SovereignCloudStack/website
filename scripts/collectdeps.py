#!/usr/bin/env python3
# collectdeps.py
#
# Does a naïve parsing of HTML docs to produce a list
# of dependencies recursively.
#
# (c) Kurt Garloff <garloff@osb-alliance.com>, 7/2021
# SPDX-License-Idenitifier: CC-BY-SA-4.0

import os, sys, os.path, re, functools

processed = []
errs = 0

def adddep(thisdep, mypath, nm):
    global newdeps, lang
    if nm.startswith('http') or nm.startswith('tel') or nm.startswith('mailto'):
        return thisdep
    if not nm.startswith('/'):
        nm = os.path.normpath(mypath+nm)
    else:
        nm = 'build' + nm
    if nm.endswith('/'):
        nm += 'index.html' + lang
    if nm in thisdep:
        return thisdep
    thisdep.append(nm)
    if nm in processed:
        return thisdep
    newdeps.append(nm)
    return thisdep

def testsrc(nm):
    global errs
    rnm = re.sub(r'build', 'source', nm)
    if not os.access(rnm, os.R_OK):
        print("ERROR: %s not readable" % rnm, file=sys.stderr)
        errs += 1
        return None
    return rnm
 

def dep(nm, srch, comm):
    global newdeps, errs
    newdeps = []
    thisdep = []
    mypath = os.path.dirname(nm)
    if mypath:
        mypath = mypath + '/'
        mypath = re.sub('css/', '', mypath)
    rnm = testsrc(nm)
    if not rnm:
        return []
    re.sub(r'build', 'source', nm)
    imgsrc = re.compile(r'[sS][rR][cC]="([^"]*)"')
    linkref = re.compile(r'[hH][rR][eE][fF]="([^"]*)"')
    comment = re.compile(r'<!--.*-->')
    for ln in open(rnm):
        if comm:
            ln = comm.sub('', ln)
        for s in srch:
            m = s.findall(ln)
            for m in s.findall(ln):
                thisdep = adddep(thisdep, mypath, m)
    print("%s: %s" % (nm, functools.reduce(lambda a,b: a+" "+b, thisdep, rnm)))
    return newdeps

def htmldep(nm):
    return dep(nm,
            (re.compile(r'[sS][rR][cC]="([^"]*)"'), re.compile(r'[hH][rR][eE][fF]="([^"]*)"'),),
            re.compile(r'<!--.*-->'))

def cssdep(nm):
    return dep(nm,
            (re.compile(r"url\('([^']*)'"),),
            re.compile(r'/\*.*\*/'))

def createdep(nm):
    global lang, processed
    newdeps = []
    html = re.compile(r'.html(.(de|en)){0,1}$')
    css = re.compile(r'.css$')
    img = re.compile(r'.(png|ico|jpg|jpeg)$')
    nm = re.sub(r'^source', 'build', nm)
    processed.append(nm)
    htmlm = html.search(nm)
    if htmlm:
        lang = htmlm.group(1)
        if not lang:
            #lang = ''
            lang = '.en'
        newdeps = htmldep(nm)
    elif css.search(nm):
        newdeps = cssdep(nm)
    elif img.search(nm):
        newdeps = []
    else:
        testsrc(nm)
        newdeps = []
    processed.extend(newdeps)
    for n in newdeps:
        createdep(n)

def main(argv):
    names = argv[1:]
    for nm in names:
        createdep(nm)
    return errs

if __name__== "__main__":
    main(sys.argv)
    sys.exit(errs)

