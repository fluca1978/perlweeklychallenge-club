#!raku


class Node {
    has Int $.value;
    has Node $.left is rw;
    has Node $.right is rw;
    has Node $.parent is rw;
}

sub MAIN( Str $nodes, Str $delim = '|' ) {
    my @nodes-as-text = $nodes.split( $delim );
    my @tree;


    for @nodes-as-text -> $current-nodes {
        my @current-level;
        my $index = -1;
        my @values = $current-nodes.words;
        @values.push: '*' if @values.elems !%% 2;
        for @values -> $left, $right {
            say "$left, $right";
            $index++;
            my Node $left-node  = Node.new: value => $left.Int  if $left !~~ '*';
            my Node $right-node = Node.new: value => $right.Int if $right !~~ '*';

            @current-level.push: $left-node  if $left-node;
            @current-level.push: $right-node  if $right-node;

            next if ! @tree;

            @tree[ * - 1 ][ $index ].left  = $left-node  if $left-node;
            $left-node.parent = @tree[ * - 1 ][ $index ] if $left-node;

            @tree[ * - 1 ][ $index ].right = $right-node if $right-node;
            $right-node.parent = @tree[ * - 1 ][ $index ] if $right-node;


        }

        @tree.push: @current-level;
    }


    my @paths;
    for @tree.reverse -> @leaves {
        for @leaves -> $current-leaf is rw {
            next if $current-leaf.left || $current-leaf.right;
            my $path = 0;
            while ( $current-leaf ) {
                $path++;
                $current-leaf = $current-leaf.parent;
            }
            @paths.push: $path;
        }
    }

    @paths.min.say;
}
