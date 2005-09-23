package Geier;
## 
## Copyright (C) 2005  Stefan Siegl <stesie@brokenpipe.de>, Germany
## 
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
## 

use strict;
use warnings;

sub new {
    my $that = shift;
    my $class = ref($that) || $that;

    my $self = { context => context_new() };
    
    bless $self, $class;
    return $self;
}

sub DESTROY {
    my $self = shift;
    context_free($self->{context});
}

sub encrypt($$) {
    my $self = shift;
    my $indata = shift;
    
    return _encrypt($self->{context}, $indata);
}

##############################################################################
###   E x p o r t e r   A r e a                                            ###
##############################################################################
require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

our $VERSION = "0.01";

require XSLoader;
XSLoader::load('Geier', $VERSION);

1;

