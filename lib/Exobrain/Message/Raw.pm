package Exobrain::Message::Raw;
use v5.10.0;
use Moose;
use JSON::Any;
use Method::Signatures;
use Carp;

use Moose::Util::TypeConstraints;

my $json = JSON::Any->new;

# Summary declared early, so our role can see it.

has 'summary'    => ( is => 'ro', isa => 'Str', required => 1 );
has '_data'      => ( is => 'rw', isa => 'Ref' );
has 'namespace'  => ( is => 'ro', isa => 'Str', required => 1 );

with 'Exobrain::Message';

# Stash our explicit data section

sub BUILD {
    my ($self, $args) = @_;

    my $data = $args->{data} or croak "Raw packets need a data argument";

    $self->_data($data);

    return;
};

method data() {
    return $self->_data;
}

# Build a typed message from our raw message

method to_class($class) {
    my $exobrain = $self->exobrain
        or croak "Can't use to_class() on a message without an exobrain object.";

    my $msg = $exobrain->message_class($class,
        %{ $self->data },
        summary   => $self->summary,
        timestamp => $self->timestamp,
        raw       => $self->raw,
        namespace => $self->namespace,
        source    => $self->source,
    );
}

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;

    # If called with an arrayref, then we're reconstituting a packet
    # off the wire

    if (@args == 1 and ref($args[0]) eq 'ARRAY') {
        my $frames = $args[0];
        my (undef, $namespace, $source) = split(/_/, $frames->[0]);
        return $class->$orig(
            namespace => $namespace,
            source    => $source,
            timestamp => time(), # XXX - This should be off the wire
            summary   => $frames->[2],
            data      => $json->decode( $frames->[3] ),
            raw       => $json->decode( $frames->[4] ),
        );
    }

    return $class->$orig(@args);
};


1;

__END__

=pod

=head1 NAME

Exobrain::Message::Raw

=head1 VERSION

version 0.06

=for Pod::Coverage BUILD

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
