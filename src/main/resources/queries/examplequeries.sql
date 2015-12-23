--Query 1. Retrieve the name and address of all employees who work for the
--‘Research’ department.

select fname, lname, address from employee where dno=5
select fname, lname, address from employee, department where dname='Research' and dno=dnumber

--Query 2. For every project located in ‘Stafford’, list the project number, the
--controlling department number, and the department manager’s last name,
--address, and birth date.

select pnumber, dnumber, lname, address, bdate from project, department, employee where plocation='Stafford' and dnum = dnumber and mgr_ssn = ssn

select E.fname as emp, S.fname as sup from employee S, employee E where E.ssn = S.super_ssn

select all salary from employee

select distinct salary from employee

--Query 4. Make a list of all project numbers for projects that involve an
--employee whose last name is ‘Smith’, either as a worker or as a manager of the
--department that controls the project.

(select distinct pnumber from project, employee, works_on where ssn = essn and lname = 'Smith' and pnumber=pno)
union
(select distinct pnumber from project, department, employee where ssn = mgr_ssn and lname = 'Smith' and dno=dnumber)

-- using nested queries
select distinct pnumber 
from project 
where pnumber in 
  (select pnumber 
  from project, department, employee
  where dnum = dnumber and ssn = mgr_ssn and lname='Smith')
  or
  pnumber in
  (select pno
  from employee, works_on
  where ssn=essn and lname='Smith')
  
--Query 12. Retrieve all employees whose address is in Houston, Texas.
select fname, lname from employee where address like '%ouston, T%'

--Query 12A. Find all employees who were born during the 1950s.
select fname from employee where bdate like '_______5_'

--Query 13. Show the resulting salaries if every employee working on the
--‘ProductX’ project is given a 10 percent raise.

SELECT
E.Fname, E.Lname, 1.1 * E.Salary AS Increasedsal
FROM
EMPLOYEE E, WORKS_ON W, PROJECT P
WHERE
E.Ssn=W.Essn AND W.Pno=P.Pnumber AND
P.Pname='ProductX'

--Query 14. Retrieve all employees in department 5 whose salary is between
--$30,000 and $40,000.
SELECT *
FROM employee
WHERE
(Salary BETWEEN 30000 AND 40000) AND Dno = 5;

--Query 15. Retrieve a list of employees and the projects they are working on,
--ordered by department and, within each department, ordered alphabetically by
--last name, then first name.
SELECT
D.Dname, E.Lname, E.Fname, P.Pname
FROM
DEPARTMENT D, EMPLOYEE E, WORKS_ON W,
PROJECT P where
D.Dnumber= E.Dno AND E.Ssn= W.Essn AND
W.Pno= P.Pnumber
ORDER BY D.Dname, E.Lname, E.Fname;

--asc desc
SELECT
D.Dname, E.Lname, E.Fname, P.Pname
FROM
DEPARTMENT D, EMPLOYEE E, WORKS_ON W,
PROJECT P where
D.Dnumber= E.Dno AND E.Ssn= W.Essn AND
W.Pno= P.Pnumber
ORDER BY D.Dname asc, E.Lname desc, E.Fname;


--Query 16. Retrieve the name of each employee who has a dependent with the
--same first name and is the same sex as the employee.
select fname from employee e, dependent d where fname=dependent_name and e.sex=d.sex and e.ssn=d.essn

-- nested version
select fname, lname 
from employee e
where ssn in
  (select essn
  from dependent d 
  where fname=dependent_name and
  e.sex=d.sex)
  
-- correlated nested queries -------------
--Whenever a condition in the WHERE clause of a nested query references some attrib-
--ute of a relation declared in the outer query, the two queries are said to be correlated.

-- Means ---> nested query is evaluated once for each tuple (or combination of tuples) in the outer query. 

--exists function with correlated nested
select fname, lname 
from employee e
where exists (select * 
              from dependent d
              where e.ssn=d.essn
              and e.sex=d.sex
              and e.fname=d.dependent_name)
              
--Query 6. Retrieve the names of employees who have no dependents. -- correlated nested
select fname,lname
from employee e
where not exists (select *
                  from dependent d
                  where e.ssn=d.essn)
                  
--Query 7. List the names of managers who have at least one dependent.
--with 2 nested queries
select fname, lname
from employee e
where exists (select *
              from dependent d
              where e.ssn=d.essn)
              and
      exists (select *
              from department dp
              where dp.mgr_ssn=e.ssn)

--with 1 nested query
select fname, lname
from employee e
where exists (select *
              from dependent d, department dp
              where e.ssn=d.essn
              and dp.mgr_ssn=e.ssn)

--with no nested queries
select distinct fname, lname
from employee e, dependent d, department dp
where e.ssn=d.essn
and dp.mgr_ssn=e.ssn

--The query Q3: Retrieve the name of each employee who works on all the projects con-
--trolled by department number 5
select distinct fname, lname
from employee, works_on, project
where ssn=essn
and pno=pnumber
and dnum=5


select fname, lname
from employee
where not exists (( select pnumber
                  from project
                  where dnum=5)
                  except ( select pno
                          from works_on
                          where ssn=essn)) ????


