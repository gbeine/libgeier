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

sub set_datenlieferant($$) {
    my $self = shift;
    my $name = shift;
    $self->nutzdatenheader()->{DatenLieferant} = [ $name ];
    $self->{gs}->set_datenlieferant($name);
}

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

sub set_steuerpflichtiger($$) {
    my $self = shift;
    my $data = shift;

    for (qw/Name Strasse PLZ Ort Telefon/) {
	if(defined($data->{$_})) {
	    $self->nutzdaten()->{DatenLieferant}->[0]->{$_} = [ $data->{$_} ];
	}
    }
}

sub set_erstellungsdatum($$) {
    my $self = shift;
    my $datum = shift;

    $self->nutzdaten()->{Erstellungsdatum}->[0] = { content => $datum };
}

sub set_zeitraum($$) {
    my $self = shift;
    my $zeitraum = shift;

    $self->steuerfall()->{Zeitraum} = [ $zeitraum ];
}

sub set_kz($$$) {
    my $self = shift;
    my $kz = shift;
    my $value = shift;

    $self->steuerfall()->{"Kz${kz}"} = [ $value ];
}

sub xmltree($) {
    my $self = shift;

    #- set new ticket number for every export ...
    $self->nutzdatenheader()->{NutzdatenTicket} = [ int(rand(99999999)) ];

    return $self->{gs}->xmltree;
}


##############################################################################
###   E x p o r t e r   A r e a                                            ###
##############################################################################
require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
        xmltree

) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

our $VERSION = "0.01";


