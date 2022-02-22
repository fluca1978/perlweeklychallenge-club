/*
testdb=> \i ch-1.sql
num | left_factorial
-----+----------------
1 |              1
2 |              2
3 |              4
4 |             10
5 |             34
6 |            154
7 |            874
8 |           5914
9 |          46234
10 |         409114
(10 rows)

*/
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
SELECT f.num, sum( w.fac ) as left_factorial
FROM factorials f, LATERAL
( SELECT ff.fac FROM factorials ff WHERE ff.num < f.num ORDER BY ff.num ) w
WHERE f.num <= 10
GROUP BY f.num, f.fac
ORDER BY f.num
;
