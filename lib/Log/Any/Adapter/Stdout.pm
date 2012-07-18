package Log::Any::Adapter::Stdout;
BEGIN {
  $Log::Any::Adapter::Stdout::VERSION = '0.08';
}
use strict;
use warnings;
use base qw(Log::Any::Adapter::FileScreenBase);

__PACKAGE__->make_logging_methods(
    sub {
        my ( $self, $text ) = @_;
        print STDOUT "$text\n";
    }
);

1;



=pod

=head1 NAME

Log::Any::Adapter::Stdout

=head1 VERSION

version 0.08

=head1 SYNOPSIS

    use Log::Any::Adapter ('Stdout');

    # or

    use Log::Any::Adapter;
    ...
    Log::Any::Adapter->set('Stdout');

=head1 DESCRIPTION

This simple built-in L<Log::Any|Log::Any> adapter logs each message to STDOUT
with a newline appended. Category and log level are ignored.

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Jonathan Swartz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

