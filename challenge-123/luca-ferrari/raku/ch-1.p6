#!raku


sub is-ugly( Int $n ) {
    # short circuit!
    return True if $n == any( 2, 3, 5 );

    return $n %% 2 || $n %% 3 || $n %% 5;
    
}

sub MAIN( Int $n where { $n > 1 } ) {
    my  @ugly-numbers = lazy gather {
        for 1 .. Inf {
            take $_ if $_ == 1;
            take $_ if is-ugly( $_ );
        }  
    } 

    
    @ugly-numbers[ $n - 1 ].say;
}
