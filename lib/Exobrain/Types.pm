package Exobrain::Types;
use 5.010;
use strict;
use warnings;

use JSON::Any;

my $json = JSON::Any->new( allow_blessed => 1 );

use MooseX::Types -declare => [qw(
    JSON
    POI
    SmsStr
    PhoneNum
    Exobrain
    PosNum
    PosInt
    TimeOut
)];

use MooseX::Types::Moose qw(
    HashRef
    Ref
    Str
    Num
    Int
);

subtype JSON,
    as Str,
    where { $json->decode($_) }
;

coerce JSON,
    from Ref,
    via { $json->encode($_) }
;

subtype SmsStr,
    as Str,
    where { length($_) <= 160 }
;

# TODO: Properly define phone numbers
subtype PhoneNum,
    as Str,
    where { 1 },
;

subtype PosNum,
    as Num,
    where { $_ > 0 }
;

subtype PosInt,
    as Int,
    where { $_ > 0 }
;

subtype TimeOut,
    as PosNum,
    where { 1 },
;

class_type Exobrain, { class => 'Exobrain' } ;

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

version 1.06

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
