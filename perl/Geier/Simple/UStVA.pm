package Geier::Simple::UStVA;
## 
## Copyright (C) 2006  Stefan Siegl <stesie@brokenpipe.de>, Germany
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

use Geier::Simple;
use XML::Simple;
use Data::Dumper;

=pod

=head1 NAME

Geier::Simple::UStVA - Easy API to Elster/Coala interface

=head1 SYNOPSIS

  use Geier::Simple::UStVA;
  my $ustva = new Geier::Simple::UStVA("2006");
  $ustva->set_steuernummer("9203069802950");

  my $xmltree = $ustva->text();

  use Geier;
  my $coala = new Geier();
  print $coala->send($data);

=head1 DESCRIPTION

This Perl Module supplies an easy API to create Elster/Coala XML-trees
for value added tax declarations, which can be send to the German
inland revenue office afterwards. 

GEIER is the first free library to send gathered tax declarations data to
the German inland revenue office.

GEIER as well as this module is part of the Taxbird project.

=head1 USAGE

This module should be used in a class-based approach, but class-less
should be possible as well.  

=head1 FUNCTIONS

=head2 sub new(year) - Create a new value added tax declaration

This function creates a new instance of the Geier::Simple::UStVA
class.  You need to pass one argument to it, the year for which to
create the tax declaration.  Internally a B<Geier::Simple> instance is
allocated, which can be accessed using B<simple()>.

 EXAMPLE:
  use Geier::Simple::UStVA;
  my $ustva = new Geier::Simple::UStVA("2006");

=cut

sub new($$) {
    my $that = shift;
    my $class = ref($that) || $that;

    my $year = shift;
    
    my $xs = new XML::Simple(KeepRoot => 1, ForceArray => 1);
    my $subtree = $xs->XMLin(
	"    <Nutzdatenblock>" .
	"      <NutzdatenHeader version=\"9\">" .
	#"        <NutzdatenTicket>6836493</NutzdatenTicket>" .
	#"        <Empfaenger id=\"F\">9203</Empfaenger>" .
	"        <Hersteller>" .
	"          <ProduktName>libgeier-perl</ProduktName>" .
	"          <ProduktVersion>0.1</ProduktVersion>" .
	"        </Hersteller>" .
        #"        <DatenLieferant>Stefan Siegl</DatenLieferant>" .
	"      </NutzdatenHeader>" .
	"      <Nutzdaten>" .
	"        <Anmeldungssteuern art=\"UStVA\" version=\"${year}01\">" .
	"          <DatenLieferant>" .
	#"            <Name>Stefan Siegl</Name>" .
	#"            <Strasse>Pittelsklinge 8</Strasse>" .
	#"            <PLZ>91555</PLZ>" .
	#"            <Ort>Feuchtwangen</Ort>" .
	#"            <Telefon>09852/613497</Telefon>" .
	"          </DatenLieferant>" .
	#"          <Erstellungsdatum>20060527</Erstellungsdatum>" .
	"          <Steuerfall>" .
	"            <Umsatzsteuervoranmeldung>" .
	"              <Jahr>$year</Jahr>" .
	#"              <Zeitraum>02</Zeitraum>" .
	#"              <Steuernummer>9203069802950</Steuernummer>" .
	#"              <Kz09>74931</Kz09>" .
	#"              <Kz83>0.00</Kz83>" .
	"            </Umsatzsteuervoranmeldung>" .
	"          </Steuerfall>" .
	"        </Anmeldungssteuern>" .
	"      </Nutzdaten>" .
	"    </Nutzdatenblock>"
    );
    
    my $self = { 
	#coala => new Geier(),
	#flavour => $flavour,
	gs => new Geier::Simple("ElsterAnmeldung", "UStVA", \$subtree),
	tree => $subtree,
    };

    #- mark as testcase by default
    $self->{gs}->set_testmarker("700000004");
    $self->{gs}->set_vendorid("74931");

    bless $self, $class;
    return $self;
}

sub DESTROY {
    my $self = shift;
    # context_free($self->{context});
}

sub nutzdatenheader($) {
    my $self = shift;
    return $self->{tree}->{Nutzdatenblock}->[0]->{NutzdatenHeader}->[0];
}

sub nutzdaten($) {
    my $self = shift;
    return $self->{tree}->{Nutzdatenblock}->[0]->{Nutzdaten}->[0]
	->{Anmeldungssteuern}->[0];
}

sub steuerfall($) {
    my $self = shift;
    return $self->nutzdaten()->{Steuerfall}->[0]
	->{Umsatzsteuervoranmeldung}->[0];
}

=pod

=head2 sub set_datenlieferant(address) - set DatenLieferant contents

This function sets the B<DatenLieferant> specified in the
tax declaration itself as well as the TransferHeader. 

 EXAMPLE:
        $xs->set_datenlieferant("Steuer Sklave");

=cut

sub set_datenlieferant($$) {
    my $self = shift;
    my $name = shift;
    $self->nutzdatenheader()->{DatenLieferant} = [ $name ];
    $self->{gs}->set_datenlieferant($name);
}

=pod

=head2 sub set_steuernummer(tax_id) - set taxpayer identification number

