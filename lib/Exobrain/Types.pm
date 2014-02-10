package Exobrain::Types;
use 5.010;
use strict;
use warnings;

use JSON::Any;

my $json = JSON::Any->new( allow_blessed => 1 );

use MooseX::Types -declare => [qw(
    JSON
    POI
    TweetStr
)];;

use MooseX::Types::Moose qw(
    HashRef
    Ref
    Str
);

subtype JSON,
    as Str,
    where { $json->decode($_) }
;

coerce JSON,
    from Ref,
    via { $json->encode($_) }
;

subtype TweetStr,
    as Str,
    where { length($_) <= 140 }
;

class_type POI,
    { class => 'Exobrain::Measurement::Geo::POI' }
;

coerce POI,
    from HashRef,
    via { Exobrain::Measurement::Geo::POI->new(%$_) }
;

1;

__END__

=pod

=head1 NAME

Exobrain::Types

=head1 VERSION

version 0.06

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
