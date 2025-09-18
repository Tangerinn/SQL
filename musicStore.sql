create database musicstore;
use musicstore;

CREATE TABLE customer
(
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email_address VARCHAR(100) UNIQUE, -- declared as unique to prevent two users mistakenly registering with the same email.
    phone_number VARCHAR(20), -- used varchar and not int because we won't perform math on a phone number :"
    zip_code VARCHAR(10)
);

CREATE TABLE employee
(
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_number VARCHAR(20),
    salary DECIMAL(10, 2),
    date_of_birth DATE,
    date_of_hire DATE
    -- didn't make an age variable because age is can be derived using dob and current date.
);

CREATE TABLE company
(
    company_id INT PRIMARY KEY,
    company_name VARCHAR(50),
    phone_number VARCHAR(20),
	email_address VARCHAR(100),
	website VARCHAR(100)
);

CREATE TABLE repair_technician
(
employee_id int primary key,
speciality ENUM('Strings', 'Percussion', 'Woodwind', 'Electronics'), 
repair_rate decimal(10,2),
foreign key (employee_id) references employee(employee_id)
);

CREATE TABLE sales_associate
(
employee_id int primary key,
sales_target decimal(10,2),
foreign key (employee_id) references employee(employee_id)
);

CREATE TABLE sale
(
sale_id int primary key,
payment_method ENUM('Cash', 'Credit Card', 'UPI', 'Debit Card'),
total_amount decimal (10,2),
discount_applied decimal (10,2),
sale_date date,
sale_time time,
customer_id int,
employee_id int,
foreign key (customer_id) references customer(customer_id),
foreign key (employee_id) references employee(employee_id)
);


CREATE TABLE repair
(
repair_id int primary key,
request_date date,
start_date date,
completion_date date,
labor_cost decimal (10,2),
total_repair_cost decimal (10,2),
repair_status varchar(20), -- better than boolean (pending, in_progress, completed)
customer_id int,
employee_id int,
foreign key (customer_id) references customer(customer_id),
foreign key (employee_id) references employee(employee_id)
);

CREATE TABLE instrument
(
    serial_number VARCHAR(50) PRIMARY KEY, -- serial_number may not be an integer.
    instrument_type VARCHAR(50),
    model_name VARCHAR(50),
    mrp DECIMAL(10, 2),
    `condition` ENUM('New', 'Used', 'Refurbished'),
    sale_id INT,
    company_id INT,
    FOREIGN KEY (sale_id) REFERENCES sale(sale_id),
    FOREIGN KEY (company_id) REFERENCES company(company_id)
);


start transaction;

-- This script populates the musicstore database with sample data.
-- It assumes the tables have already been created.

-- Use the correct database
USE musicstore;

-- =================================================================
-- 1. PARENT TABLES (No dependencies)
-- =================================================================

-- A. Company Data
INSERT INTO company (company_id, company_name, phone_number, email_address, website) VALUES
(1, 'Fender', '18008570881', 'contact@fender.com', 'https://www.fender.com'),
(2, 'Yamaha', '18001035135', 'support@yamaha.in', 'https://in.yamaha.com'),
(3, 'Gibson', '18004442766', 'service@gibson.com', 'https://www.gibson.com'),
(4, 'Roland', '18001035135', 'support@roland.co.in', 'https://www.roland.com/in/'),
(5, 'Ibanez', '18004442766', 'support@ibanez.com', 'https://www.ibanez.com');

-- B. Customer Data
INSERT INTO customer (customer_id, first_name, last_name, email_address, phone_number, zip_code) VALUES
(101, 'Priya', 'Sharma', 'priya.s@example.com', '9820012345', '400050'),
(102, 'Rohan', 'Gupta', 'rohan.g@example.com', '9920123456', '400011'),
(103, 'Anjali', 'Singh', 'anjali.s@example.com', '9870234567', '400072'),
(104, 'Tanaya', 'Pawar', 'tanaya.p@example.com', '9820112233', '400050'),
(105, 'Sanika', 'Desai', 'sanika.d@example.com', '9920223344', '400049'),
(106, 'Sakshi', 'Patil', 'sakshi.p@example.com', '9870334455', '400020');

-- C. Employee Data (3 Sales, 3 Technicians)
-- The corrected INSERT statement for the employee table
INSERT INTO employee (employee_id, first_name, last_name, phone_number, salary, date_of_birth, date_of_hire) VALUES
(1, 'Vikram', 'Patel', '9820000111', 60000.00, '1990-05-15', '2018-03-01'),
(2, 'Neha', 'Joshi', '9920111222', 55000.00, '1992-08-22', '2019-07-10'),
(3, 'Suresh', 'Kumar', '9870222333', 75000.00, '1988-11-30', '2015-01-20'),
(4, 'Deepa', 'Mehta', '9820333444', 72000.00, '1991-02-18', '2017-06-15'),
(5, 'Arjun', 'Rao', '9920444555', 58000.00, '1995-01-25', '2022-02-01'),
(6, 'Pooja', 'Iyer', '9870555666', 78000.00, '1989-09-03', '2016-10-10');

