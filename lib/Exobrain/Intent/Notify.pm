package Exobrain::Intent::Notify;

use 5.010;
use Moose;
use Method::Signatures;

# ABSTRACT: Send a user notification via Exobrain
our $VERSION = '1.08'; # VERSION


method summary() { return $self->message; }

BEGIN { with 'Exobrain::Intent'; }

payload message  => ( isa => 'Str' );
payload priority => ( isa => 'Int', default => 0 );

# TODO: Add title, URL, etc?

1;

__END__

=pod

=head1 NAME

Exobrain::Intent::Notify - Send a user notification via Exobrain

=head1 VERSION

version 1.08

=head1 SYNOPSIS

    $exobrain->intent('Notify',
        message  => "Hello World",
        priority => 0,
    );

=head1 DESCRIPTION

This intent notifies the user with the given message.
Priority is optional, and defaults to zero. We use the
same priority levels as Pushover:

    -1 - Low priority, don't disturb user.
     0 - Typical priority. May disturb user.
     1 - High priority. Often disturbs user.
     2 - Emergency. Wake devices from silent.

Some mechanisms may require the user acknowledge a
priority 2 event. Use with care.

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
