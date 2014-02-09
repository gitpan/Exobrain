package Exobrain::Intent::Tweet;

use v5.10.0;

use Moose;
use Method::Signatures;
use Exobrain::Types qw( TweetStr );

# This provides a message which twitter sinks will act upon.
# Intent::Tweet->new( tweet => 'Hello World' );

method summary() { return $self->tweet; }

BEGIN { with 'Exobrain::Intent'; }

payload tweet => ( isa => TweetStr );

1;

__END__

=pod

=head1 NAME

Exobrain::Intent::Tweet

=head1 VERSION

version 0.05

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