-- =================================================================
-- 2. EMPLOYEE SUBTYPE TABLES
-- =================================================================

INSERT INTO sales_associate (employee_id, sales_target) VALUES
(1, 500000.00),
(2, 450000.00),
(5, 480000.00);

INSERT INTO repair_technician (employee_id, speciality, repair_rate) VALUES
(3, 'Strings', 1500.00),
(4, 'Electronics', 2000.00),
(6, 'Percussion', 1800.00);

-- =================================================================
-- 3. CHILD / TRANSACTIONAL TABLES
-- =================================================================

-- A. Sale Data (Creating 7 sales for our 7 instruments)
INSERT INTO sale (sale_id, payment_method, total_amount, discount_applied, sale_date, sale_time, customer_id, employee_id) VALUES
(1001, 'Credit Card', 45000.00, 0.00, '2025-08-18', '14:30:00', 101, 1),
(1002, 'UPI', 68000.00, 2000.00, '2025-08-19', '18:15:00', 102, 2),
(1003, 'UPI', 15000.00, 500.00, '2025-08-20', '11:10:00', 104, 1),
(1004, 'Debit Card', 82000.00, 0.00, '2025-08-20', '11:25:00', 105, 5),
(1005, 'Cash', 22000.00, 1500.00, '2025-08-20', '11:35:00', 106, 2),
(1006, 'Credit Card', 18000.00, 0.00, '2025-08-19', '12:00:00', 101, 5),
(1007, 'UPI', 35000.00, 3500.00, '2025-08-18', '17:45:00', 103, 1);

-- B. Repair Data
INSERT INTO repair (repair_id, request_date, start_date, completion_date, repair_status, labor_cost, total_repair_cost, customer_id, employee_id) VALUES
(2001, '2025-08-19', '2025-08-20', '2025-08-22', 'In Progress', 1500.00, 2500.00, 103, 3),
(2002, '2025-08-15', '2025-08-16', '2025-08-18', 'Completed', 4000.00, 5200.00, 106, 4),
(2003, '2025-08-20', '2025-08-21', '2025-08-25', 'Pending', 1800.00, 1800.00, 104, 3),
(2004, '2025-07-10', '2025-07-11', '2025-07-15', 'Completed', 5400.00, 6000.00, 105, 6),
(2005, '2025-08-18', '2025-08-18', '2025-08-20', 'Completed', 2000.00, 3100.00, 102, 4);

-- C. Instrument Data (All instruments are now linked to a sale)
INSERT INTO instrument (serial_number, instrument_type, model_name, mrp, `condition`, sale_id, company_id) VALUES
('SNFEN001', 'Guitar', 'Stratocaster', 45000.00, 'New', 1001, 1),
('SNYAM001', 'Keyboard', 'PSR-E373', 15000.00, 'New', 1003, 2),
('SNFEN002', 'Guitar', 'Telecaster', 68000.00, 'New', 1002, 1),
('SNGIB001', 'Guitar', 'Les Paul', 82000.00, 'New', 1004, 3),
('SNROL001', 'Drum Kit', 'V-Drums', 22000.00, 'Used', 1005, 4),
('SNIBA001', 'Bass Guitar', 'GSR200', 18000.00, 'New', 1006, 5),
('SNYAM002', 'Piano', 'P-45', 35000.00, 'Refurbished', 1007, 2);

=================================================================

-- DQL : BASIC TO ADVANCED 

-- select, from, as : 
select * from company;
select company_id, company_name from company;
select company_id as serial_number, company_name as company from company; -- "as" changes DISPLAY NAME of a column.

-- where, order by, limit
select * from employee;-- show all employees
select * from employee where salary>=70000; -- show employees who have salary more than 70k
select * from employee order by salary asc; -- list employee's data from least paid to most paid
select * from employee order by salary desc;-- list employee's data from most paid to least paid
select * from employee order by salary desc limit 3;-- list 3 most paid employees

-- JOINS : 
-- Find the names of all customers who bought an instrument manufactured by 'Fender'.
select 
customer.customer_id,
customer.first_name,
customer.last_name
from
customer
inner join 
sale
on customer.customer_id = sale.customer_id
inner join 
instrument 
on instrument.sale_id = sale.sale_id
inner join 
company
on company.company_id = instrument.company_id
where company.company_name = 'fender';



-- randommmm
-- I wanted to drop sale_id from sale(its a primary key in that table), but it is a foreign key in instrument table.
-- I couldn't because of the foreign key constraint.
-- So, drop the CONSTRAINT first.
-- Then, drop the column from the table that references it
-- Then, you can drop the table w it as the primary key.

-- dropped the constraint
ALTER TABLE instrument
DROP FOREIGN KEY instrument_ibfk_1;

-- dropped table from child
alter table instrument drop column sale_id; 

-- dropped table from parent
alter table sale drop column sale_id;

-- Now I can do what I wanted to : I wanted auto_incremented sale_id

-- sale_idalter table sale add column int sale_id auto_increment primary key;
select * from  sale;