This function sets the B<Steuernummer> specified in the
tax declaration.

 EXAMPLE:
        $xs->set_steuernummer("9203012367890");

=cut

sub set_steuernummer($$) {
    my $self = shift;
    my $stnr = shift;

    #- set empfaenger field in nutzdatenheader
    $self->nutzdatenheader()->{Empfaenger} = {
	"id" => "F",
	"content" => substr($stnr, 0, 4) ,
    };

    $self->steuerfall()->{Steuernummer} = [ $stnr ];
}

=pod

=head2 sub set_steuerpflichtiger(address) - set taxpayer name/address

This function sets the name, address, etc. of the taxpayer.

 EXAMPLE:
        $ustva->set_steuerpflichtiger( { 
                Name => "Steuer Sklave",
                Strasse => "Finstere Gasse",
		PLZ => "12345",
		Ort => "Sklavengrube",
		Telefon => "01234/56789" 
        } );

=cut

sub set_steuerpflichtiger($$) {
    my $self = shift;
    my $data = shift;

    for (qw/Name Strasse PLZ Ort Telefon/) {
	if(defined($data->{$_})) {
	    $self->nutzdaten()->{DatenLieferant}->[0]->{$_} = [ $data->{$_} ];
	}
    }
}

=pod

=head2 sub set_erstellungsdatum(date) - set date of data gathering

This function sets the date when the committed data has been
gathered.

 EXAMPLE:
        $ustva->set_erstellungsdatum("20060526");

=cut

sub set_erstellungsdatum($$) {
    my $self = shift;
    my $datum = shift;

    $self->nutzdaten()->{Erstellungsdatum}->[0] = { content => $datum };
}

=pod

=head2 sub set_zeitraum(period) - set the tax declaration period

This function sets the period specification of this value added tax
declaration.  For months January to December supply "01" to "12".  For
the first quarter specify "41", etc.

 EXAMPLE:
        $ustva->set_zeitraum("42");

=cut

sub set_zeitraum($$) {
    my $self = shift;
    my $zeitraum = shift;

    $self->steuerfall()->{Zeitraum} = [ $zeitraum ];
}

=pod

=head2 sub set_kz(index,value) - set index values

This function sets the B<Kz>-index value, specified by B<Kz> to the
specified value.

 EXAMPLE:
        $ustva->set_kz("09", "74931");
        $ustva->set_kz("83", "0.00");

=cut

sub set_kz($$$) {
    my $self = shift;
    my $kz = shift;
    my $value = shift;

    $self->steuerfall()->{"Kz${kz}"} = [ $value ];
}

=pod

=head2 sub xmltree() - return the XML::Simple XML-tree

This function returns a reference to the internal XML::Simple tree.
Please mind the you cannot export the XML-tree using B<XMLout> using
this reference as the tree wouldn't be written in the order as
required by Germany's fiscal authorities.  Use B<text()> function in
this case.

 EXAMPLE:
        my $xml_simple_ref = $ustva->xmltree();

=cut


sub xmltree($) {
    my $self = shift;

    #- set new ticket number for every export ...
    $self->nutzdatenheader()->{NutzdatenTicket} = [ int(rand(99999999)) ];

    return $self->{gs}->xmltree();
}

=pod

=head2 sub text() - return the XML-tree as a string

This function writes the XML-tree out and returns it as a string.  Use
this function in order to export the gathered data and validate, send,
etc. it using the B<Geier> module.

 EXAMPLE:
        my $xml = $ustva->text();

=cut

sub text($) {
    my $self = shift;

    #- set new ticket number for every export ...
    $self->nutzdatenheader()->{NutzdatenTicket} = [ int(rand(99999999)) ];

    return $self->{gs}->text();
}

=pod

=head2 sub simple() - return a reference to the Geier::Simple instance

This function returns a reference to the B<Geier::Simple> base class. 

 EXAMPLE:
        use Geier::Simple
        my $gs = $ustva->simple();

        $gs->set_vendorid("74931");
        print $gs->text();

=cut

sub simple($) {
    my $self = shift;

    #- set new ticket number for every export ...
    $self->nutzdatenheader()->{NutzdatenTicket} = [ int(rand(99999999)) ];

    return $self->{gs};
}

##############################################################################
###   E x p o r t e r   A r e a                                            ###
##############################################################################
require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
        set_datenlieferant
        set_steuernummer
        set_steuerpflichtiger
        set_erstellungsdatum
        set_zeitraum
        set_kz
        xmltree
        text
        simple
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

our $VERSION = "0.01";



=pod

=head1 AUTHOR

Stefan Siegl <stesie@brokenpipe.de>

=head1 COPYRIGHT

The Geier module is subject of the GNU General Public License version 2
or any later on your option.

Copyright (C) 2006 by Stefan Siegl <stesie@brokenpipe.de>.


B<libgeier> is subject of the GNU General Publice License version 2 or
any later (on your option) as well. Copyright by the corresponding authors.

=head1 BUGS

If you happen to find a bug, in either this module or the libgeier in
general, please either mail me directly to B<stesie@brokenpipe.de> or to
the Taxbird mailing list, see the webpages at http://www.taxbird.de/ for
details.

=cut
