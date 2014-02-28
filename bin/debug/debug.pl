#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use Getopt::Std;
use Exobrain::Bus;

# PODNAME: debug.pl
# ABSTRACT: View events on the exobrain bus

my $bus = Exobrain::Bus->new(
    type => 'SUB',
);

say @ARGV;

my %opts = ( v => 0 );

getopts('v', \%opts);

if ($opts{v}) { say "Verbose mode enabled"; }

while (1) {
    if ($opts{v}) {
        say $bus->get->dump;      # Verbose
        say "-" x 50;
    }
    else {
        say $bus->get->summary;
    }
}

__END__

=pod

=head1 NAME

debug.pl - View events on the exobrain bus

=head1 VERSION

version 1.03

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
