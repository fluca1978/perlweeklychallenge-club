#!raku


sub MAIN( Str $houses, Bool $verbose = True ) {
    my %rob;
    my @values = $houses.words;
    my $current-index = 0;



    # bootstrap

    %rob{ $current-index } = @values[ $current-index ];




    while ( $current-index < ( @values.elems - 2 ) ) {
        my %current;
        %current = key => $_,
                   value => @values[ $_ ]
                         if ! %current || @values[ $_ ] > %current<value>
                         for ( $current-index + 2 ) ..^ @values.elems;

        %rob{ %current<key> } = %current<value>;
        $current-index = %current<key>;
    }

    # print the result
    %rob.values.sum.say;

    # print the status
    if $verbose {
        "House { .key } = { .value } ".say for %rob;
    }
}
