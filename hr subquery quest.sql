#1 Write a query to find the names (first_name, last_name) 
#and the salaries of the employees who have a higher salary than the employee whose last_name='Bull'
#1 写一个查询来查找所有比姓氏为'Bull'员工的薪资搞得员工的名字（first_name，last_name）和雇员薪资
use hr;
select concat(first_name, last_name), salary
 from employees
 where salary> 
 (select salary from employees where last_name="Bull");



select department_name from departments;
#2 Write a query to find the names (first_name, last_name) of all employees who works in the IT department
#2 编写查询以查找在IT部门工作的所有员工的名称（名，姓）
select  concat(first_name, last_name) from employees
where department_id =(select department_id from departments where department_name="IT");




#3 Write a query to find the names (first_name, last_name) of the employees who have a manager and work for a department based in the United States
#3 编写查询以查找在美国拥有经理和部门工作的员工的姓名

#4. Write a query to find the names (first_name, last_name) of the employees who are managers.
#4. 编写查询以查找作为管理员的员工的姓名

#5. Write a query to find the names (first_name, last_name), the salary of the employees whose salary is greater than the average salary
#5. 写一个查询来查找名字（名，姓），薪水大于平均工资的雇员的工资

#6. Write a query to find the names (first_name, last_name), the salary of the employees whose salary is equal to the minimum salary for their job grade.
#6. 写一个查询来查找名字（名，姓），其工资等于其工作职等的最低工资的员工的工资

#7 Write a query to find the names (first_name, last_name), the salary of the employees who earn more than the average salary and who works in any of the IT departments
#7 编写一个查询来查找名称（名，姓），雇员的工资高于平均工资，以及在任何IT部门工作的员工

#8. Write a query to find the names (first_name, last_name), the salary of the employees who earn more than Mr. Bell
#8 写一个查询来查找名字（名，姓），赚取超过贝尔先生的员工的工资


#9. Write a query to find the names (first_name, last_name), the salary of the employees who earn the same salary as the minimum salary for all departments
#9 写一个查询来查找与所有部门的最低工资相同的员工的名字(名，姓)


#10. Write a query to find the names (first_name, last_name), the salary of the employees whose salary greater than the average salary of all departments
#10. 写一个查询来查找出比所有部门平均工资高的员工的名字(名，姓)


#11. Write a query to find the names (first_name, last_name) and salary of the employees who earn a salary that is higher than the salary of all the Shipping Clerk (JOB_ID = 'SH_CLERK'). Sort the results of the salary of the lowest to highest
#11. 撰写查询以查找获得高于所有运输文员（JOB_ID ='SH_CLERK'）工资的员工的姓名（first_name，last_name）和工资。将工资的结果从最低到最高

#12. Write a query to find the names (first_name, last_name) of the employees who are not supervisors
#12. 编写查询以查找所有没有主管的员工的名称

#13. Write a query to display the employee ID, first name, last names of all employees
#13. 编写查询以显示所有员工的员工ID，名字，姓氏

#14. Write a query to display the employee ID, first name, last names, salary of all employees whose salary is above average for their departments
#14. 编写查询以显示其部门工资高于平均水平的所有员工的员工ID，名字，姓氏，工资

#15. Write a query to find the 5th maximum salary in the employees table
#15. 编写查询以查找employees表中的第五最高工资

#16. Write a query to find the 4th minimum salary in the employees table
#16. 编写查询以查找employees表中的第4个最低工资

#17. Write a query to select last 10 records from a table
#17. 编写一个查询以从表中选择最后10条记录

#18. Write a query to list department number, name for all the departments in which there are no employees in the department
#18. 编写查询列出部门编号，部门内没有员工的所有部门的名称
select d.department_id, d.department_name from departments d left join employees e on 
e.department_id=d.department_id where e.employee_id is null;
#19. Write a query to get 3 maximum salaries
#19. 写一个查询以获得3个最高工资
use hr;
select salary from employees 
order by salary desc
limit 3;

#20. Write a query to get nth maximum salaries of employees
#20. 写一个查询来获得员工的第n个最高工资
