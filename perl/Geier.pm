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


sub send_encrypted($$) {
    my $self = shift;
    my $indata = shift;
    
    return _send_encrypted($self->{context}, $indata);
}


sub send($$) {
    my $self = shift;
    my $indata = shift;
    
    return _send($self->{context}, $indata);
}

sub validate($$) {
    my $self = shift;
    my $indata = shift;
    
    return _validate($self->{context}, $indata);
}

sub xsltify($$) {
    my $self = shift;
    my $indata = shift;

    return _xsltify($self->{context}, $indata);
}

sub get_clearing_error($$) {
    my $self = shift;
    my $indata = shift;

    return _get_clearing_error($self->{context}, $indata);
}

sub decrypt($$) {
    my $self = shift;
    my $indata = shift;

    return _decrypt($self->{context}, $indata);
}

sub sign_softpse($$$$) {
    my $self = shift;
    my $indata = shift;
    my $filename = shift;
    my $pincode = shift;
   
    return _sign_softpse($self->{context}, $indata, $filename, $pincode);
}

sub sign_opensc($$$$) {
    my $self = shift;
    my $indata = shift;
    my $cert_id = shift;
   
    return _sign_opensc($self->{context}, $indata, $cert_id);
}




##############################################################################
###   E x p o r t e r   A r e a                                            ###
##############################################################################
require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	encrypt			_encrypt
	send_encrypted		_send_encrypted
	send			_send
	validate		_validate
	xsltify			_xsltify
	get_clearing_error	_get_clearing_error
	decrypt			_decrypt
	sign			_sign

	init
	exit
	context_new
	context_free
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

our $VERSION = "0.01";

require XSLoader;
XSLoader::load('Geier', $VERSION);

1;

