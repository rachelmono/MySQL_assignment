WITH
  cte1 AS (SELECT a, b FROM table1),
  cte2 AS (SELECT c, d FROM table2)
SELECT b, d FROM cte1 JOIN cte2
WHERE cte1.a = cte2.c;

WITH cte (col1, col2) AS
(
  SELECT 1, 2
  UNION ALL
  SELECT 3, 4
)
SELECT col1, col2 FROM cte;

WITH qn AS (SELECT a FROM t1)
SELECT * from qn;

WITH qn AS (SELECT a+2 AS a, b FROM t1)
UPDATE t1, qn SET t1.a=qn.a + 10 WHERE t1.a - qn.a = 0;

WITH qn(a, b) AS (SELECT a+2, b FROM t2)
DELETE t1 FROM t1, qn WHERE t1.a - qn.a = 0;

INSERT INTO t2
WITH qn AS (SELECT 10*a AS a FROM t1)
SELECT * from qn;

SELECT * FROM t1 WHERE t1.a IN
 (WITH cte as (SELECT * FROM t1 AS t2 LIMIT 1)
 SELECT a + 0 FROM cte);



WITH cte1(txt) AS (SELECT "This "),
 cte2(txt) AS (SELECT CONCAT(cte1.txt,"is a ") FROM cte1),
 cte3(txt) AS (SELECT "nice query" UNION
 SELECT "query that rocks" UNION
 SELECT "query"),
 cte4(txt) AS (SELECT concat(cte2.txt, cte3.txt) FROM cte2, cte3)
SELECT MAX(txt), MIN(txt) FROM cte4;


WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 10
)
SELECT * FROM cte;

WITH RECURSIVE cte AS
(
  SELECT 1 AS n, 'abc' AS str
  UNION ALL
  SELECT n + 1, CONCAT(str, str) FROM cte WHERE n < 3
)
SELECT * FROM cte;

WITH RECURSIVE cte AS
(
  SELECT 1 AS n, CAST('abc' AS CHAR(20)) AS str
  UNION ALL
  SELECT n + 1, CONCAT(str, str) FROM cte WHERE n < 3
)
SELECT * FROM cte;


WITH RECURSIVE cte AS
(
  SELECT 1 AS n, 1 AS p, -1 AS q
  UNION ALL
  SELECT n + 1, q * 2, p * 2 FROM cte WHERE n < 5
)
SELECT * FROM cte;



SET SESSION cte_max_recursion_depth = 10;      -- permit only shallow recursion
SET SESSION cte_max_recursion_depth = 1000000; -- permit deeper recursion
SET max_execution_time = 1000; -- impose one second timeout

WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte
)
SELECT /*+ MAX_EXECUTION_TIME(1000) */ * FROM cte;


WITH RECURSIVE my_cte(n) AS
(
  SELECT 1
  UNION ALL
  SELECT 1+n FROM my_cte WHERE n<6
)
UPDATE numbers, my_cte
# Change to 0...
SET numbers.n=0
# ... the numbers which are squares, i.e. 1 and 4
WHERE numbers.n=my_cte.n*my_cte.n;


WITH RECURSIVE my_cte(n) AS
(
  SELECT 1
  UNION ALL
  SELECT 1+n FROM my_cte WHERE n<6
)
DELETE FROM numbers
# delete the numbers greater than the average of 1,...,6 (=3.5)
WHERE numbers.n > (SELECT AVG(n) FROM my_cte);


DELETE FROM numbers 
WHERE numbers.n >
  (
    WITH RECURSIVE my_cte(n) AS
    (
      SELECT 1
      UNION ALL
      SELECT 1+n FROM my_cte WHERE n<6
    )
    # Half the average is 3.5/2=1.75
    SELECT AVG(n)/2 FROM my_cte
  );
  
-- http://mysqlserverteam.com/mysql-8-0-labs-recursive-common-table-expressions-in-mysql-ctes-part-two-how-to-generate-series/
-- Pair (N)th with (N+1)th to add them
SELECT 
    cte_n.f + cte_n_plus_1.f, cte.n + 2
FROM
    my_cte AS cte_n
        JOIN
    my_cte AS cte_n_plus_1 ON cte_n.n + 1 = cte_n_plus_1.n; #Pair (N)th with (N+1)th to add them

WITH RECURSIVE fibonacci (n, fib_n, next_fib_n) AS
(
  SELECT 1, 0, 1
  UNION ALL
  SELECT n + 1, next_fib_n, fib_n + next_fib_n
    FROM fibonacci WHERE n < 10
)
SELECT * FROM fibonacci;

WITH RECURSIVE
digits AS
(
  SELECT '0' AS d UNION ALL SELECT '1'
),
strings AS
(
  SELECT '' AS s
  UNION ALL
  SELECT CONCAT(strings.s, digits.d)
  FROM strings, digits
  WHERE LENGTH(strings.s) < 4
)
SELECT s FROM strings WHERE LENGTH(s)=4;

--  make column wider with a CAST and
WITH RECURSIVE
digits AS
(
  SELECT '0' AS d UNION ALL SELECT '1'
),
strings AS
(
  SELECT CAST('' AS CHAR(4)) AS s
  UNION ALL
  SELECT CONCAT(strings.s, digits.d)
  FROM strings, digits
  WHERE LENGTH(strings.s) < 4
)
SELECT * FROM strings WHERE LENGTH(s)=4;


-- Date Series Generation
SELECT 
    *
FROM
    sales
ORDER BY date , price;

SELECT 
    date, SUM(price) AS sum_price
FROM
    sales
GROUP BY date
ORDER BY date;


WITH RECURSIVE dates (date) AS
(
  SELECT '1983-01-01'
  UNION ALL
  SELECT date + INTERVAL 1 DAY FROM dates
  WHERE date + INTERVAL 1 DAY <= '1983-1-21'
)
SELECT * FROM dates;


SELECT orderdate,
 SUM(totalprice) sales
FROM orders
GROUP BY orderdate
ORDER BY orderdate;


WITH RECURSIVE dates (date) AS
(
  SELECT MIN(date) FROM sales
  UNION ALL
  SELECT date + INTERVAL 1 DAY FROM dates
  WHERE date + INTERVAL 1 DAY <= (SELECT MAX(date) FROM sales)
)

SELECT dates.date, COALESCE(SUM(price), 0) AS sum_price
FROM dates LEFT JOIN sales ON dates.date = sales.date
GROUP BY dates.date
ORDER BY dates.date;

