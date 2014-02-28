package Exobrain::Cache;

use v5.10.0;
use strict;
use warnings;

use parent qw(CHI);

__PACKAGE__->config({
    defaults => {
        driver   => 'File',
        root_dir => "$ENV{HOME}/.exobrain/cache",
    }
});

1;

__END__

=pod

=head1 NAME

Exobrain::Cache

=head1 VERSION

version 1.01

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
