#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.008005;

{
    package Point;
    use Mouse;
    has x => (is => 'rw');
    has y => (is => 'rw');
    sub distance {
        my $self = shift;
        sqrt( $self->x ** 2 + $self->y ** 2 );
    }
    no Mouse;
}

print Point->new(x => 1, y => 1)->distance;
