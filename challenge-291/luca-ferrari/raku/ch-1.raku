#!raku

#
# Perl Weekly Challenge 291
# Task 1
#
# See <https://perlweeklychallenge.org/blog/perl-weekly-challenge-291>
#

sub MAIN( *@nums where { @nums.elems == @nums.grep( *.Int ).elems } ) {

    for 1 ..^ @nums.elems -> $m {
	$m.say and exit if ( @nums[ 0 ..^ $m ].sum == @nums[ $m ^..^ @nums.elems ].sum );
    }

    'False'.say;
}
