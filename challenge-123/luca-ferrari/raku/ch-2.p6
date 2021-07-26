#!raku


class Point {
    has Int $.x;
    has Int $.y;

    method distance( Point $other ) {
        return ( ( $other.x - $!x ) * ( $other.x - $!x )
        + ( $other.y - $!y ) * ( $other.y - $!y ) ).sqrt;
    }
}

sub MAIN( Int $x1, Int $y1,
          Int $x2, Int $y2,
          Int $x3, Int $y3,
          Int $x4, Int $y4 ) {


    my Point $p1 = Point.new( :x( $x1 ), :y( $y1 ) );
    my Point $p2 = Point.new( :x( $x2 ), :y( $y2 ) );
    my Point $p3 = Point.new( :x( $x3 ), :y( $y3 ) );
    my Point $p4 = Point.new( :x( $x4 ), :y( $y4 ) );

    # check if the distances are the same
    my $ok-length = $p1.distance( $p2 ) == $p2.distance( $p3 ) == $p3.distance( $p4 ) == $p4.distance( $p1 );

    '0'.say and exit if ! $ok-length;

    # check if the diagonals have the same distance
    my $ok-diags = $p1.distance( $p3 ) == $p2.distance( $p4 );

    '0'.say and exit if ! $ok-diags;

    # check if the P1, P2, P3 and P1, P4, P3 are on square triangle
    my $l = $p1.distance( $p2 );
    my $d = ( 2 * $l * $l ).sqrt;
    my $ok-triangle = $d == $p1.distance( $p3 ) && $d == $p4.distance( $p2 );

    '0'.say and exit if ! $ok-triangle;
    '1'.say;
}
