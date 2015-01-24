package Acme::FatPack::XS;
use 5.008005;
use strict;
use warnings;
use MIME::Base64 ();
use Config;
use File::Spec;

our $VERSION = "0.01";

sub new { bless {}, shift }

sub _perl_info {
    my $self = shift;
    my $perl = shift || $^X;
    $self->{_perl_info}{$perl} ||= do {
        open my $fh, "-|", $perl, "-MConfig", "-le", q(
            print "5.$Config{PERL_VERSION}";
            print $Config{archname};
            print $Config{dlext};
            print $_ for @INC;
        ) or die "Failed to exec '$perl'";
        chomp( my @line = <$fh> );
        +{
            version => $line[0],
            archname => $line[1],
            dlext => $line[2],
            inc => [ @line[3..$#line] ],
        }
    };
}

for my $key (qw(version archname dlext inc)) {
    no strict 'refs';
    *$key = sub {
        my $self = shift;
        my $info = $self->_perl_info(@_);
        $info->{$key};
    };
}

sub identity {
    my $self = shift;
    my $perl = shift || $^X;
    my $version = $self->version($perl);
    my $archname = $self->archname($perl);
    "$version/$archname";
}

sub encode_base64 {
    my ($self, $file) = @_;
    my $content = do { open my $fh, "<:raw", $file or die; local $/; <$fh> };
    my $encoded = MIME::Base64::encode_base64($content);
    $encoded =~ s/\n+\z//sm;
    $encoded;
}

sub find_dl_path {
    my ($self, $spec) = @_;
    my $module = $spec->{module};
    my $perl   = $spec->{perl};
    my @path = split /::/, $module;
    push @path, "$path[-1]." . $self->dlext($perl);
    for my $inc (@{ $self->inc($perl) }) {
        my $abs_path = File::Spec->catfile($inc, "auto", @path);
        if (-f $abs_path) {
            return ( File::Spec->catfile("auto", @path), $abs_path );
        }
    }
    return;
}

sub fatpack_line {
    my ($self, $option) = @_;
    my $perl = $option->{perl};
    my $content = $option->{content};
    my $path = $option->{path};
    <<",,,";
\$fatpack{"@{[ $self->identity($perl) ]}/$path"} = <<'...';
$content
...
,,,
}

sub parse_spec {
    my $self = shift;
    my @spec;
    for my $arg (@_) {
        my ($perl, $module) = $arg =~ /=/ ? ( split /=/, $arg ) : ($^X, $arg);
        push @spec, { perl => $perl, module => $module };
    }
    @spec;
}

sub run {
    my $self = shift;
    my @spec = $self->parse_spec(@_);
    for my $spec (@spec) {
        my ($relative_path, $abs_path) = $self->find_dl_path($spec)
            or die "Cannot find $spec->{module}\n";
        my $encoded = $self->encode_base64($abs_path);
        print $self->fatpack_line({
            perl => $spec->{perl},
            path => $relative_path,
            content => $encoded,
        });

    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Acme::FatPack::XS - Can we fatpack xs code?

=head1 SYNOPSIS

Assume you have C<script.pl> that uses Mouse,
and want to fatpack it.

First fatpack C<script.pl> normaly:

    $ cpanm -lextlib --reinstall -nq Mouse
    $ fatpack-simple -p fatpack1 script.pl

Sencod, prepend header to C<fatpack1>:

    $ fatpack-xs-heaer.pl >> script.fatpack.pl
    $ cat fatpack1 >> script.fatpack.pl

Then manualy append C<fatpack-xs.pl Mouse> output to C<script.fatpack.pl>:

    $ fatpack-xs.pl Mouse > fatpack2
    $ vim script.fatpack.pl fatpack2

Now you'll get Mouse fatpacked C<script.fatpack.pl>. See C<eg> directory.

=head1 DESCRIPTION

Can we fatpack xs code?

=head1 LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@cpan.orgE<gt>

=cut

