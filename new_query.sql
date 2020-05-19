SELECT 
    *
FROM
    employees
ORDER BY employee_id;

-- RETRIEVING A SINGLE PATH
SELECT 
    concat(e1.first_name," ",e1.last_name) AS lev1,
    concat(e2.first_name," ",e2.last_name) AS lev2,
    concat(e3.first_name," ",e3.last_name) AS lev3,
    concat(e4.first_name," ",e4.last_name) AS lev4
FROM
    employees AS e1
        LEFT JOIN
    employees AS e2 ON e2.manager_id = e1.employee_id
        LEFT JOIN
    employees AS e3 ON e3.manager_id = e2.employee_id
        LEFT JOIN
    employees AS e4 ON e4.manager_id = e3.employee_id
WHERE
    e1.manager_id = 0;
    
-- 需要终止递归的条件
-- 重复执行如下步骤，直到working table为空
WITH RECURSIVE employee_paths (employee_id, full_name, path_name, path) AS
(
  SELECT employee_id,
         concat(first_name," ",last_name) AS full_name,
         concat(first_name," ",last_name) AS path_name,
         CAST(employee_id AS CHAR(200))
  FROM employees
  WHERE manager_id = 0
  UNION ALL
  SELECT e.employee_id,
         CONCAT(e.first_name," ",e.last_name) AS full_name,
         CONCAT(ep.path_name," >> ",concat (e.first_name," ",e.last_name)),
         CONCAT(ep.path,' >> ',e.employee_id)
  FROM employee_paths AS ep
    JOIN employees AS e ON ep.employee_id = e.manager_id
)
SELECT *
FROM employee_paths
ORDER BY LENGTH(PATH),
         employee_id;

-- 可以使用递归 WITH RECURSIVE，从而实现其它方式无法实现或者不容易实现的查询
WITH RECURSIVE dates (date) AS
(
  SELECT '1983-01-01'
  UNION ALL
  SELECT date + INTERVAL 1 DAY FROM dates WHERE date + INTERVAL 1 DAY <= '1983-1-21'
)
SELECT * FROM dates;


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
