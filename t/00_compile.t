use strict;
use Test::More 0.98;

use_ok $_ for qw(
    Acme::FatPack::XS
);

ok system($^X, "-Ilib", "-wc", $_) == 0 for glob "script/*";

done_testing;
