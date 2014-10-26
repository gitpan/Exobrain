package Exobrain::Bus;
use v5.10.0;
use strict;
use warnings;

use ZMQ;
use ZMQ::Constants qw(ZMQ_SUB ZMQ_PUB ZMQ_SUBSCRIBE ZMQ_RCVMORE);

use Moose;
use Method::Signatures;

use Exobrain::Router;
use Exobrain::Message::Raw;

my $context  = ZMQ::Context->new;           # Context is always shared.
my $endpoint = 'tcp://localhost:3568/';     # TODO: From config file?
my $router   = Exobrain::Router->new;

has context   => ( is => 'ro', default => sub { $context } );
has router    => ( is => 'ro', default => sub { $router  } );
has type      => ( is => 'ro', );   # TODO: Type
has subscribe => ( is => 'rw', isa => 'Str', default => '' );
has _socket   => ( is => 'rw' );
has exobrain  => ( is => 'ro', isa => 'Exobrain' );

sub BUILD {
    my ($self) = @_;

    my $type = $self->type;

    if ($type eq 'SUB') {
        my $socket = $context->socket(ZMQ_SUB);
        $socket->connect($self->router->subscriber);
        $socket->setsockopt(ZMQ_SUBSCRIBE, $self->subscribe);
        $self->_socket($socket);
    }
    elsif ($type eq 'PUB') {
        my $socket = $context->socket(ZMQ_PUB);
        $socket->connect($self->router->publisher);
        $self->_socket($socket);
    }
    else {
        die "Internal error: Can't make a $type socket.";
    }

    return;
}

method get() {
    my $message = Exobrain::Message::Raw->new( [
        map { $_->data } $self->_socket->recv_multipart
    ] );

    # If I have an exobrain object, attach that to the message.
    if ($self->exobrain) {
        $message->exobrain($self->exobrain);
    }

    return $message;
}

# TODO: This should be retired. Messages come with their own
# send functionality.
method send($msg) {
    $self->_socket->send($msg);
}

method send_msg(%opts) {
    my $msg = Exobrain::Message::Raw->new( %opts );

    return $msg->send_msg( $self->_socket );
}


1;

__END__

=pod

=head1 NAME

Exobrain::Bus

=head1 VERSION

version 1.07

=for Pod::Coverage BUILD ZMQ_PUB ZMQ_SUB ZMQ_SUBSCRIBE

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
