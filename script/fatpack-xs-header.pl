#!/usr/bin/env perl
use strict;
use warnings;
print <DATA>;
__DATA__
BEGIN { # START of fatpack xs
my %fatpack;
# NEED TO FILL IN HERE
use MIME::Base64 ();
use File::Path ();
use File::Basename ();
use Config ();
my $dir = "$ENV{HOME}/.perl-fatpack-xs";
my $identity = "5.$Config::Config{PERL_VERSION}/$Config::Config{archname}";
for my $path (sort keys %fatpack) {
    next if $path !~ /^$identity/;
    my $abs_path = "$dir/$path";
    next if -f $abs_path;
    File::Path::mkpath( "$dir/" . File::Basename::dirname($path) );
    open my $fh, ">:raw", $abs_path
        or die "Cannot open $abs_path: $!\n";
    print {$fh} MIME::Base64::decode_base64($fatpack{$path});
}
unshift @INC, "$dir/$identity";
} # END of fatpack xs
