package Log::Any::Adapter::Base;
BEGIN {
  $Log::Any::Adapter::Base::VERSION = '0.05';
}
use Log::Any;
use Log::Any::Adapter::Util qw(make_method);
use strict;
use warnings;
use base qw(Log::Any::Adapter::Core);    # In Log-Any distribution

sub new {
    my $class = shift;
    my $self  = {@_};
    bless $self, $class;
    $self->init(@_);
    return $self;
}

sub init { }

sub delegate_method_to_slot {
    my ( $class, $slot, $method, $adapter_method ) = @_;

    make_method( $method,
        sub { my $self = shift; return $self->{$slot}->$adapter_method(@_) },
        $class );
}

1;



=pod

=head1 NAME

Log::Any::Adapter::Base

=head1 VERSION

version 0.05

=head1 DESCRIPTION

This is the base class for Log::Any adapters. See
L<Log::Any::Adapter::Development|Log::Any::Adapter::Development> for
information on developing Log::Any adapters.

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Jonathan Swartz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

