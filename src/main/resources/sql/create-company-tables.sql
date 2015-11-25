CREATE TABLE EMPLOYEE(
Fname varchar2(10),
Minit varchar2(1),
Lname varchar2(10),
Ssn number(10),
Bdate date,
Address varchar2(30),
Sex varchar2(1),
Salary number(5),
Super_ssn number(10),
Dno number(1)
);

create table department(
Dname varchar2(20),
Dnumber number(1),
Mgr_ssn number(10),
Mgr_start_date date
);

create table dept_locations(
Dnumber number(1),
Dlocation varchar2(10)
);

create table works_on(
Essn number(10),
Pno number(2),
Hours number(3,1)
);

create table project(
Pname varchar2(20),
Pnumber number(2),
Plocation varchar2(10),
Dnum number(1)
);

create table dependent(
Essn number(10),
Dependent_name varchar2(10),
Sex varchar2(1),
Bdate date,
Relationship varchar2(10)
);