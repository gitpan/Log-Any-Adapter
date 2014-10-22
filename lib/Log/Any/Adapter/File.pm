package Log::Any::Adapter::File;
BEGIN {
  $Log::Any::Adapter::File::VERSION = '0.08';
}
use strict;
use warnings;
use base qw(Log::Any::Adapter::FileScreenBase);

sub new {
    my ( $class, $file ) = @_;
    return $class->SUPER::new( file => $file );
}

sub init {
    my $self = shift;
    my $file = $self->{file};
    open( $self->{fh}, ">>", $file )
      or die "cannot open '$file' for append: $!";
    $self->{fh}->autoflush(1);
}

__PACKAGE__->make_logging_methods(
    sub {
        my ( $self, $text ) = @_;
        my $msg = sprintf( "[%s] %s\n", scalar(localtime), $text );
        $self->{fh}->print($msg);
    }
);

1;



=pod

=head1 NAME

Log::Any::Adapter::File

=head1 VERSION

version 0.08

=head1 SYNOPSIS

    use Log::Any::Adapter ('File', '/path/to/file.log');

    # or

    use Log::Any::Adapter;
    ...
    Log::Any::Adapter->set('File', '/path/to/file.log');

=head1 DESCRIPTION

This simple built-in L<Log::Any|Log::Any> adapter logs each message to the
specified file, with a datestamp prefix and newline appended. The file is
opened for append with autoflush on. Category and log level are ignored.

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Jonathan Swartz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

