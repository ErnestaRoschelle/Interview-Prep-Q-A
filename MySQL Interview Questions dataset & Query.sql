-- INTERVIEW QUESTION PRACTISE QUERIES

create table orders(
order_id INT primary key,
customer_id INT,
product_id INT);

insert into orders (order_id,customer_id,product_id)
values
(1, 101, 501),
(2, 102, 502),
(3, 101, 501),
(4, 103, 503),
(5, 101, 504),
(6, 102, 502),
(7, 104, 505);  

-- Remove duplicate rows from orders table
select customer_id,product_id,count(*)
from orders
group by customer_id,product_id
having count(*) > 1;

-- Remove the duplicate row keeping one record in each
with cte as
(
select * ,
row_number () over(partition by customer_id,product_id order by order_id) as row_num
from orders)
delete 
from orders -- In MySQL you cannot directly delete from cte table 
where order_id in ( select order_id from cte where row_num > 1);-- cannot delete directly using row_num instead use subquery with order_id

CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position varchar(50),
    salary DECIMAL(10, 2)
);
INSERT INTO employee (employee_id, first_name, last_name, position, salary) VALUES
(1, 'John', 'Doe', 'Software Engineer', 70000.00),
(2, 'Jane', 'Smith', 'Data Analyst', 65000.00),
(3, 'Alice', 'Johnson', 'Project Manager', 80000.00),
(4, 'Bob', 'Brown', 'UX Designer', 60000.00),
(5, 'Eve', 'Davis', 'Marketing Manager', 75000.00);


-- extract the second highest salary from the table
select *
from (select *,dense_rank() over(order by employee_id) as drk_num from employee) second_sal
where drk_num = 2 ; -- subquery is not good ,if data set is large so optimize using indexing on employee_id or by partitioning

INSERT INTO employee (employee_id, first_name, last_name, position, salary) VALUES
(6, 'Jon', 'Hunter', 'Software Engineer', 60000.00),
(7, 'Dane', 'Smith', 'Data Analyst', 75000.00),
(8, 'Ann', 'Eric', 'Project Manager', 70000.00),
(9, 'Bobby', 'Smith', 'UX Designer', 70000.00),
(10, 'Evelin', 'Daisy', 'Marketing Manager', 95000.00);

select * from employee;
with cte as (
select * ,
dense_rank() over(partition by position order by salary desc) as drk_num
from employee )
select *
from cte 
where drk_num = 2;

CREATE TABLE employee_sal(
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employee(employee_id)
);

INSERT INTO employee_sal (employee_id, name, salary, manager_id) VALUES
(1, 'John', 60000, NULL),
(2, 'Jane', 75000, 1),
(3, 'Alice', 55000, 1),
(4, 'Bob', 80000, 2),
(5, 'Carol', 70000, 2);

-- Display employees whose salary is greater than their managers salary
select e.employee_id,e.name,e.salary as emp_salary,m.manager_id,m.salary as manager_salary
from employee_sal e
join employee_sal m
     on m.manager_id=e.manager_id
where e.salary > m.salary;

CREATE TABLE tableone (
    id INT,
    name VARCHAR(50)
);

CREATE TABLE tabletwo (
    id INT,
    name VARCHAR(50)
);

INSERT INTO tableone (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

INSERT INTO tabletwo (id, name) VALUES
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David');

select * from tableone
union                    -- removes duplicates so performance takes time
select * from  tabletwo;

select * from tableone
union all               -- does not remove duplicates so query is faster
select * from  tabletwo;


