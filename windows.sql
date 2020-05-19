-- this means default to aggregating the window function 
-- over all rows in the result set, 
-- so as for the grouped aggregate, 
-- we get the value 10 returned from the window function calls
CREATE TABLE t(i INT);
INSERT INTO t VALUES (1),(2),(3),(4);
select (4) from t;
SELECT SUM(i) AS sum FROM t;
select "sum" from t;
select "a" from t;
SELECT i, SUM(i) OVER () AS sum FROM t;
SELECT i, (SELECT SUM(i) FROM t) FROM t;
SELECT SUM(i) FROM t;


SELECT * FROM simple_sales ORDER BY country, year, product;
use hr;
select country, sum(profit) as sum_profit from simple_sales
group by country;

SELECT country, SUM(profit) AS country_profit
       FROM simple_sales
       GROUP BY country
       ORDER BY country;
       
       
select country, product, profit,
sum(profit) over (partition by country) as sum_profit
from simple_sales
order by country;

       
SELECT
       year, country, product, profit,
       SUM(profit) OVER() AS total_profit,
       SUM(profit) OVER(PARTITION BY country rows unbounded preceding) AS country_profit
       FROM simple_sales
       ORDER BY country, year, product, profit;
       
       
       
       
       
       
select country, product, profit,
row_number() over(partition by country) as row_profit
from simple_sales;       

SELECT
         year, country, product, profit,
         ROW_NUMBER() OVER(PARTITION BY country) AS row_num1,
         ROW_NUMBER() OVER(PARTITION BY country ORDER BY year, product) AS row_num2
       FROM simple_sales;
       
-- 当前被评估的行，当前行
-- 与当前行向关联的
select * from employees order by salary;

SELECT 
    SUM(salary)
FROM
    employees;

-- over() vs cross join
SELECT 
    CONCAT(e.first_name, ' ', e.last_name), e.salary, summary.total
FROM
    employees e,
    (SELECT 
        SUM(salary) total
    FROM
        employees) summary;
select employee_id, concat(first_name," ",last_name), salary,
sum(salary) over(partition by employee_id) as total_salary from employees;

SELECT 
    employee_id, CONCAT(first_name, ' ', last_name), salary, 
    avg(salary) OVER (partition by employee_id) as avg_salary,
    SUM(salary) OVER (partition by employee_id) as sum_salary    
FROM 
    employees
    order by avg_salary;


select
    row_number() over() as rnum,
    CONCAT(first_name, ' ', last_name),
    salary
from employees
order by salary desc;

select
    employee_id,
    row_number() over(order by salary desc) as row_num,
    CONCAT(first_name, ' ', last_name),
    salary
from employees;

select
    employee_id,
    row_number() over(order by first_name desc) as row_num,
    CONCAT(first_name, ' ', last_name),
    salary
from employees;

SELECT 
    CONCAT(first_name, ' ', last_name), salary, 
    avg(salary) OVER (partition by department_id) as department_avg_salary,
    avg(salary) OVER () as avg_salary,
    SUM(salary) OVER () as sum_salary    
FROM 
    employees;

-- ROW_NUMBER(),RANK(),DENSE_RANK()
SELECT 
    CONCAT(e.first_name, ' ', e.last_name), e.salary,
    d.department_id,d.department_name
FROM
    employees e
        LEFT JOIN
    departments d USING (department_id);

SELECT 
    CONCAT(e.first_name, ' ', e.last_name), e.salary,
    row_number() over(partition by e.department_id order by e.salary desc) as rnum,
    d.department_id,d.department_name
FROM
    employees e
        LEFT JOIN
    departments d USING (department_id);

-- department shipping
SELECT 
    CONCAT(e.first_name, ' ', e.last_name), e.salary,
    row_number() over w as row_num,
    RANK() over w as rank_num,
    DENSE_RANK() over w as dense_rank_num,
    d.department_id,d.department_name
FROM
    employees e
        LEFT JOIN
    departments d USING (department_id)
WINDOW w AS (partition by e.department_id order by e.salary desc);


-- PERCENT_RANK(),CUME_DIST(),NTILE() 
-- PERCENT_RANK (currnet_rank-1)/rows-1
-- CUME_DIST (number of rows preceding )/ rows

-- shipping 1-45   
SELECT 
    CONCAT(e.first_name, ' ', e.last_name), e.salary,
    row_number() over w as row_num,
    RANK() over w as rank_num,
    PERCENT_RANK() over w as per_rank_num,
    CUME_DIST() over w as cume_num,
    NTILE(5) over w as cume_num,
    d.department_id,d.department_name
