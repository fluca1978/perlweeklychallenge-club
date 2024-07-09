


package PWC277;

/**
 * PL/Java implementation for PWC 277
 * Task 1
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

public class Task1 {

    private final static Logger logger = Logger.getAnonymousLogger();

    @Function( schema = "pwc277",
	       onNullInput = RETURNS_NULL,
	       effects = IMMUTABLE )
    public static int task1_pljava( String[] words1, String[] words2 ) throws SQLException {
	logger.log( Level.INFO, "Entering pwc277.task1_pljava" );

	final Map<String, Integer[]> counting = new HashMap<String, Integer[]>();

	Stream.of( words1 ).forEach( current -> {
		Integer[] count = { 0, 0 };
		counting.putIfAbsent( current, count );
		count = counting.get( current );
		count[ 0 ]++;
		counting.put( current, count );
	    } );


	Stream.of( words2 ).forEach( current -> {
		Integer[] count = { 0, 0 };
		counting.putIfAbsent( current, count );
		count = counting.get( current );
		count[ 1 ]++;
		counting.put( current, count );
	    } );

	return (int) counting.entrySet().stream().filter( current -> {
		Integer[] count = current.getValue();
		return count[ 0 ] == count[ 1 ] && count[ 0 ] == 1;
	    } ).count();
    }
}