-- There is another SQL function, UNIQUE(Q), which returns TRUE if there are no
-- duplicate tuples in the result of query Q; otherwise, it returns FALSE. This can be
-- used to test whether the result of a nested query is a set or a multiset.


--Query 17. Retrieve the Social Security numbers of all employees who work on
-- project numbers 1, 2, or 3.
select distinct essn
from  works_on
where pno in (1,2,3)



--- SQL JOINS ---
--The concept of a joined table (or joined relation) was incorporated into SQL to
--permit users to specify a table resulting from a join operation in the FROM clause of
--a query. This construct may be easier to comprehend than mixing together all the
--select and join conditions in the WHERE clause. 

--1. Join / inner join
---The default type of join in a joined table is called an inner join, where a tuple is
---included in the result only if a matching tuple exists in the other relation.

-- Retrieve all employees who are in 'Research' department
select fname, lname
from (employee join department on dno=dnumber)
where dname='Research'

select fname, lname
from (employee inner join department on dno=dnumber)
where dname='Research'

select e.fname, e.lname
from (employee e join employee e2 on e.ssn=e2.super_ssn)

--The FROM clause in Q1A contains a single joined table

--2. Natural Join 
      -- no join condition is specified
      -- join attributes need to be in same names unless need to rename 
select fname, lname
from employee e natural join department dept(dname, dno,s,ss) ???
where dname='Research'

--3. Outer join
-- inner join
select e.fname, e.lname,e.ssn,e2.fname, e2.lname,e2.super_ssn
from (employee e inner join employee e2 on e.ssn=e2.super_ssn)

--left outer join
select e.fname, e.lname,e.ssn,e2.fname, e2.lname,e2.super_ssn
from (employee e left outer join employee e2 on e.ssn=e2.super_ssn)

--right outer join
select e.fname, e.lname,e.ssn,e2.fname, e2.lname,e2.super_ssn
from (employee e right outer join employee e2 on e.ssn=e2.super_ssn)

--full outer join
select e.fname, e.lname,e.ssn,e2.fname, e2.lname,e2.super_ssn
from (employee e full outer join employee e2 on e.ssn=e2.super_ssn)

--Query 19. Find the sum of the salaries of all employees, the maximum salary,
--the minimum salary, and the average salary.
select count(*) from employee

select sum(salary) from employee

select sum(salary), max(salary), min(salary), avg(salary) from employee

select sum(salary) as sum, max(salary) as max, min(salary) as min, avg(salary) as avg from employee

select sum(salary), max(ssn) from employee

-- for reasearch department
--Query 20. Find the sum of the salaries of all employees of the ‘Research’
--department, as well as the maximum salary, the minimum salary, and the aver-
--age salary in this department.

select sum(salary), max(salary), min(salary), avg(salary) 
from employee join department on dno=dnumber
where dname='Research'

--Queries 21 and 22. Retrieve the total number of employees in the company
--(Q21) and the number of employees in the ‘Research’ department (Q22).
select count(*) as total_num_emp
from employee

select count(*) as total_research_emp 
from employee join department on dno=dnumber
where dname='Research'

--Query 23. Count the number of distinct salary values in the database.

select count(distinct salary) as sals
from employee

-- to retrieve the names of all employees who have two or more dependents
--(Query 5), we can write the following:
select fname, lname
from employee
where (select count(*)
      from  dependent 
      where ssn=essn) >= 2)
      
 
-- Group By - for partitionin
--to subgroups of tuples in a
--relation,
--Query 24. For each department, retrieve the department number, the number
--of employees in the department, and their average salary.
select dno, count(*),avg(salary)
from employee
group by dno

--group by dependent ssn
select essn, count(*)
from dependent
group by essn

--If NULLs exist in the grouping attribute, then a separate group is created for all
--tuples with a NULL value in the grouping attribute.
select super_ssn, count(*)
from employee
group by super_ssn
              
--Query 25. For each project, retrieve the project number, the project name, and
--the number of employees who work on that project.
select pnumber, pname, count(*)
from project join works_on on pno=pnumber
group by pnumber, pname

select pnumber, pname, count(*)
from project join works_on on pno=pnumber
group by pnumber, pname     
order by pnumber asc

-- Having - Sometimes we want to retrieve the values of these functions only for groups that sat-
---isfy certain conditions. 
--Query 26. For each project on which more than two employees work, retrieve
--the project number, the project name, and the number of employees who work
--on the project.
select pnumber, pname, count(*)
from project join works_on on pno=pnumber
group by pnumber, pname
having count(*)>2

--Query 27. For each project, retrieve the project number, the project name, and
--the number of employees from department 5 who work on the project.
select pnumber, pname, count(*)
from project join works_on on pno=pnumber
where dnum=5
group by pnumber, pname

select pnumber, pname, count(*)
from (project join works_on on pno=pnumber) join employee on ssn=essn
where dnum=5
group by pnumber, pname

--to count the total number of employees whose salaries exceed $40,000 in each
--department, but only for departments where more than five employees work. 

-- incorrect query
select dno,dname, count(*)
from employee join department on dno=dnumber
where salary > 40000
group by dno, dname
having count(*)>1

--correct query ??
select dno,dname, count(*)
from employee join department on dno=dnumber
where salary > 40000
and (select dno
      from employee
      group by dno
      having count(*)>5 )