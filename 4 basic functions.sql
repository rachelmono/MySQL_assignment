-- https://dev.mysql.com/doc/refman/8.0/en/mathematical-functions.html

/*********************
 *   Date Function   *
 *********************/
 
-- Get current date
select curdate();

-- Get current timestamp
select current_time(); 

-- Get current timestamp
select current_timestamp(); 

-- Extract specific day/month/year of dates
select extract(day from curdate()) as day_now;
select day(curdate()) as day_now;


select extract(month from curdate()) as month_now;
select month(curdate()) as month_now;

select extract(year from curdate()) as year_now;
select year(curdate()) as year_now;

-- Adddate
select adddate(curdate(),interval 10 day);
select adddate('2017-01-01',interval 10 day);
select adddate('2017-01-01',interval 1 month);
select adddate('2017-01-01',interval 5 year);


-- Addtime
select addtime(current_timestamp(),'01:00:00');


-- Datediff
use fitbit_new;

select tran_id,status, arrive_date, eta, datediff(arrive_date,eta) as diff_eta
from shipping;

-- Get first day of this month
select adddate(curdate(), interval -day(curdate()-1) day) as first_day;


/*********************
 *  String Function  *
 *********************/

select *
from product;

-- Concat
select concat('String1','String2');
select concat('String1',' ','String2');

select code, name, concat(code,name) as code_name
from product;

-- Concat with random number
select code, name, concat(code,RAND()) as code_name
from product;

-- Left
select code, name, left(name,2)
from product;

-- right
select code, name, right(name,2)
from product;

-- Substring
select code, class, substring(class,2,6)
from product;

select code, class, substring(class,4,6)
from product;

-- lower case
select code, class, lower(class)
from product;

-- upper case
select code, name, upper(name)
from product;

-- Length
select code, name, length(name)
from product;

select name, class, concat(upper(left(class,1)), lower(substring(class,2,length(class))))
from product;

-- Trim
select '     Mytext    ';
select length( '     Mytext    ');

select ltrim( '     Mytext    ');
select rtrim( '     Mytext    ');

select ltrim(rtrim( '     Mytext    '));
select length(ltrim(rtrim( '     Mytext    ')));


use HR;

select * from employees;
select * from departments;

#some useful functions
select now();
select curdate();
select curtime();
select date('2012-12-12');

select hour(now());
select extract(year_month from now());

select date_add(curdate(),interval -3 month);
select date_sub(curdate(),interval 3 month);
select datediff('2017-01-03',now());

select date_format(now(),'%M %d %Y');
select period_add(extract(year_month from now()),-3);
select period_add(201801,-3);

select last_day(curdate());

select now();
select concat(curdate(),' ',curtime());

#1. Write a query to display the first day of the month (in datetime format) three months before the current month.
#1. 编写查询以显示本月份前三个月的月份里的第一天（日期时间格式）
#现在的日期 : 2014-09-03 
#期望的结果 : 2014-06-01
select date(((period_add(extract(year_month from curdate()),-3)*100)+1));
select date_sub(date_sub(curdate(),interval 3 month),interval day(curdate())-1 day);

#2. Write a query to display the last day of the month (in datetime format) three months before the current month
#2. 编写一个查询，以显示当前月份前三个月的最后一个天（日期时间格式）
SELECT (SUBDATE(ADDDATE(CURDATE(),INTERVAL -2 MONTH),INTERVAL DAYOFMONTH(CURDATE()) DAY))AS LastDayOfTheMonth;
select last_day(date_sub(curdate(),interval 3 month));
select date_add(last_day(curdate()),interval -3 month);


#3. Write a query to get the distinct Mondays from hire_date in employees tables
#3. 编写查询以从雇员表中的hire_date获取所有独立的的星期一
#NULL 0000-00-00
select distinct (str_to_date(concat(yearweek(hire_date),'1'),'%x%v%w')) from employees;
select distinct hire_date
from employees
where date_format(hire_date,'%a') = 'Mon';


#4. Write a query to get the first day of the current year.
#4. 写一个查询以获得今年的第一天
select makedate(extract(year from curdate()),1);
select makedate(year(curdate()),1);
select date_add(date_add(curdate(),interval -day(curdate())+1 day),interval -month(curdate())+1 month);
select str_to_date(concat('2018','0101'),'%Y%c%d');
select str_to_date(concat(year(curdate()),'0101'),'%Y%c%d');

#5. Write a query to get the last day of the current year.
#5. 写一个查询以获取当前年份的最后一天
select str_to_date(concat(12,31,extract(year from curdate())), '%m%d%Y');
select str_to_date(concat(year(curdate()),'1231'),'%Y%c%d');

