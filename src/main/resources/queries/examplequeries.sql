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

--Query 12. Retrieve all employees whose address is in Houston, Texas.
