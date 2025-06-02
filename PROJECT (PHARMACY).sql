create database pharmacy_sales;
use pharmacy_sales;

CREATE TABLE pharmacy_sales_data(
product_id INT,
units_sold INT,
total_sales DECIMAL (10,2),
cogs DECIMAL (10,2),
manufacturer VARCHAR (100),
drug VARCHAR (100));
drop table pharmacy_sales_data;
SET SESSION SQL_MODE = "";

load data infile
"C:/pharmacy_sales_data (1).csv"
into table pharmacy_sales_data
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT * FROM pharmacy_sales_data;

# Q-1. Write a query to calculate the total drug sales for each manufacturer.
##     Round the answer to the nearest million and report your results in descending order of total sales. 
##     In case of any duplicates, sort them alphabetically by the manufacturer name.

SELECT SUM(TOTAL_SALES) AS A,MANUFACTURER FROM pharmacy_sales_data GROUP BY MANUFACTURER ORDER BY A DESC;

SELECT 
    manufacturer,
    CONCAT('$', FORMAT(ROUND(SUM(TOTAL_sales) / 1000000), 0), ' million') AS total_sales
FROM 
    pharmacy_sales_data
GROUP BY 
    manufacturer
ORDER BY 
    ROUND(SUM(TOTAL_sales) / 1000000) DESC,
    manufacturer ASC;



## Q-2. Since this data will be displayed on a dashboard viewed by business stakeholders, please format your results as follows:- Eg:- "$36 million".

SELECT PRODUCT_ID,UNITS_SOLD,
    CONCAT('$', FORMAT((cogs)/1000000, 2), ' million') AS TOTAL_SALES,
    CONCAT('$', FORMAT((TOTAL_SALES)/1000000, 2), ' million') AS COGS,MANUFACTURER,DRUG
FROM 
    pharmacy_sales_data
WHERE 
    PRODUCT_ID BETWEEN 1 AND 188
    ORDER BY PRODUCT_ID ;


