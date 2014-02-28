package Exobrain::Agent::Poll;
use Moose::Role;
use Method::Signatures;
use Try::Tiny;
use Exobrain::Types qw(TimeOut PosInt);

# ABTRACT: Role for exobrain sources which poll a source.

with 'Exobrain::Agent';

requires('poll');
excludes('run');

has frequency  => (isa => TimeOut, is => 'rw', default => 90 );
has max_errors => (isa => PosInt,  is => 'rw', default =>  5 );


method start() {
    my $errors = 0;

    while (1) {
        try {
            $self->poll;
            sleep( $self->frequency );
            $errors = 0;
        }
        catch {
            warn $_;
            $errors++;

            # If we see too many continuous errors, bail out!
            if ($errors > $self->max_errors) {
                my $class   = ref($self);
                my $message = "Too many contiguous errors for $class. Bailing out.";
                try { $self->exobrain->notify($message, priority => 1); };

                die $message;
            }
        };
    }
}

1;

__END__

=pod

=head1 NAME

Exobrain::Agent::Poll

=head1 VERSION

version 1.02

=head1 METHODS

=head2 start

Automatically called when a C<Source> class is started, this 
starts the actual agent (wrapping C<poll>), and never returns.

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
