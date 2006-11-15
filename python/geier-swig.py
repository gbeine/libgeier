#!/bin/bash
#
# Copyright (C) 2006 Hartmut Goebel <h.goebel@goebel-consult.de>
#
# Licence: GPL, see www.taxbird.de
#
"""
Sample for using the libgeier Python interface.
"""
import geier
import sys
import libxml2

def print_(*parts):
    for p in parts:
        print str(p),
    print
    sys.stdout.flush()


def _main(gayer, infile, options):
    print_('reading', infile)

    data = open(infile).read()
    if options.as_xml:
        print_('converting to XML')
        data = libxml2.parseMemory(data,len(data))
        print repr(data)
        
    if options.validate:
        print_('validating data')
        res = gayer.validate(data, format=geier.FORMAT_UNENCRYPTED)
        if not res:
            print_('--Abruch, das Daten nicht valide sind', res)
            return
        print_('okay')

    if options.keyfile:
        softpse_filename = options.keyfile
        pin = raw_input('Please enter PIN for %s')
        data = gayer.sign(data, softpse_filename, pin)

    print_('sending data')
    if options.dry_run:
        print_('... skipped sending (--dry-run)')
        res = data
    else:
        res, errMsg = gayer.send(data)
        print_('error Message:', errMsg or '--keine--')
        print_('---- result -----', len(str(res)), 'charakters')
        print res
    if options.html:
        print_('------ html output ---', repr(res))
        print_(gayer.as_html(res) or '-- convert to html failed --')

    

if __name__ == '__main__':
    import optparse
    parser = optparse.OptionParser()
    parser.add_option('--xml', dest='as_xml',
                      action='store_true', default=0,
                      help="convert data to xmlDoc() prior to processing")
    parser.add_option('-v', '--validate', dest='validate',
                      action='store_true', default=False)

    parser.add_option('-d', '--debug', dest='debug',
                      action='store_true', default=0)
    parser.add_option('-l', '--key-file', dest='keyfile',
                      action='store', default=None)
   
    parser.add_option('--html', dest='html',
                      action='store_true', default=False,
                      help="dump data as html")
    parser.add_option('-n', '--dry-run', dest='dry_run',
                      action='store_true', default=False,
                      help="don't send data to the inland revenue office")
#    parser.add_option( '--dump', dest='dump',
#                      action='store_true', default=False,
#                      help="dump data to a certain file, after sending them to the IRO")

    # encrypt-only -> dry_run=1
    # softspe -> password abfragen
    opts, args = parser.parse_args()
    if len(args) == 0:
        parser.print_usage()
        raise SystemExit(1)

    G = geier.Context()
    for infile in args:
        _main(G, infile, opts)
                         
