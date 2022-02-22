/*
testdb=> \i ch-2.sql
factorions
------------
145 OK
(1 row)
*/

\set needle 145

with recursive factorials as
(
   SELECT 0::numeric as num
         ,1::numeric as fac

   UNION

   SELECT f.num + 1
         , ( f.num + 1 ) * f.fac
   FROM factorials f
   WHERE f.num < 1000
)
SELECT CASE sum( f.fac ) WHEN :needle THEN :needle || ' OK' ELSE :needle || ' KO' END AS factorions
FROM factorials f JOIN regexp_split_to_table( :needle::text, '' ) w(n)
ON w.n = f.num::text
;
;
