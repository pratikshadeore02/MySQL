create database sql_challenge2;
use sql_challenge2;

/*Write a query to calculate the percentage of total transaction volume processed via PayPal in year
2024.
*/
CREATE TABLE Transactions (
TransactionID varchar(50),
UserID VARCHAR(10),
PaymentMethod VARCHAR(20),
TransactionAmount DECIMAL(18,10),
TransactionDate DATE );
drop table Transactions ;
SET SESSION SQL_MODE = "";

load data infile
"C:/payments_data.csv"
into table Transactions
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from Transactions ;


WITH paypal_transactions_2024 AS (
    SELECT
        SUM(TransactionAmount) AS PaypalTotal
    FROM Transactions
    WHERE YEAR(TransactionDate) = 2024
    AND PaymentMethod = 'PayPal'
),
total_transactions_2024 AS (
    SELECT
        SUM(TransactionAmount) AS TotalAmount
    FROM Transactions
    WHERE YEAR(TransactionDate) = 2024
)
SELECT 
    ROUND(
        (PaypalTotal / TotalAmount) * 100,
        2
    ) AS PaypalPercentage
FROM paypal_transactions_2024, total_transactions_2024;

## --------------------------------------------------

/*
Risk is calculated by the addition of CBC, RBH, and LBH. If the sum is more than 20,  &quot;High&quot;,
between 16-20 then &quot;Medium&quot;, else &quot;Low&quot;
*/

CREATE TABLE insurance (
Patient_id INT PRIMARY KEY,
Insurance_id INT,
Insurance_Name VARCHAR(50)
);


INSERT INTO insurance (Patient_id, Insurance_id, Insurance_Name)
VALUES
(1, 1001, "India Insurance"),
(2, 1002,  "Lombard"),
(3, 1001, " Insurance"),
(4, 1003, "Health"),
(5, 1003,  "Health");

-- --------------------------
CREATE TABLE test (
Patient_id INT,
Test_type VARCHAR(10),
Test_score INT,
FOREIGN KEY (Patient_id) REFERENCES insurance(Patient_id)
);
-- 
INSERT INTO test (Patient_id, Test_type, Test_score)
VALUES 
(1, 'CBC', 7),(1, 'RBC', 6),(1, 'LBH', 6),(2, 'CBC', 7),(2, 'RBC', 8),(2, 'LBH', 8),
(3, 'CBC', 5),(3, 'RBC', 4),(3, 'LBH', 4),(4, 'CBC', 4),(4, 'RBC', 6),(4, 'LBH', 6),
(5, 'CBC', 5),(5, 'RBC', 6),(5, 'LBH', 7);


WITH risk_scores AS (
    SELECT
        t.Patient_id,
        i.Insurance_id,
        i.Insurance_Name,
        SUM(CASE WHEN t.Test_type = 'CBC' THEN t.Test_score ELSE 0 END) AS CBC,
        SUM(CASE WHEN t.Test_type = 'RBC' THEN t.Test_score ELSE 0 END) AS RBC,
        SUM(CASE WHEN t.Test_type = 'LBH' THEN t.Test_score ELSE 0 END) AS LBH
    FROM test t
    JOIN insurance i ON t.Patient_id = i.Patient_id
    GROUP BY t.Patient_id, i.Insurance_id, i.Insurance_Name
)
SELECT
    Patient_id,
    Insurance_id,
    Insurance_Name,
    CBC + RBC + LBH AS Total_Score,
    CASE
        WHEN (CBC + RBC + LBH) > 20 THEN 'High'
        WHEN (CBC + RBC + LBH) BETWEEN 16 AND 20 THEN 'Medium'
        ELSE 'Low'
    END AS Risk_Level
FROM risk_scores;


#-------------------------------------------------------

/*Write a SQL query to determine the count of delayed orders for each delivery partner.*/

CREATE TABLE order_details (
orderid INT PRIMARY KEY,
custid INT,
city VARCHAR(50),
order_date DATE,
del_partner VARCHAR(50),
order_time TIME,
deliver_time TIME,
p_time INT,
aov DECIMAL(10, 2));

drop table order_details;
INSERT INTO order_details 
VALUES
(1, 101, 'Bangalore', '2024-01-01', 'PartnerA', '10:00:00', '11:30:00', 60, 100.00),
(2, 102, 'Chennai', '2024-01-02', 'PartnerB', '12:00:00', '13:15:00', 45, 200.00),
(3, 103, 'Bangalore', '2024-01-03', 'PartnerA', '14:00:00', '15:45:00', 60, 300.00),
(4, 104, 'Chennai', '2024-01-04', 'PartnerB', '16:00:00', '17:30:00', 90, 400.00);


