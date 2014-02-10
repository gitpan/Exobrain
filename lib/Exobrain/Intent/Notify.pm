package Exobrain::Intent::Notify;

use 5.010;
use Moose;
use Method::Signatures;

# Basic notification class

method summary() { return $self->message; }

BEGIN { with 'Exobrain::Intent'; }

payload message  => ( isa => 'Str' );
payload priority => ( isa => 'Int', default => 0 );

# TODO: Add title, URL, etc?

1;

__END__

=pod

=head1 NAME

Exobrain::Intent::Notify

=head1 VERSION

version 0.06

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