#6. Write a query to calculate the age in year.
#6. 写一个查询来计算从采样日期到现在的年份
#采样日期: 1967-06-08
select year(current_timestamp) - year("1967-06-08") as age;
select year(curdate()) - year("1967-06-08");

#7. Write a query to get the current date in the following format. 
#Sample date : 2014-09-04
#Output : September 4, 2014
#7. 编写查询以获得以下格式的当前日期
#采样日期：2017-09-04
#期望的结果 : September 4, 2014
select date_format(curdate(), '%M %e, %Y') as 'Current_date';
select date_format(curdate(),'%M %e, %Y');

#8. Write a query to get the current date in the following format.
#Sample Output: Thursday September 2014
#8. 撰写查询以获取2014年9月星期四的当前日期格式
select date_format(now(),'%W %M %Y');

#9. Write a query to extract the year from the current date.
#9. 撰写查询以从当前日期提取年份
select extract(year from now());
select year(current_timestamp);

#10. Write a query to get the DATE value from a given day (number in N). 
#Sample days: 730677
#Output : 2000-07-11
#10. 写一个查询以从给定的日期获得DATE值（N中的数字）
#采样数字：730677
#结果：2000-07-11
select from_days(366);

#11. Write a query to get the first name and hire date from employees table where hire date between '1987-06-01' and '1987-07-30'
#11. 从员工表格当中的“1987-06-01”到“1987-07-30”之间查询并获取员工姓名和雇用日期
select first_name, hire_date 
from employees 
where hire_date between '1987-06-01 00:00:00' and '1987-07-30  23:59:59';


#12. Write a query to display the current date in the following format. 
#Sample output: Thursday 4th September 2014 00:00:00
#12. 编写查询以以下列格式显示当前日期
#采样日期：Thursday 4th September 2014 00:00:00
select date_format(curdate(), '%W %D %M %Y %T');
select date_format(now(),'%W %D %M %Y %H:%i:%s');

#Paramemter Values: https://www.w3schools.com/sql/func_mysql_date_format.asp

#13. Write a query to display the current date in the following format.
#Sample output: 05/09/2014
#13. 编写查询以以下列格式显示当前日期
#采样日期：05/09/2014
select date_format(curdate(),'%d/%m/%Y');

#14. Write a query to display the current date in the following format.
#Sample output: 12:00 AM Sep 5, 2014
#14. 编写查询以以下列格式显示当前日期
#采样结果：12:00 AM Sep 5, 2014
select date_format(now(), '%l:%i %p %b %e, %Y');
select date_format(now(),'%h:%i %P %b %e,%Y');

#15. Write a query to get the firstname, lastname who joined in the month of June. 
#15. 写一个查询以获得在6月份加入的名字，姓氏
select first_name, last_name 
from employees 
where month(hire_date) = 6;

#16. Write a query to get the years in which more than 10 employees joined.
#16. 写一个查询，以获得10多名员工加入的年份
select date_format(hire_date, '%Y') 
from employees 
group by date_format(hire_date, '%Y') 
having count(employee_id) > 10;

#17. Write a query to get first name of employees who joined in 1987. 
#17. 撰写查询以获取1987年加入的员工名字
select first_name from employees where year(hire_date) = 1987;

#18. Write a query to get department name, manager name, and salary of the manager for all managers whose experience is more than 5 years.
#18. 撰写查询，以获得经验超过5年的所有经理的部门名称，经理姓名和经理薪酬。
select department_name, first_name, salary 
from departments d 
join employees e using (manager_id) 
where (sysdate()-hire_date)/365 > 5;

select department_name, first_name, salary 
from departments d ,employees e
where (sysdate()-hire_date)/365 > 5 and e.manager_id = d.manager_id;

#19. Write a query to get employee ID, last name, and date of first salary of the employees. 
#19. 编写查询以获取员工的姓名，姓氏和员工的第一个工资日期
select employee_id, last_name, hire_date, LAST_DAY(hire_date) from employees;

#20. Write a query to get first name, hire date and experience of the employees.
#20. 写一个查询来获得名字，雇用员工的日期和工作时间长度
select first_name, hire_date, datediff(sysdate(), hire_date)/365 from employees;

#21. Write a query to get the department ID, year, and number of employees joined.
#21. 编写查询以获取部门ID，年份和员工人数
select department_id, year(hire_date), count(employee_id) 
from employees 
group by department_id;
#or
select department_id, date_format(hire_date, '%Y'), count(employee_id) 
from employees 
group by department_id;


# https://www.w3resource.com/mysql-exercises/date-time-exercises/
#helpful websites: https://www.w3schools.com/sql/func_mysql_date_format.asp