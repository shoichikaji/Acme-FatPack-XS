#!/usr/bin/env perl

# This chunk of stuff was generated by App::FatPacker. To find the original
# file's code, look for the end of this BEGIN block or the string 'FATPACK'
BEGIN {
my %fatpacked;

$fatpacked{"Acme/FatPack/XS.pm"} = '#line '.(1+__LINE__).' "'.__FILE__."\"\n".<<'ACME_FATPACK_XS';
  package Acme::FatPack::XS;use 5.008005;use strict;use warnings;use MIME::Base64 ();use Config;use File::Spec;our$VERSION="0.01";sub new {bless {},shift}sub _perl_info {my$self=shift;my$perl=shift || $^X;$self->{_perl_info}{$perl}||= do {open my$fh,"-|",$perl,"-MConfig","-le",q(
              print "5.$Config{PERL_VERSION}";
              print $Config{archname};
              print $Config{dlext};
              print $_ for @INC;
          ) or die "Failed to exec '$perl'";chomp(my@line=<$fh>);+{version=>$line[0],archname=>$line[1],dlext=>$line[2],inc=>[@line[3..$#line]],}}}for my$key (qw(version archname dlext inc)){no strict 'refs';*$key=sub {my$self=shift;my$info=$self->_perl_info(@_);$info->{$key}}}sub identity {my$self=shift;my$perl=shift || $^X;my$version=$self->version($perl);my$archname=$self->archname($perl);"$version/$archname"}sub encode_base64 {my ($self,$file)=@_;my$content=do {open my$fh,"<:raw",$file or die;local $/;<$fh>};my$encoded=MIME::Base64::encode_base64($content);$encoded =~ s/\n+\z//sm;$encoded}sub find_dl_path {my ($self,$spec)=@_;my$module=$spec->{module};my$perl=$spec->{perl};my@path=split /::/,$module;push@path,"$path[-1]." .$self->dlext($perl);for my$inc (@{$self->inc($perl)}){my$abs_path=File::Spec->catfile($inc,"auto",@path);if (-f $abs_path){return (File::Spec->catfile("auto",@path),$abs_path)}}return}sub fatpack_line {my ($self,$option)=@_;my$perl=$option->{perl};my$content=$option->{content};my$path=$option->{path};<<",,,"}sub parse_spec {my$self=shift;my@spec;for my$arg (@_){my ($perl,$module)=$arg =~ /=/ ? (split /=/,$arg): ($^X,$arg);push@spec,{perl=>$perl,module=>$module }}@spec}sub run {my$self=shift;my@spec=$self->parse_spec(@_);for my$spec (@spec){my ($relative_path,$abs_path)=$self->find_dl_path($spec)or die "Cannot find $spec->{module}\n";my$encoded=$self->encode_base64($abs_path);print$self->fatpack_line({perl=>$spec->{perl},path=>$relative_path,content=>$encoded,})}}1;
  \$fatpack{"@{[ $self->identity($perl) ]}/$path"} = <<'...';
  $content
  ...
  ,,,
ACME_FATPACK_XS

s/^  //mg for values %fatpacked;

my $class = 'FatPacked::'.(0+\%fatpacked);
no strict 'refs';
*{"${class}::files"} = sub { keys %{$_[0]} };

if ($] < 5.008) {
  *{"${class}::INC"} = sub {
     if (my $fat = $_[0]{$_[1]}) {
       return sub {
         return 0 unless length $fat;
         $fat =~ s/^([^\n]*\n?)//;
         $_ = $1;
         return 1;
       };
     }
     return;
  };
}

else {
  *{"${class}::INC"} = sub {
    if (my $fat = $_[0]{$_[1]}) {
      open my $fh, '<', \$fat
        or die "FatPacker error loading $_[1] (could be a perl installation issue?)";
      return $fh;
    }
    return;
  };
}

unshift @INC, bless \%fatpacked, $class;
  } # END OF FATPACK CODE

use strict;
use warnings;
use utf8;
use Acme::FatPack::XS;
Acme::FatPack::XS->new->run(@ARGV);