FROM
    employees e
        LEFT JOIN
    departments d USING (department_id)
WINDOW w AS (partition by e.department_id order by e.salary desc);

-- ntile()数据分组,NTILE()的功能是进行"均分"分组
SELECT 
    CONCAT(e.first_name, ' ', e.last_name), e.salary,
    row_number() over w as row_num,
    d.department_id,d.department_name,
    NTILE(5) over w as ntile_num,
    (CASE NTILE(5) over w
        when 1 then 'top'
        when 2 then 'medium'
        when 3 then 'low'
        ELSE 'well...'
    END) as saleary_group
FROM
    employees e
        LEFT JOIN
    departments d USING (department_id)
WINDOW w AS (partition by e.department_id order by e.salary desc);

/*
执行顺序
WHERE
GROUP BY
HAVING
OVER
ORDER BY
LIMIT
*/
SELECT 
    SUM(salary) as sum_salary
FROM 
    employees limit 3;

SELECT 
    sum(salary)
FROM
    employees
WHERE
    employee_id IN (100 , 101, 102);



-- precedes 
-- current_row 
-- following




/**************
 *  lag/lead  *
 **************/ 

-- lag
select symbol, date, price, lag(price,1)  over (partition by symbol order by date) as last_price from ts;

-- price change% from previous closing
select *, concat((price - last_price)/last_price*100,'%') as price_change_pct from
(select symbol, date, price, lag(price,1)  over (partition by symbol order by date) as last_price from ts) w;

-- lead
select symbol, date, price, lead(price,1)  over (partition by symbol order by date) as lead_price from ts;
-- price change% compared to next closing
select *, concat((next_price - price)/price*100,'%') as price_change_pct from
(select symbol, date, price, lead(price,1)  over (partition by symbol order by date) as next_price from ts) w;
-- 同一次查询中取出同一字段的前N行的数据(lag)和后N行的数据(lead)
-- LAG(expr [, N[, default]]) [null_treatment] over_clause
-- Returns the value of expr from the row that lags (precedes) the current row by N rows
-- within its partition. If there is no such row, the return value is default

-- LEAD() 
-- following query shows
select
    row_number() over() as row_num,
    employee_id,
    CONCAT(first_name, ' ', last_name),
    LAG(salary, 1,0) OVER() AS 'lag_salary',
    salary,
    LEAD(salary, 1,0) OVER() AS 'lead_salary'
from employees;


select
    row_number() over() as row_num,
    employee_id,
    CONCAT(first_name, ' ', last_name),
    FIRST_VALUE(salary)  OVER() AS 'first',
    LAST_VALUE(salary)   OVER() AS 'last',
    NTH_VALUE(salary, 2) OVER() AS 'second',
    NTH_VALUE(salary, 4) OVER() AS 'fourth',    
    LAG(salary, 1,0) OVER() AS 'lag_salary',
    salary,
    LEAD(salary, 1,0) OVER() AS 'lead_salary'
from employees;


/*
window_function_name(expression)
    OVER (
        [partition_defintion]
        [order_definition] ********
        [frame_definition]
    )
-- default partition
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW    
-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
*/
-- Movable window frames
select
    row_number() over w row_num,
    employee_id,
    CONCAT(first_name, ' ', last_name),
    FIRST_VALUE(salary)  OVER w AS 'first',
    LAST_VALUE(salary)   OVER w AS 'last',
    NTH_VALUE(salary, 2) OVER w AS 'second',
    NTH_VALUE(salary, 4) OVER w AS 'fourth',    
    LAG(salary, 1,0) OVER w AS 'lag_salary',
    salary,
    LEAD(salary, 1,0) OVER w AS 'lead_salary'
from employees
WINDOW w AS (order by salary desc);


/***************************************
 * windonw function with time series   *
 ***************************************/
drop table if exists ts;

create temporary table ts (
date   date,
symbol varchar(20),
price  decimal, 
volume int 
);

insert into ts values 
('2018-01-01','AAPL','10.00', 100),
('2018-01-01','AMZN','200.00',100),
('2018-01-02','AAPL','20.00',100),
('2018-01-02','AMZN','201.00',100),
('2018-01-03','AAPL','15.00',100),
('2018-01-03','AMZN','202.00',100),
('2018-01-04','AAPL','25.00',100),
('2018-01-04','AMZN','203.00',100),
('2018-01-05','AAPL','15.00',100),
('2018-01-05','AMZN','204.00',100),
('2018-01-08','AAPL','25.00',100),
('2018-01-08','AMZN','207.00',100),
('2018-01-09','AAPL','40.00',100),
('2018-01-09','AMZN','208.00',100),
('2018-01-10','AAPL','45.00',100),
('2018-01-10','AMZN','209.00',100),
('2018-02-01','AAPL','50.00',100),
('2018-02-01','AMZN','210.00',100),
('2018-03-01','AAPL','100.00',100),
('2018-03-01','AMZN','211.00',100);

