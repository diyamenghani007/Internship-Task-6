create database task6;
use task6;
create table Departments (
    id int primary key,
    name text
);
create table Employees (
    id int primary key,
    name text,
    dept_id int,
    salary int,
    hire_date date,
    foreign key (dept_id) references Departments(id)
);
create table Projects (
    id int primary key,
    name text,
    budget int,
    dept_id int,
    foreign key (dept_id) references Departments(id)
);
create table EmployeeProjects (
    emp_id int,
    project_id int,
    foreign key (emp_id) references Employees(id),
    foreign key (project_id) references Projects(id)
);

insert into Departments values (101, 'Engineering'), (102, 'HR'), (103, 'Marketing');
select * from EmployeeProjects;

insert into Employees values
(1, 'Diya', 101, 60000, '2021-01-15'),
(2, 'Rashmi', 102, 75000, '2020-07-20'),
(3, 'Annanya', 101, 50000, '2022-05-10'),
(4, 'Aashna', 103, 90000, '2019-03-01'),
(5, 'Suhani', 102, 45000, '2023-02-28'),
(6, 'Anupama', 101, 85000, '2020-11-12');

insert into Projects values
(201, 'Website Revamp', 150000, 101),
(202, 'HR Audit', 80000, 102),
(203, 'Brand Campaign', 120000, 103),
(204, 'App Dev', 200000, 101);

insert into EmployeeProjects values
(1, 201),
(1, 204),
(2, 202),
(3, 204),
(4, 203),
(5, 202),
(6, 201),
(6, 204);

#query 1
select name, salary from Employees
where salary > (select avg(salary) from Employees);

#query 2 
select name as Dept_Name from Departments 
where id in ( select dept_id from Projects where budget > 100000 );

select * from Employees;
select * from EmployeeProjects;
#query 3
select name as Emp_Name from Employees where id not in(select emp_id from EmployeeProjects);

#query 4
select * from employees where dept_id = (select dept_id from Employees e1 where name = "Diya") and name != "Diya";

#query 5
select name from Departments d where not exists ( select * from Employees e where e.dept_id = d.id );

#query 6
select name from Employees e where (select count(*) from EmployeeProjects ep where ep.emp_id = e.id );

#query 7
select name, dept_id, salary from Employees e1 where salary = 
( select max(salary) from Employees e2 where e1.dept_id = e2.dept_id);

#query 8
select d.name, avg_salaries.avg_salary from Departments d join (
  select dept_id, avg(salary) as avg_salary from Employees group by dept_id ) 
  as avg_salaries on d.id = avg_salaries.dept_id
where avg_salaries.avg_salary > 65000;

#query 9
select name from Projects p where not exists 
( select * from EmployeeProjects ep join Employees e on ep.emp_id = e.id
  where ep.project_id = p.id and e.dept_id != 101 );
  
#query 10
select name from Departments where id in 
( select dept_id from Employees group by dept_id having count(*) > 2 );

#query 11
select distinct name from Employees where id in 
( select emp_id FROM EmployeeProjects where project_id in 
( select project_id from EmployeeProjects where emp_id = (select id from Employees where name = 'Diya') )
) and name != 'Diya';

#query 12
select name,
       (select count(*) from EmployeeProjects ep where ep.emp_id = e.id) 
       as project_count from Employees e;

#query 13
select name from Projects p
where not exists ( select * from EmployeeProjects ep where ep.project_id = p.id );

#query 14
select name, salary from Employees e
where salary > ( select avg(salary) from Employees where dept_id = e.dept_id );

#query 15
select name, salary from Employees where salary > (
  select max(salary) from Employees where dept_id = (
    select id from Departments where name = 'HR' ) );
