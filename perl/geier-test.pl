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

#print "unencrypted data: \n$indata\n\n\n";

=cut this is how to encrypt data ...
my $encrypted = $instance->encrypt($indata);
if($encrypted) { print "got it: \n$encrypted\n\n"; }
else { die "encrypt failed.\n"; }
=cut

=cut this is how to send data ...
my $sent = $instance->send_encrypted($encrypted);
if($sent) { print "sent it: \n$sent\n\n"; }
else { die "send_encrypted failed.\n"; }

my $decrypted = $instance->send($indata);
if($decrypted) { print "all-in-one result: \n$decrypted\n\n"; }
else { die "all-in-one function failed.\n"; }
=cut

print "validation result: ", $instance->validate($indata), "\n";
