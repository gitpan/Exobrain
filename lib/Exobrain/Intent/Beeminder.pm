package Exobrain::Intent::Beeminder;

use v5.10.0;

use Moose;
use Method::Signatures;

# This provides a message which Beeminder sinks will act upon.
# Intent::Beeminder->new( goal => 'inbox', value => 52 );

method summary() {
    my $summary = join(' ', 'Beeminder: Set', $self->goal, 'to', $self->value);
    
    if (my $comment = $self->comment)  {
        $summary .= " ($comment)";
    }

    return $summary;
}

BEGIN { with 'Exobrain::Intent' }

payload goal    => (isa => 'Str');
payload value   => (isa => 'Num');
payload comment => (isa => 'Str', required => 0);

1;

__END__

=pod

=head1 NAME

Exobrain::Intent::Beeminder

=head1 VERSION

version 0.05

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
