package Exobrain::Agent;
use Moose::Role;
use Exobrain;
use Exobrain::Types qw(Exobrain);

# ABSTRACT: Agent role for Exobrain agents
our $VERSION = '1.08'; # VERSION


has exobrain => (
    is => 'ro',
    isa => Exobrain,
    lazy => 1,
    builder => '_build_exobrain',
);

sub _build_exobrain { return Exobrain->new; }



has component => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    builder => '_build_component',
);

method _build_component() {
    if (my $method = $self->can("component_name") ) {
        return $self->$method;
    }

    my $component = ref($self);
    $component =~ s/Exobrain::Agent:://;
    return $component;
}


has config => (
    is => 'ro',
    lazy => 1,
    builder => '_build_config',
);

# By using the component name as the heading for our config, it's easy
# to clearly tell which config belongs where.

method _build_config() {
    return $self->exobrain->config->{ $self->component };
}


has cache => (
    is => 'ro',
    lazy => 1,
    builder => '_build_cache',
);

method _build_cache() {
    eval "use Exobrain::Cache; 1;" or die $@;   # Lazy load module
    return Exobrain::Cache->new( namespace => $self->component );
}


has json => (
    is => 'ro',
    lazy => 1,
    builder => '_build_json',
);

method _build_json() {
    eval "use JSON::Any; 1;" or die $@;
    return JSON::Any->new;
}

1;

__END__

=pod

=head1 NAME

Exobrain::Agent - Agent role for Exobrain agents

=head1 VERSION

version 1.08

=head1 SYNOPSIS

    use Moose;
    with 'Exobrain::Agent';

=head1 DESCRIPTION

This role provides a number of utility methods and attributes to
Exobrain agents. Most agents will prefer to use the
L<Exobrain::Agent::Poll> or L<Exobrain::Agent::Run> roles
instead, and which in turn consume this role and hence provide
its functionality.

Where possible, all attributes provided by this role are lazily
generated, including lazily loading modules.

=head1 METHODS

=head2 exobrain

    $self->exobrain->watch_loop(...);

Returns an L<Exobrain> object.

=head2 component

    my $component = $self->component;

Exobrain components all share the same configuration and cache,
and are often packaged as separate distributions. This method
returns the current component name.

By default this is the same as the class name with
'Exobrain::Agent::' stripped off. Agents and roles which are
part of a specific component should override this attribute
(or supply their own default).

=head2 config

    my $user = $self->config->{user};

Returns the config for our current component.
Use C<$self->exobrain->config> instead if you want the I<top-level>
config.

=head2 cache

    my $cache = $self->cache;

Returns an L<Exobrain::Cache> object, with a namespace of
C<$self->component>.

=head2 json

    my $json = $self->json;

Returns a L<JSON::Any> object.

=head1 AUTHOR

Paul Fenwick <pjf@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Paul Fenwick.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
