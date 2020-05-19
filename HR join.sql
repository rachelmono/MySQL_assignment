CREATE DATABASE HR;
USE HR;

CREATE TABLE IF NOT EXISTS employees (
    employee_id INT NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL,
    phone_number VARCHAR(45) NOT NULL,
    hire_date DATE,
    job_id VARCHAR(15) NOT NULL,
    salary INT NOT NULL,
    commission_pct DECIMAL(3 , 2 ) NOT NULL,
    manager_id INT NOT NULL,
    department_id INT NOT NULL
);

SELECT * FROM employees;

CREATE TABLE IF NOT EXISTS countries (
    country_id VARCHAR(2) NOT NULL,
    country_name VARCHAR(20) NOT NULL,
    region_id INT NOT NULL
);


SELECT * FROM countries;

CREATE TABLE IF NOT EXISTS departments (
    department_id INT NOT NULL,
    department_name VARCHAR(25) NOT NULL,
    manager_id INT NOT NULL,
    location_id INT NOT NULL
);


SELECT * FROM departments;
CREATE TABLE IF NOT EXISTS job_history (
    employee_id INT NOT NULL,
    start_date DATE,
    end_date DATE,
    job_id VARCHAR(15) NOT NULL,
    department_id INT NOT NULL
);

SELECT * FROM job_history;
CREATE TABLE IF NOT EXISTS locations (
    location_id INT NOT NULL,
    street_address VARCHAR(35) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    city VARCHAR(25) NOT NULL,
    state_province VARCHAR(25) NOT NULL,
    country_id VARCHAR(2) NOT NULL
);


SELECT * FROM locations;
CREATE TABLE IF NOT EXISTS jobs (
    job_id VARCHAR(10) NOT NULL,
    job_title VARCHAR(40) NOT NULL,
    min_salary INT NOT NULL,
    max_salary INT NOT NULL
);


SELECT * FROM departments, employees
where employees.department_id = departments.department_id;

########################################################################################################################################################
#1. 每个员工的全名和工作部门以及部门编码
SELECT 
    e.first_name,
    e.last_name,
    e.department_id,
    d.department_name
FROM
    departments AS d
        INNER JOIN
    employees AS e ON d.department_id = e.department_id;

SELECT 
    e.first_name,
    e.last_name,
    e.department_id,
    d.department_name
FROM
    departments AS d
        JOIN
    employees AS e ON d.department_id = e.department_id;

#2. 查询员工信息，包括，部门和工作地点信息
SELECT 
    e.first_name,
    e.last_name,
    d.department_id,
    l.city,
    l.state_province
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
        JOIN
    locations AS l ON d.location_id = l.location_id;


#3.基于员工工资分一下工资等级？ 
#------------ ---------- -----------
#A              1000        2999
#B              3000        5999
#C              6000        9999
#D             10000       14999
#E             15000       24999
#F             25000       40000

SELECT 
    first_name,
    last_name,
    salary,
    (CASE
        WHEN salary BETWEEN 1000 AND 2999 THEN '#A'
        WHEN salary BETWEEN 3000 AND 5999 THEN '#B'
        WHEN salary BETWEEN 6000 AND 9999 THEN '#C'
        WHEN salary BETWEEN 10000 AND 14999 THEN '#D'
        WHEN salary BETWEEN 15000 AND 24999 THEN '#E'
        WHEN salary BETWEEN 25000 AND 40000 THEN '#F'
        ELSE 'G+'
    END) AS job_grades
FROM
    employees;

#4. Write a query in SQL to display the first name, last name, department number and department name, for all employees for departments 80 or 40
-- 对于inner join
SELECT 
    e.first_name,
    e.last_name,
    d.department_id,
    d.department_name
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
        AND e.department_id IN (40 , 80)
ORDER BY e.last_name;

SELECT 
    e.first_name,
    e.last_name,
    d.department_id,
    d.department_name
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    e.department_id IN (40 , 80)
ORDER BY e.last_name;

-- 此处多了解一下left and join
SELECT 
    e.first_name,
    e.last_name,
    d.department_id,
    d.department_name
FROM
    employees AS e
	left JOIN
    departments AS d ON e.department_id = d.department_id
where  
    e.department_id IN (40 , 80)
ORDER BY e.last_name;

