CREATE SCHEMA IF NOT EXISTS pwc151;

CREATE TABLE IF NOT EXISTS pwc151.node(
       pk int generated always as identity
       , val int
       , parent_pk int
       , left_pk int
       , right_pk int
       , level int
       , PRIMARY KEY( pk )
       , FOREIGN KEY( parent_pk ) REFERENCES pwc151.node( pk )
       , FOREIGN KEY( left_pk ) REFERENCES pwc151.node( pk )
       , FOREIGN KEY( right_pk ) REFERENCES pwc151.node( pk )
);

TRUNCATE pwc151.houses CASCADE;

/**
 * Produces a flat tree like:

testdb=> SELECT * FROM  pwc151.f_flat_tree( '1 | 2 3 | 4 5 ');
DEBUG:  Inspecting [1]
DEBUG:  Inspecting [|]
DEBUG:  Changing level!
DEBUG:  Inspecting [2]
DEBUG:  Inspecting [3]
DEBUG:  Inspecting [|]
DEBUG:  Changing level!
DEBUG:  Inspecting [4]
DEBUG:  Inspecting [5]
val | lev
-----+-----
1 |   0
2 |   1
3 |   1
4 |   2
5 |   2
(5 rows)
*/
CREATE OR REPLACE FUNCTION
pwc151.f_flat_tree( tree text, delim char default '|' )
RETURNS TABLE( val int, lev int )
AS $CODE$
DECLARE
        needle text;
BEGIN
        lev := 0;
        FOR needle IN SELECT v FROM regexp_split_to_table( tree, delim ) v LOOP
            CONTINUE WHEN needle ~ '^\s+$';
            RAISE DEBUG 'Inspecting [%]', needle;

            IF needle = delim THEN
               RAISE DEBUG 'Changing level!';
               lev := lev + 1;
               CONTINUE;
           END IF;

           IF needle = '*' THEN
              val := NULL;
           ELSE
              val := needle::int;
           END IF;

           RETURN NEXT;
        END LOOP;
    RETURN;
END
$CODE$
LANGUAGE plpgsql;








CREATE OR REPLACE PROCEDURE
pwc151.f_generate_tree( tree text, delim text default '|' )
AS $CODE$
DECLARE
        current_tuple pwc151.node%rowtype;
        parent_tuple  pwc151.node%rowtype;
        lev int := 1;
        val int := 0;
        max_lev int;
        counter int := 0;
        last_pk int := -1;
BEGIN
        TRUNCATE pwc151.node CASCADE;

        INSERT INTO pwc151.node( val, level )
        SELECT * FROM pwc151.f_flat_tree( tree, delim );

        COMMIT;

        SELECT max( level )
        INTO max_lev
        FROM pwc151.node;

        RAISE DEBUG 'Max level found %', lev;

        WHILE lev <= max_lev LOOP
              RAISE DEBUG '========= Level % ==============', lev;


           FOR parent_tuple IN SELECT * FROM pwc151.node WHERE level = lev - 1 ORDER BY pk LOOP
                  counter := 0;
              FOR current_tuple IN SELECT * FROM pwc151.node
                                   WHERE level = lev
                                   AND parent_pk IS NULL
                                   AND pk >= last_pk
                                   ORDER BY pk LOOP
                  last_pk := current_tuple.pk;
                  EXIT WHEN counter >= 2;
                  RAISE DEBUG 'Step %: Adjusting node [%] [%]', counter, current_tuple.val, current_tuple.pk;
                  CONTINUE WHEN lev = 0; -- root node


                      RAISE DEBUG 'Parent node [%] -> [%] = [%]', parent_tuple.val, ( counter % 2 = 0 ), current_tuple.val;
                      counter := counter + 1;

                      CONTINUE WHEN current_tuple.val IS NULL;

                      IF counter % 2 <> 0 THEN
                         RAISE DEBUG 'Left node [%] child of [%]', current_tuple.val, parent_tuple.val;
                         UPDATE pwc151.node
                         SET    left_pk = current_tuple.pk
                         WHERE  pk = parent_tuple.pk;
                      ELSE
                         RAISE DEBUG 'Right node [%] child of [%]', current_tuple.val, parent_tuple.val;
                        UPDATE pwc151.node
                        SET    right_pk = current_tuple.pk
                        WHERE  pk = parent_tuple.pk;
                      END IF;

                      UPDATE pwc151.node
                      SET    parent_pk = parent_tuple.pk
                      WHERE  pk = current_tuple.pk;

                      COMMIT;


                  END LOOP;
             END LOOP;

             lev := lev + 1;
        END LOOP;
END
$CODE$
LANGUAGE plpgsql;




WITH RECURSIVE min_depth AS
(
        -- root
        SELECT pk, val, level, 'root' as description, 1 as depth
        FROM pwc151.node
        WHERE level = 0
        AND parent_pk IS NULL

        UNION

        SELECT n.pk, n.val, n.level, description || '->' || n.val, p.depth + 1
        FROM  min_depth p, pwc151.node n
        WHERE n.level = p.level + 1
        AND   n.parent_pk = p.pk
)
SELECT description, depth
FROM min_depth
WHERE depth = ( SELECT min( depth ) FROM min_depth WHERE level > 0 );
