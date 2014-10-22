package Log::Any::Adapter;
BEGIN {
  $Log::Any::Adapter::VERSION = '0.09';
}
use 5.006;
use Log::Any;
use Log::Any::Manager;
use Log::Any::Adapter::Util qw(make_method);
use strict;
use warnings;

# Checked by Log::Any to see if get_logger should be forwarded here
#
our $Initialized = 1;

my $manager = Log::Any::Manager->new();

foreach my $method (qw(get_logger set remove)) {
    make_method(
        $method,
        sub {
            my $class = shift;
            return $manager->$method(@_);
        }
    );
}

sub import {
    my $pkg = shift;
    $pkg->set(@_) if (@_);
}

1;



=pod

=head1 NAME

Log::Any::Adapter -- Tell Log::Any where to send its logs

=head1 VERSION

version 0.09

=head1 SYNOPSIS

    # Log to a file, or stdout, or stderr for all categories
    #
    use Log::Any::Adapter ('File', '/path/to/file.log');
    use Log::Any::Adapter ('Stdout');
    use Log::Any::Adapter ('Stderr');

    # Use Log::Log4perl for all categories
    #
    Log::Log4perl::init('/etc/log4perl.conf');
    Log::Any::Adapter->set('Log4perl');

    # Use Log::Dispatch for Foo::Baz
    #
    use Log::Dispatch;
    my $log = Log::Dispatch->new(outputs => [[ ... ]]);
    Log::Any::Adapter->set( { category => 'Foo::Baz' },
        'Dispatch', dispatcher => $log );

    # Use Log::Dispatch::Config for Foo::Baz and its subcategories
    #
    use Log::Dispatch::Config;
    Log::Dispatch::Config->configure('/path/to/log.conf');
    Log::Any::Adapter->set(
        { category => qr/^Foo::Baz/ },
        'Dispatch', dispatcher => Log::Dispatch::Config->instance() );

    # Use your own adapter for all categories
    #
    Log::Any::Adapter->set('+My::Log::Any::Adapter', ...);

=head1 DESCRIPTION

The C<Log-Any-Adapter> distribution implements L<Log::Any|Log::Any> class
methods to specify where logs should be sent. It is a separate distribution so
as to keep C<Log::Any> itself as simple and unchanging as possible.

You do not have to use anything in this distribution explicitly. It will be
auto-loaded when you call one of the methods below.

=head1 ADAPTERS

In order to use a logging mechanism with C<Log::Any>, there needs to be an
adapter class for it. Typically this is named Log::Any::Adapter::I<something>.

=head2 Adapters in this distribution

Three basic adapters come with this distribution -- L<File>, L<Stdout> and
L<Stderr>:

    use Log::Any::Adapter ('File', '/path/to/file.log');
    use Log::Any::Adapter ('Stdout');
    use Log::Any::Adapter ('Stderr');

    # or

    use Log::Any::Adapter;
    Log::Any::Adapter->set('File', '/path/to/file.log');
    Log::Any::Adapter->set('Stdout');
    Log::Any::Adapter->set('Stderr');

All of them simply output the message and newline to the specified destination;
a datestamp prefix is added in the C<File> case. For anything more complex
you'll want to use a more robust adapter from CPAN.

=head2 Adapters on CPAN

A sampling of adapters available on CPAN as of this writing:

=over

=item *

L<Log::Any::Adapter::Log4perl|Log::Any::Adapter::Log4perl>

=item *

L<Log::Any::Adapter::Dispatch|Log::Any::Adapter::Dispatch>

=item *

L<Log::Any::Adapter::FileHandle|Log::Any::Adapter::FileHandle>

=item *

L<Log::Any::Adapter::Syslog|Log::Any::Adapter::Syslog>

=back

You may find other adapters on CPAN by searching for "Log::Any::Adapter", or
create your own adapter. See
L<Log::Any::Adapter::Development|Log::Any::Adapter::Development> for more
information on the latter.

=head1 SETTING AND REMOVING ADAPTERS

=over

=item Log::Any::Adapter->set ([options, ]adapter_name, adapter_params...)

This method sets the adapter to use for all log categories, or for a particular
set of categories.

I<adapter_name> is the name of an adapter. It is automatically prepended with
"Log::Any::Adapter::". If instead you want to pass the full name of an adapter,
prefix it with a "+". e.g.

    # Use My::Adapter class
    Log::Any::Adapter->set('+My::Adapter', arg => $value);

I<adapter_params> are passed along to the adapter constructor. See the
documentation for the individual adapter classes for more information.

An optional hash of I<options> may be passed as the first argument. Options
are:

=over

=item category

A string containing a category name, or a regex (created with qr//) matching
multiple categories.  If not specified, all categories will be affected.

=item lexically

A reference to a lexical variable. When the variable goes out of scope, the
adapter setting will be removed. e.g.

    {
        Log::Any::Adapter->set({lexically => \my $lex}, ...);

        # in effect here
        ...
    }
    # no longer in effect here

=back

C<set> returns an entry object, which can be passed to C<remove>.

=item use Log::Any::Adapter (...)

If you pass arguments to C<use Log::Any::Adapter>, it calls C<<
Log::Any::Adapter->set >> with those arguments.

=item Log::Any::Adapter->remove (entry)

Remove an I<entry> previously returned by C<set>.

=back

=head1 MULTIPLE ADAPTER SETTINGS

C<Log::Any> maintains a stack of entries created via C<set>.

When you get a logger for a particular category, C<Log::Any> will work its way
down the stack and use the first matching entry.

Whenever the stack changes, any C<Log::Any> loggers that have previously been
created will automatically adjust to the new stack. For example:

    my $log = Log::Any->get_logger();
    $log->error("aiggh!");   # this goes nowhere
    ...
    {
        Log::Any::Adapter->set({ lexically => \my $lex }, 'Log4perl');
        $log->error("aiggh!");   # this goes to log4perl
        ...
    }
    $log->error("aiggh!");   # this goes nowhere again

=head1 SEE ALSO

L<Log::Any|Log::Any>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Jonathan Swartz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

