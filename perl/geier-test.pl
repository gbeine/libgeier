#! /usr/bin/env perl
use ExtUtils::testlib;
use Geier;

###  INITIALIZE  ##############################################################
print "geier_init result: ", Geier::init(0), "\n\n";


###  TRY DIRECT (CLASSLESS) APPROACH  #########################################
my $context = Geier::context_new();
print "context: $context\n";

Geier::context_free($context);
print "released context.\n\n";

###  TRY CLASS APPROACH  ######################################################
my $instance = new Geier();

open HANDLE, "< test_ustva_unencrypted.xml" or die;
my $indata = ""; while(<HANDLE>) { $indata .= $_; }
close HANDLE or die;

print "unencrypted data: \n$indata\n";
my $result = $instance->encrypt($indata);
if($result) { print "got it: $result\n"; }
else { print "encrypt failed.\n"; }



