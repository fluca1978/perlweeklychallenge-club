CREATE SCHEMA IF NOT EXISTS pwc151;

CREATE TABLE IF NOT EXISTS pwc151.houses(
       pk int generated always as identity
       , index int
       , value int
       , PRIMARY KEY( pk )
);


TRUNCATE pwc151.houses;
INSERT INTO pwc151.houses( index, value )
VALUES ( 0, 4), ( 1, 2 ), (2, 3), (4, 6), (5,5),(6,3);


CREATE OR REPLACE FUNCTION
pwc151.f_sum()
RETURNS int
AS $CODE$
DECLARE
        current_row pwc151.houses%rowtype;
        s int := 0;
        max_index int;
BEGIN
        -- bootstrap
        SELECT *
        INTO current_row
        FROM pwc151.houses
        ORDER BY index
        LIMIT 1;

        s := s + current_row.value;


        SELECT max( index )
        INTO max_index
        FROM pwc151.houses;

        WHILE current_row.index < max_index LOOP
              SELECT *
              INTO current_row
              FROM pwc151.houses
              WHERE index > current_row.index + 1
              ORDER BY value DESC
              LIMIT 1;

              s := s + current_row.value;

        END LOOP;

        RETURN s;
END
$CODE$
LANGUAGE plpgsql;
