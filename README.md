# NAME

Acme::FatPack::XS - Can we fatpack xs code?

# SYNOPSIS

Assume you have `script.pl` that uses Mouse,
and want to fatpack it.

First fatpack `script.pl` normaly:

    $ cpanm -lextlib --reinstall -nq Mouse
    $ fatpack-simple -p fatpack1 script.pl

Sencod, prepend header to `fatpack1`:

    $ fatpack-xs-heaer.pl >> script.fatpack.pl
    $ cat fatpack1 >> script.fatpack.pl

Then manualy append `fatpack-xs.pl` output to `script.fatpack.pl`:

    $ fatpack-xs.pl extlib/lib/perl5/darwin-2level/auto/Mouse/Mouse.bundle > fatpack2
    $ vim script.fatpack.pl fatpack2

Now you'll get Mouse fatpacked `script.fatpack.pl`. See `eg` directory.

# DESCRIPTION

Can we fatpack xs code?

# LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shoichi Kaji <skaji@cpan.org>