WITH cte AS (
SELECT del_partner,
TIMESTAMPDIFF(minute,order_time,deliver_time)as actual_delivery_time,
p_time
from order_details),

cte_2 as(
SELECT del_partner,
sum(case when actual_delivery_time > p_time then 1 end) as delayed_orders_cnt,
sum(case when actual_delivery_time <= p_time then 1 end) as on_time_orders_cnt
from cte
group by del_partner)

select del_partner,delayed_orders_cnt
from cte_2;



## -----------------------------------------------------------------------------------------------------------

/*How do you find the 3rd highest salary from a table?*/

CREATE TABLE Employees_records (
EmployeeId  INT PRIMARY KEY, 
EmployeeName VARCHAR(50),
City VARCHAR(50),
DateOfJoining DATETIME, 
Salary DECIMAL(10, 2), 
DepartmentId INT );

INSERT INTO Employees_records (EmployeeId, EmployeeName, City, DateOfJoining, Salary, DepartmentId) 
VALUES (1, 'Rahul', 'Pune', '2022-06-30 20:53:58.963', 123400.00, 4), 
(2, 'Sharath', 'Kanpur', '2022-03-17 06:13:11.000', 56789.00, 3), 
(3, 'Pankaj', 'Delhi', '2022-07-24 20:23:25.200', 34560.00, 3),
 (4, 'Sharddul', 'Pune', '2023-07-01 16:10:11.530', 23400.00, NULL), 
 (5, 'Mohan', 'Manali', '2023-07-14 10:15:10.310', 12600.00, NULL), 
 (6, 'Rekha', 'Manali', '2023-07-14 10:15:10.310', 12600.00, NULL), 
 (7, 'Mamta Banarjee', 'Kolkata', '2023-07-15 13:47:48.530', 15600.00, NULL), 
 (8, 'Parambeer Singh', 'Mumbai', '2022-09-16 07:27:46.453', 3450.00, 4);

SELECT MAX(Salary) AS ThirdHighestSalary
FROM Employees_records
WHERE Salary < (
    SELECT  max(Salary)
    FROM Employees_records where salary < (SELECT  max(Salary)
    FROM Employees_records)
    ORDER BY Salary DESC
);

##  ----------------------------------------------------------------------------------------------------------

/*calculating the percentage of genders in an Employee table.*/

CREATE TABLE employ ( 
eid INT PRIMARY KEY, 
ename VARCHAR(50), 
gender VARCHAR(10) );

INSERT INTO employ (eid, ename, gender) 
VALUES (1, 'John Doe', 'Male'),
(2, 'Jane Smith', 'Female'), 
(3, 'Michael Johnson', 'Male'), 
(4, 'Emily Davis', 'Female'), 
(5, 'Robert Brown', 'Male'), 
(6, 'Sophia Wilson', 'Female'),
 (7, 'David Lee', 'Male'), 
 (8, 'Emma White', 'Female'), 
 (9, 'James Taylor', 'Male'), 
 (10, 'William Clark', 'Male'); 
 
 
select
sum(case when gender = 'male' then 1 else 0 end)*100/count(*) as male_perc,
sum(case when gender = 'female' then 1 else 0 end)*100/count(*) as female_perc
from employ;
## ------------------------------------------------------------------------------------------------------------------------

/* Return the Players and their total runs scored, those who did at least two half centuries and
did not out for a duck..*/

create table matches (
match_id int,
player_id int,
runs_scored int
);

insert into matches 
values (1, 208, 28),
(2, 105, 0),
(3, 201, 75),
(4, 310, 48),
 (5, 402, 52),
 (6, 208, 58),
 (7, 105, 78),
 (8, 402, 25),
 (9, 310, 0),
 (10, 201, 90),
 (11, 208, 84),
 (12, 105, 102);

/*Table - 2*/
create table players (
id int primary key,
name varchar(20)
);

insert into players
values (208, 'Dekock'),
(105, 'Virat'),
(201, 'Miller'),
(310, 'Warner'), 
(402, 'Buttler');


with cte as (
select name,
sum(runs_scored)as total_runs,
count(case when runs_scored >50 then 1 end) as fifty_plus_count,
count(case when runs_scored = 0 then 1 end) as total_duck
from matches as t1
inner join players as t2
on t1.player_id = t2.id
group by name)

select name ,total_runs
from cte
where fifty_plus_count >= 2 and total_duck = 0;
