package Exobrain::Measurement::Social;

use 5.010;
use strict;
use warnings;
use autodie;
use Moose::Role;

# ABSTRACT: Base class for all social media events

BEGIN { with 'Exobrain::Message'; }

payload from    => ( isa => 'Str' );
payload to      => ( isa => 'ArrayRef[Str]', default => sub { [] } );
payload from_me => ( isa => 'Bool', default => 0);
payload to_me   => ( isa => 'Bool', default => 0);
payload tags    => ( isa => 'ArrayRef[Str]', default => sub { [] } );
payload text    => ( isa => 'Str' );

1;

__END__

=pod

=head1 NAME

Exobrain::Measurement::Social - Base class for all social media events

=head1 VERSION

version 0.05

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