select * from ts order by symbol, date;


-- Moving average price of each stock from the begining of history;
select symbol, date, price, avg(price) over (partition by symbol order by date rows unbounded preceding) as price_ma from ts;
 
-- Moving sum volume of each stock from the begining of history;
select symbol, date, volume, sum(volume) over (partition by symbol rows unbounded preceding) as volume_ms from ts;


-- 1 week (trailing) moving average price of each stock;
SELECT 
    symbol, date, price
FROM
    ts
ORDER BY symbol , date;

SELECT 
    symbol,
    avg(case when `date` between '2018-01-01' and '2018-01-31' then price end)  as jan_price,
    avg(case when `date` between '2018-02-01' and '2018-02-31' then price end)  as feb_price,
    avg(case when `date` between '2018-03-01' and '2018-03-31' then price end)  as march_price
FROM
    ts
group by symbol 
ORDER BY symbol;


select symbol, date, price, avg(price) over (partition by symbol order by date range between interval 6 day preceding and current row) as price_ma_7d from ts;
select symbol, date, price, avg(price) over (partition by symbol order by date range between interval 1 week preceding and current row) as price_ma_1w from ts;
select symbol, date, price, avg(price) over (partition by symbol order by date range between interval 1 month preceding and current row) as price_ma_1m from ts;

-- centered weekly moving average;
select symbol, date, price, avg(price) over (partition by symbol order by date range between interval 3 day preceding and interval 3 day following) as price_cma_7d from ts;

-- range vs row
select symbol, date, price, avg(price) over (partition by symbol order by date rows between 6 preceding and current row) as price_ma_7r from ts;
select symbol, date, price, avg(price) over (partition by symbol order by date rows between 3 preceding and 3 following) as price_cma_7r from ts;
 


-- 偏移
-- 从分区开始到当前行
-- 从当前行到后续位置

-- physical (ROWS) and logical (RANGE)  boundaries
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- ROWS | RANGE , beginning and ending row positions
-- RANGE, rows within a value range

/*
    CURRENT ROW
    UNBOUNDED PRECEDING
    UNBOUNDED FOLLOWING
    expr PRECEDING
    expr FOLLOWING
*/
SELECT 
    employee_id, 
    CONCAT(first_name, ' ', last_name), 
    salary,
    row_number() over w as row_num,
    count(*) over w as count_num,
    RANK() over w as rank_num,
    sum(salary) over w as sum_salary
FROM
    employees
WHERE
    employee_id IN (100,101,102,103,104,105,106)
WINDOW w AS (order by salary desc);


SELECT 
    CONCAT(first_name, ' ', last_name), 
    salary
FROM
    employees
WHERE
   employee_id in (100,101,102,103,104,105,106); 

   

-- rows vs range
-- rows
-- expr rows after the current row
-- 10 PRECEDING
-- 5 FOLLOWING
--
-- range , 要求 order by 可以进行计算的
-- rows with values equal to the current row value plus expr;
-- INTERVAL 5 DAY PRECEDING
-- INTERVAL '2:30' MINUTE_SECOND FOLLOWING
SELECT 
    employee_id, 
    CONCAT(first_name, ' ', last_name), 
    salary,
    row_number() over w as row_num,
    count(*) over w as count_num,
    RANK() over w as rank_num,
    sum(salary) over w as sum_salary
FROM
    employees
WHERE
    employee_id IN (100,101,102,103,104,105,106)
WINDOW w AS (order by salary desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);

-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW   
-- order by employee_id,salary desc RANGE BETWEEN 3 PRECEDING AND CURRENT ROW
-- 
show warnings;
SELECT 
    CONCAT(e.first_name, ' ', e.last_name), e.salary,
    row_number() over w1 as row_num,
    rank() over w1 as rank_num,
    rank() over w2 as rank2_num,
    d.department_id,d.department_name,
    NTILE(5) over w1 as ntile_num,
    (CASE NTILE(5) over w1
        when 1 then 'top'
        when 2 then 'medium'
        when 3 then 'low'
        ELSE 'well...'
    END) as saleary_group
FROM
    employees e
        LEFT JOIN
    departments d USING (department_id)
WINDOW w1 AS (partition by e.department_id), 
w2 as (w1 order by e.salary desc);

-- 基于月份统计
-- 大于每一和平均的相差 
-- 累计到当前的销售， year
-- 