package Exobrain::Router;
use v5.10.0;
use Moose;
use warnings;
use Method::Signatures;
use Carp qw(croak);
use ZMQ;
use ZMQ::Constants qw(ZMQ_SUB ZMQ_SUBSCRIBE ZMQ_PUB ZMQ_FORWARDER);

has subscriber => (is => 'ro', default => 'tcp://127.0.0.1:3546');     # Subscribers connect here
has publisher  => (is => 'ro', default => 'tcp://127.0.0.1:3547');     # Publishers connect here
has server     => (is => 'ro', isa => 'Bool', default => 0);

# Clients should never call start. 

method start() {

    # Most things SHOULDN'T be trying to start this. So we'll
    # check if we were built with the server flag to prevent
    # accidental starting.

    if (not $self->server) {
        croak "Attempt to start non-server.";
    }

    my $zmq = ZMQ::Context->new;
    my $sub = $zmq->socket(ZMQ_SUB);
    $sub->bind($self->publisher);
    $sub->setsockopt(ZMQ_SUBSCRIBE, '');    # Sub everything

    my $pub = $zmq->socket(ZMQ_PUB);
    $pub->bind($self->subscriber);

    # Breaking encapsulation! Eeew!
    ZMQ::call('zmq_device', ZMQ_FORWARDER, $pub->{_socket}, $sub->{_socket});
}


1;

__END__

=pod

=head1 NAME

Exobrain::Router

=head1 VERSION

version 1.04

=for Pod::Coverage ZMQ_FORWARDER ZMQ_PUB ZMQ_SUB ZMQ_SUBSCRIBE

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
