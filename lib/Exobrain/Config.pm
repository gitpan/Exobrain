package Exobrain::Config;
use strict;
use warnings;
use parent 'Config::Tiny';

# Bare-bones hack to wrap Config::Tiny

# TODO: Use an exobrain.config.d/ or similar multi-file structure.

sub new {
    my ($class) = @_;

    my $file = $ENV{EXOBRAIN_CONFIG} || "$ENV{HOME}/.exobrainrc";

    my $self = $class->read($file);

    $self or die "Cannot read config - " . Config::Tiny->errstr;

    return $self;
}

1;

__END__

=pod

=head1 NAME

Exobrain::Config

=head1 VERSION

version 1.00

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