SELECT 
    e.first_name,
    e.last_name,
    d.department_id,
    d.department_name
FROM
    employees AS e
	left JOIN
    departments AS d ON e.department_id = d.department_id
and  
    e.department_id IN (40 , 80)
ORDER BY e.last_name;

#5. Write a query in SQL to display those employees who contain a letter z to their first name and also display their last name, department, city, and state province
SELECT 
    e.first_name,
    e.last_name,
    d.department_id,
    l.city,
    l.state_province
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
        JOIN
    locations AS l ON d.location_id = l.location_id
        AND e.first_name LIKE '%z%';

#6. Write a query in SQL to display all departments including those where does not have any employee
SELECT 
    d.department_id,  #e.department_id
    d.department_name,
    e.first_name,
    e.last_name
FROM
    employees AS e
        RIGHT JOIN
    departments AS d ON e.department_id = d.department_id;

#7. Write a query in SQL to display the first and last name and salary for those employees who earn less than the employee earn whose number is 182
SELECT 
    e.first_name, e.last_name, e.salary
FROM
    employees AS e
        JOIN
    employees AS s ON e.salary < s.salary AND s.employee_id = 182;
        

-- 比一个结果多呢？
select salary from employees where employee_id = 182;
        
select  first_name, last_name,salary  
from employees e
where e.salary < (select salary from employees where employee_id = 182);


SELECT 
    e.first_name, e.last_name, e.salary
FROM
    employees e
      left JOIN
    (SELECT 
        salary, employee_id
    FROM
        employees
    WHERE
        employee_id = 182) AS f_e on e.employee_id and f_e.employee_id
WHERE
    e.salary < f_e.salary;

#8. Write a query in SQL to display the first name of all employees including the first name of their manager
SELECT 
    e.first_name AS 'employee_name',
    s.first_name AS 'manager_name'
FROM
    employees AS e
        JOIN
    employees AS s ON e.manager_id = s.employee_id;

#9. Write a query in SQL to display the department name, city, and state province for each department
SELECT 
    d.department_name, l.city, l.state_province
FROM
    departments AS d
        JOIN
    locations AS l ON d.location_id = l.location_id;

#10. Write a query in SQL to display the first name, last name, department number and name, for all employees who have or have not any department
SELECT 
    e.first_name,
    e.last_name,
    d.department_id,
    d.department_name
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id;

SELECT 
    e.first_name,
    e.last_name,
    d.department_id,
    d.department_name
FROM
    employees AS e
        LEFT JOIN
    departments AS d ON e.department_id = d.department_id where d.department_id is null;

#11. Write a query in SQL to display the first name of all employees and the first name of their manager including those who does not working under any manager
SELECT 
    e.first_name AS 'employee_name',
    s.first_name AS 'manager_name'
FROM
    employees AS e
        LEFT JOIN
    employees AS s ON e.manager_id = s.employee_id;

#12. Write a query in SQL to display the first name, last name, and department number for those employees who works in the same department as the employee who holds the last name as Taylor
SELECT 
    e.first_name, e.last_name, e.department_id
FROM
    employees AS e
        JOIN
    employees AS s ON e.department_id = s.department_id
        AND e.last_name = 'Taylor';

#13. Write a query in SQL to display the job title, department name, full name (first and last name ) of employee, and starting date for all the jobs which started on or after 1st January, 1993 and ending with on or before 31 August, 1997
SELECT DISTINCT
    job_title,
    department_name,
    first_name,
    last_name,
    start_date
FROM
    job_history
        JOIN
    jobs USING (job_id)
        JOIN
    departments USING (department_id)
        JOIN
    employees USING (employee_id)
WHERE
    start_date >= '1993-01-01'
        AND start_date <= '1997-08-31'; 

#14. Write a query in SQL to display job title, full name (first and last name ) of employee, and the difference between maximum salary for the job and salary of the employee
SELECT 
    job_title,
    first_name || ' ' || last_name AS employee_name,
    max_salary - salary AS salary_difference
FROM
    employees
        JOIN
    jobs ON employees.job_id = jobs.job_id;

#15. Write a query in SQL to display the name of the department, average salary and number of employees working in that department who got commission
SELECT 
    department_name, AVG(salary), COUNT(employee_id)
FROM
    departments
        JOIN
    employees USING (department_id)
WHERE
    commission_pct != 0
