#! /usr/bin/perl -w
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

use Geier::Simple::UStVA;

my $ustva = new Geier::Simple::UStVA("2006");
$ustva->set_datenlieferant("Stefan Siegl, 09852/613497, Feuchtwangen, ".
			   "91555, Deutschland");
$ustva->set_steuernummer("9203069802950");
$ustva->set_steuerpflichtiger( { Name => "Stefan Siegl",
				 Strasse => "Pittelsklinge 8",
				 PLZ => "91555",
				 Ort => "Feuchtwangen",
				 Telefon => "09852/613497" } );
$ustva->set_erstellungsdatum("20060526");
$ustva->set_zeitraum("02");
$ustva->set_kz("09", "74931");
$ustva->set_kz("83", "0.00");

use Geier::Simple;
my $simple = $ustva->simple();

print $simple->text();
