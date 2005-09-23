#! /usr/bin/env perl
use ExtUtils::testlib;
use Geier;

print "geier_init result: ", Geier::init(0), "\n";
print "geier_exit result: ", Geier::exit, "\n";

my $context = Geier::context_new();
print "context: $context\n";

Geier::context_free($context);

