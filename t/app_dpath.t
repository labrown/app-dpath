#! /usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 4;
use Test::Deep;
use JSON;

BEGIN {
	use_ok( 'App::DPath' );
}

sub check {
        my ($intype, $outtype, $path) = @_;

        my $just_diag = $path ? 1 : 0;

        $path       ||= '//lines//description[ value =~ m(use Data::DPath) ]/../_children//data//name[ value eq "Hash two"]/../value';
        my $program   = "$^X -Ilib bin/dpath";
        my $unblessed = $outtype eq "json" ? "_unblessed" : "";
        my $infile    = "t/some_tap$unblessed.$intype";
        my $cmd       = "$program -i $intype -o $outtype '$path' $infile";
        #diag $cmd;
        my $output    = `$cmd`;

        my $result;
        if ($outtype eq "json")
        {
                $result  = JSON::from_json($output);
        }
        elsif ($outtype eq "dumper")
        {
                eval "\$result = my $output";
        }
        if ($just_diag) {
                diag Dumper($result);
        } else {
                cmp_deeply $result, [ "2" ], "$intype - dpath - $outtype";
        }
}

check (qw(yaml json));
check (qw(yaml dumper));
check (qw(json dumper));
#check (qw(dumper dumper), "/");

