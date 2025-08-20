create database musicstore;
use musicstore;

CREATE TABLE customer
(
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50),
    email_address VARCHAR(100) UNIQUE, -- declared as unique to prevent two users mistakenly registering with the same email.
    phone_number VARCHAR(20), -- used varchar and not int because we won't perform math on a phone number :"
    street_name VARCHAR(100),
    street_number VARCHAR(10), 
    zip_code VARCHAR(10)
);

CREATE TABLE employee
(
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
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
