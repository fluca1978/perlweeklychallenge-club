


package PWC277;

/**
 * PL/Java implementation for PWC 277
 * Task 2
 * See <https://perlweeklychallenge.org/blog/perl-weekly-challenge-277>
 *
 *
 * To compile on the local machine:

 $ export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/  # if not already set
 $ mvn clean build
 $ scp target/PWC277-1.jar  luca@rachel:/tmp


 * To install into PostgreSQL execute:

 select sqlj.install_jar( 'file:///tmp/PWC277-1.jar', 'PWC277', true );
 select sqlj.set_classpath( 'public', 'PWC277' );

 select pwc277.task2_pljava();

 and then to redeploy:

 select sqlj.replace_jar( 'file:///tmp/PWC277-1.jar', 'PWC277', true );

*/

import org.postgresql.pljava.*;
import org.postgresql.pljava.annotation.Function;
import static org.postgresql.pljava.annotation.Function.Effects.IMMUTABLE;
import static org.postgresql.pljava.annotation.Function.OnNullInput.RETURNS_NULL;

import java.util.*;
import java.util.stream.*;
import java.sql.SQLException;
import java.util.logging.*;
import java.sql.ResultSet;
import java.sql.Date;

public class Task2 {

    private final static Logger logger = Logger.getAnonymousLogger();

    @Function( schema = "pwc277",
	       onNullInput = RETURNS_NULL,
	       effects = IMMUTABLE )
    public static final int task2_pljava( int[] numbers ) throws SQLException {
	logger.log( Level.INFO, "Entering pwc277.task2_pljava" );

	final int[] c = new int[]{ 0 };
	IntStream.range( 0, numbers.length - 1 )
	    .forEach( i -> {
		    c[ 0 ] += IntStream.range( i + 1, numbers.length )
			.filter( j -> {
				return numbers[ i ] != numbers[ j ]
				    && Math.abs( numbers[ i ] - numbers[ j ] ) < Math.min( numbers[ i ], numbers[ j ] );
			    } ).count();
		} );

	return c[ 0 ];
    }
}