GROUP BY department_name;

SELECT 
    department_name, AVG(salary), COUNT(commission_pct)
FROM
    departments
        JOIN
    employees USING (department_id)
GROUP BY department_name;

#16. Write a query in SQL to display the full name (first and last name ) of employee, and job title of those employees who is working in the department which ID 80 and deserve a commission percentage
SELECT 
    first_name, last_name, job_title
FROM
    employees
        JOIN
    jobs USING (job_id)
WHERE
    department_id = 80
        AND commission_pct != 0;

#17. Write a query in SQL to display the name of the country, city, and the departments which are running there
SELECT 
    country_name, city, department_name
FROM
    countries
        JOIN
    locations USING (country_id)
        JOIN
    departments USING (location_id);

#18. Write a query in SQL to display department name and the full name (first and last name) of the manager
SELECT 
    department_name, first_name, last_name
FROM
    departments
        JOIN
    employees USING (department_id)
WHERE
    employees.employee_id = departments.manager_id;

#19. Write a query in SQL to display job title and average salary of employees
SELECT 
    job_title, AVG(salary)
FROM
    employees
        NATURAL JOIN
    jobs
GROUP BY job_title;

#20. Write a query in SQL to display the details of jobs which was done by any of the employees who is presently earning a salary on and above 12000
SELECT 
    jh.*
FROM
    job_history AS jh
        JOIN
    employees AS e ON jh.employee_id = e.employee_id
WHERE
    salary >= 12000;

#21. Write a query in SQL to display the country name, city, and number of those departments where at leaste 2 employees are working
SELECT 
    country_name, city, COUNT(department_id)
FROM
    countries
        JOIN
    locations USING (country_id)
        JOIN
    departments USING (location_id)
WHERE
    department_id IN (SELECT 
            department_id
        FROM
            employees
        GROUP BY department_id
        HAVING COUNT(employee_id) >= 2)
GROUP BY country_name , city;

SELECT 
    country_name, city, COUNT(department_id)
FROM
    (SELECT 
        country_name, city, department_id
    FROM
        countries
    INNER JOIN locations USING (country_id)
    INNER JOIN departments USING (location_id)
    INNER JOIN employees USING (department_id)
    GROUP BY country_name , city , department_id
    HAVING COUNT(employee_id) >= 2) AS a
GROUP BY country_name , city;


#22. Write a query in SQL to display the department name, full name (first and last name) of manager, and their city
SELECT 
    department_name, first_name, last_name, city
FROM
    employees
        JOIN
    departments USING (department_id)
        JOIN
    locations USING (location_id)
WHERE
    departments.manager_id = employees.employee_id;

#23. Write a query in SQL to display the employee ID, job name, number of days worked in for all those jobs in department 80
SELECT 
    employee_id, job_title, end_date - start_date DAYS
FROM
    job_history
        NATURAL JOIN
    jobs
WHERE
    department_id = 80;

#24. Write a query in SQL to display the full name (first and last name), and salary of those employees who working in any department located in London
SELECT 
    e.first_name, e.last_name, e.salary, l.city
FROM
    employees AS e
        JOIN
    departments AS d USING (department_id)
        JOIN
    locations AS l USING (location_id)
WHERE
    l.city = 'London';


SELECT 
    CONCAT(e.first_name, '', e.last_name) AS fullName, e.salary
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
        JOIN
    locations l ON d.location_id = l.location_id
WHERE
    l.city = 'London';

#25. Write a query in SQL to display full name(first and last name), job title, starting and ending date of last jobs for those employees with worked without a commission percentage
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS employee_name,
    job_title,
    start_date,
    end_date
FROM
    job_history AS a
        JOIN
    jobs AS b USING (job_id)
        JOIN
    employees AS c ON (a.employee_id = c.employee_id)
WHERE
    commission_pct = 0;



#26. Write a query in SQL to display the department name and number of employees in each of the department
SELECT 
    d.department_name, COUNT(*) AS 'employees_count'
FROM
    departments d
        INNER JOIN
    employees e ON e.department_id = d.department_id
GROUP BY d.department_name;

SELECT 
    first_name, last_name, employee_id, country_name
FROM
    employees
        JOIN
    departments USING (department_id)
        JOIN
    locations USING (location_id)
        JOIN
    countries USING (country_id);