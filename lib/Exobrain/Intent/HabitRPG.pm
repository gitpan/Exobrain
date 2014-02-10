package Exobrain::Intent::HabitRPG;

use v5.10.0;
use Moose;
use Method::Signatures;


method summary() {
    return join(' ' , "HabitRPG: Move" , $self->task, $self->direction);
}

BEGIN { with 'Exobrain::Intent'; };

payload task      => ( isa => 'Str' , required => 1 );
payload direction => ( isa => 'Str' , required => 1 );  # TODO - Restrict to up/down
payload public    => ( isa => 'Bool', default => 0 );

1;

__END__

=pod

=head1 NAME

Exobrain::Intent::HabitRPG

=head1 VERSION

version 0.06

=head1 SYNPOSIS

    $exobrain->intent('HabitRPG',
        task      => $id,
        direction => 'up',
        public    => 1,
    );

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
