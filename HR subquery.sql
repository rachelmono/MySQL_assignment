CREATE DATABASE 20_Sub_Query;
USE 20_Sub_Query;

####################################################################################################################################

select * from employees;
select * from departments;
select * from jobs;
select * from locations;
#####################################################################################################################################

#1 Write a query to find the names (first_name, last_name) and the salaries of the employees who have a higher salary than the employee whose last_name='Bull'
SELECT DISTINCT
    SALARY, FIRST_NAME, LAST_NAME
FROM
    employees
WHERE
    SALARY > (SELECT DISTINCT
            SALARY
        FROM
            employees
        WHERE
            LAST_NAME = 'Bull');

#2 Write a query to find the names (first_name, last_name) of all employees who works in the IT department
SELECT 
    FIRST_NAME, LAST_NAME
FROM
    employees
WHERE
    DEPARTMENT_ID IN (SELECT 
            DEPARTMENT_ID
        FROM
            departments
        WHERE
            DEPARTMENT_NAME = 'IT');

#3 Write a query to find the names (first_name, last_name) of the employees who have a manager who work for a department based in the United States
SELECT 
    first_name, last_name
FROM
    employees
WHERE
    manager_id IN (SELECT 
            employee_id
        FROM
            employees
        WHERE
            department_id IN (SELECT 
                    department_id
                FROM
                    departments
                WHERE
                    location_id IN (SELECT 
                            location_id
                        FROM
                            locations
                        WHERE
                            country_id = 'US')));

#4. Write a query to find the names (first_name, last_name) of the employees who are managers.
SELECT 
    first_name, last_name
FROM
    employees
WHERE
    employee_id IN (SELECT 
            manager_id
        FROM
            employees);

#5. Write a query to find the names (first_name, last_name), the salary of the employees whose salary is greater than the average salary
SELECT 
    first_name, last_name, salary
FROM
    employees
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employees);

#6. Write a query to find the names (first_name, last_name), the salary of the employees whose salary is equal to the minimum salary for their job grade.
SELECT 
    first_name, last_name, salary
FROM
    employees
WHERE
    employees.salary = (SELECT 
            min_salary
        FROM
            jobs
        WHERE
            employees.job_id = jobs.job_id);

#7 Write a query to find the names (first_name, last_name), the salary of the employees who earn more than the average salary and who works in any of the IT departments
SELECT DISTINCT
    first_name, last_name, salary
FROM
    employees
WHERE
    department_id IN (SELECT 
            department_id
        FROM
            departments
        WHERE
            department_name LIKE 'IT%')
        AND salary > (SELECT 
            AVG(salary)
        FROM
            employees); 

#8. Write a query to find the names (first_name, last_name), the salary of the employees who earn more than Mr. Bell
SELECT DISTINCT
    salary, first_name, last_name
FROM
    employees
WHERE
    salary > (SELECT DISTINCT
            salary
        FROM
            employees
        WHERE
            last_name = 'Bell')
ORDER BY first_name;

#9. Write a query to find the names (first_name, last_name), the salary of the employees who earn the same salary as the minimum salary for all departments
SELECT DISTINCT
    FIRST_NAME, last_name, salary
FROM
    employees
WHERE
    salary = (SELECT 
            MIN(salary)
        FROM
            employees);

#10. Write a query to find the names (first_name, last_name), the salary of the employees whose salary greater than the average salary of all departments
SELECT department_id, AVG(salary)
        FROM
            employees
        GROUP BY department_id;
        
SELECT 
    first_name, last_name, salary
FROM
    employees
WHERE
    salary > ALL (SELECT 
            AVG(salary)
        FROM
            employees
        GROUP BY department_id);

#11. Write a query to find the names (first_name, last_name) and salary of the employees who earn a salary that is higher than the salary of all the Shipping Clerk (JOB_ID = 'SH_CLERK'). Sort the results of the salary of the lowest to highest
SELECT 
    EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM
    employees
WHERE
    SALARY > ALL (SELECT 
            salary
        FROM
            employees
        WHERE
            JOB_ID = 'SH_CLERK' AND JOB_ID = 'AD_VP')
ORDER BY SALARY;

#12. Write a query to find the names (first_name, last_name) of the employees who are not supervisors
SELECT 
    FIRST_NAME, LAST_NAME
FROM
    employees a
WHERE
    NOT EXISTS( SELECT 
            b.FIRST_NAME, b.LAST_NAME
        FROM
            employees b
        WHERE
            b.MANAGER_ID = a.EMPLOYEE_ID);

#13. Write a query to display the employee ID, first name, last names, and department names of all employees
SELECT 
    EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM
    employees
WHERE
    DEPARTMENT_ID IN (SELECT 
            DEPARTMENT_ID
        FROM
            departments);

#14. Write a query to display the employee ID, first name, last names, salary of all employees whose salary is above average for their departments
SELECT 
    EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM
    employees AS e
WHERE
    SALARY > (SELECT 
            AVG(SALARY)
        FROM
            employees
        WHERE
            DEPARTMENT_ID = e.DEPARTMENT_ID
        GROUP BY DEPARTMENT_ID);

#15. Write a query to find the 5th maximum salary in the employees table
SELECT DISTINCT
    t1.SALARY
FROM
    employees AS t1
WHERE
    5 = (SELECT 
            COUNT(DISTINCT salary)
        FROM
            employees AS t2
        WHERE
            t2.SALARY >= t1.SALARY);

SELECT DISTINCT
    t1.SALARY
FROM
    employees AS t1
WHERE
    4 = (SELECT 
            COUNT(DISTINCT salary)
        FROM
            employees AS t2
        WHERE
            t2.SALARY > t1.SALARY);

#16. Write a query to find the 4th minimum salary in the employees table
SELECT DISTINCT
    t1.SALARY
FROM
    employees AS t1
WHERE
    4 = (SELECT 
            COUNT(DISTINCT t2.SALARY)
        FROM
            employees AS t2
        WHERE
            t2.SALARY <= t1.SALARY);

#17. Write a query to select last 10 records from a table
SELECT 
    *
FROM
    employees
ORDER BY employee_id DESC
LIMIT 10;

#18. Write a query to list department number, name for all the departments in which there are no employees in the department
SELECT 
    d.DEPARTMENT_ID, d.DEPARTMENT_NAME
FROM
    departments AS d
WHERE
    d.DEPARTMENT_ID NOT IN (SELECT 
            e.DEPARTMENT_ID
        FROM
            employees AS e);

#19. Write a query to get 3 maximum salaries
SELECT DISTINCT
    t1.SALARY
FROM
    employees AS t1
WHERE
    3 >= (SELECT 
            COUNT(DISTINCT t2.SALARY)
        FROM
            employees AS t2
        WHERE
            t2.SALARY >= t1.SALARY)
ORDER BY t1.SALARY;

## or
SELECT DISTINCT
    salary
FROM
    employees
ORDER BY salary DESC
LIMIT 3;

#20. Write a query to get nth maximum salaries of employees
SELECT 
    *
FROM
    employees AS t1
WHERE
      (SELECT 
            COUNT(DISTINCT (t2.SALARY))
        FROM
            employees AS t2
        WHERE
            t2.SALARY > t1.SALARY) < 2;

