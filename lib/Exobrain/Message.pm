package Exobrain::Message;

use 5.010;
use strict;
use warnings;
use Method::Signatures;
use Moose::Role;
use Moose::Util::TypeConstraints;
use Carp;
use ZMQ::Constants qw(ZMQ_SNDMORE);
use ZMQ;
use JSON::Any;
use Data::Dumper;

use Exobrain::Types qw(JSON);


has timestamp => ( is => 'ro', isa => 'Int', default => sub { time() } );
has exobrain  => ( is => 'rw', isa => 'Exobrain');
has raw       => ( is => 'ro', isa => 'Ref' );
has source    => ( is => 'ro', isa => 'Str', default => "$0" );

# This can be used to explicitly set the data, ignoring the
# payload attributes.
has _data     => ( is => 'ro', isa => 'Ref' );

# Many classes will provide their own way of getting summary
# data.

requires qw(summary);

# TODO: We should use JSON::XS, because we need specialised features
#       for handling objects.

my $json = JSON::Any->new( convert_blessed => 1 );


func payload($name, @args) {

    # We need to call 'has' from the caller's perspective, so let's
    # find out where we're being called from.

    my ($uplevel) = caller();
    my $uphas = join('::', $uplevel, 'has');

    # Now we'll make the call, as well as adding he payload and ro
    # attributes. We need to turn off strict 'refs' here to assure
    # perl that really it's okay that we're using a string as a
    # subroutine ref.

    no strict 'refs';
    return $uphas->(
        $name => (
            traits   => [qw(Payload)],
            is       => 'ro',
            required => 1,
            @args
        ) 
    );
}


method namespace() {
    my $class = ref($self);

    $class =~ s/^Exobrain:://;

    return $class;
}


use constant PAYLOAD_CLASS => 'Exobrain::Message::Trait::Payload';

method data() {
    my $meta     = $self->meta;
    my @attrs    = $self->meta->get_attribute_list;

    my @payloads = grep 
        { $meta->get_attribute($_)->does( PAYLOAD_CLASS ) } @attrs
    ;

    my $data = {};

    # Walk through all our attributes and populate them into a hash.

    foreach my $attr (@payloads) {
        $data->{ $attr } = $self->$attr;
    }

    return $data;
}


method send_msg($socket?) {

    # If we don't have a socket, grab it from our exobrain object
    # (if it exists)

    if (not $socket) {
        if (my $exobrain = $self->exobrain) {
            $socket = $exobrain->pub->_socket;
        }
        else {
            croak "send_msg() is missing a socket or exobrain";
        }
    }

    my @frames = $self->_frames;

    $socket->send_multipart(\@frames);

    return;
}

# Internal method for creating the required frame structure

method _frames() {
    my @frames;

    push(@frames, join("_", "EXOBRAIN", $self->namespace, $self->source));
    push(@frames, "XXX - JSON - timestamp => " . $self->timestamp);
    push(@frames, $self->summary // "");
    push(@frames, $json->encode( $self->data ));
    push(@frames, $json->encode( $self->raw  || {} ));

    return @frames;
}


method dump() {
    my $dumpstr = "";

    foreach my $method ( qw(namespace timestamp source data raw summary)) {
        my $data = $self->$method // "";
        if (ref $data) { $data = Dumper $data };
        $dumpstr .= "$method : $data\n";
    }

    return $dumpstr;
}


package Exobrain::Message::Trait::Payload;
use Moose::Role;

Moose::Util::meta_attribute_alias('Payload');

# The payload attribute desn't actually do anything directly, but
# we test for it elsewhere to see if something is part of a
# payload that should be transmitted.

1;

__END__

=pod

=head1 NAME

Exobrain::Message

=head1 VERSION

version 0.06

=head1 DESCRIPTION

Top-level I<role> for all exobrain messages.

=head1 METHODS

=head2 payload

    payload size => ( isa => 'Int' );

Convenience method which sets the 'payload' trait on an attribute,
as well as marking it as 'ro' and required by default (these
can be overridden).

=head2 namespace

    my $namespace = $message->namespace;

Provides the namespace of the message type in question. By default
this is the class name with the C<Exobrain> prefix stripped,
but individual message classes are free to define their own namespaces.

=head2 data

    my $data = $message->data;

Messages automatically create a data method (needed for transmitting
over the exobrain bus) by tallying payload attributes.

=head2 send_msg($socket?)

Sends the message across the exobrain bus. If no socket is provided,
the one from the exobrain object (if we were built with one) is used.

=head2 dump()

    my $pkt_debug = $msg->dump;

Provides a string containing a dump of universal packet attributes.
Intended for debugging.

=for Pod::Coverage PAYLOAD_CLASS ZMQ_SNDMORE

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
