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
  
-- correlated nested queries
--Whenever a condition in the WHERE clause of a nested query references some attrib-
--ute of a relation declared in the outer query, the two queries are said to be correlated.

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

