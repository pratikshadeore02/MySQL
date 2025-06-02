CREATE DATABASE MUSIC_STORE;
USE MUSIC_STORE;

CREATE TABLE EMPLOYEE(
employee_id INT,
last_name VARCHAR (50),
first_name VARCHAR(50),
title VARCHAR(50),
reports_to VARCHAR(50),
levels VARCHAR(50),
birthdate VARCHAR(50),
hire_date VARCHAR(50) ,
address VARCHAR(50),
city VARCHAR(50),
state VARCHAR (50),
country VARCHAR (50),
postal_code VARCHAR (50),
phone VARCHAR(50),
fax VARCHAR(50),
email VARCHAR (50));
DROP TABLE EMPLOYEE;
SET SESSION SQL_MODE = "";

load data infile
'C:/employee.csv'
into table EMPLOYEE
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
drop table employee;
SELECT * FROM EMPLOYEE;

CREATE TABLE CUSTOMER (
customer_id INT PRIMARY KEY,
first_name VARCHAR (30),
last_name VARCHAR (30),
company VARCHAR (50),
address VARCHAR (100),
city VARCHAR (35),
state VARCHAR (30),
country VARCHAR (40),
postal_code VARCHAR (100),
phone INT,
fax INT,
email VARCHAR (50),
support_rep_id INT,
foreign key(support_rep_id) references employee(employee_id)
);
DROP TABLE CUSTOMER;
load data infile
'C:/customer.csv'
into table CUSTOMER
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT * FROM CUSTOMER;

CREATE TABLE INVOICE(
invoice_id INT PRIMARY KEY,
customer_id INT,
invoice_date DATETIME,
billing_address VARCHAR (100),
billing_city  VARCHAR (100),
billing_state  VARCHAR (100),
billing_country  VARCHAR (100),
billing_postal_code  VARCHAR (100),
total DECIMAL (10,2),
FOREIGN KEY (customer_id) REFERENCES CUSTOMER (customer_id));
DROP TABLE INVOICE;
load data infile
'C:/invoice.csv'
into table INVOICE
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT * FROM INVOICE;

CREATE TABLE INVOICE_LINE (
invoice_line_id INT PRIMARY KEY,
invoice_id INT,
track_id INT,
unit_price INT,
quantity INT,
FOREIGN KEY (invoice_id) REFERENCES INVOICE (invoice_id));

load data infile
'C:/invoice_line.csv'
into table INVOICE_LINE
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT * FROM INVOICE_LINE;

DROP TABLE TRACK;
CREATE TABLE TRACK(
track_id INT PRIMARY KEY,
name VARCHAR (30),
album_id INT,
media_type_id INT,
genre_id INT,
composer VARCHAR(100),
milliseconds INT,
bytes INT,
unit_price DECIMAL (10,2),   
FOREIGN KEY (track_id) REFERENCES INVOICE_LINE (invoice_line_id));


load data infile
'C:/track.csv'
into table TRACK
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT * FROM TRACK;

CREATE TABLE MEDIA_TYPE (
media_type_id	INT PRIMARY KEY,
name VARCHAR (50));

load data infile
'C:/media_type.csv'
into table MEDIA_TYPE
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT * FROM MEDIA_TYPE;

CREATE TABLE GENRE (
genre_id INT PRIMARY KEY,
NAME VARCHAR (100));

load data infile
'C:/genre.csv'
into table GENRE
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT * FROM GENRE;

CREATE TABLE PLAYLIST(
playlist_id	INT PRIMARY KEY,
name VARCHAR (50));

load data infile
'C:/Playlist.csv'
into table PLAYLIST
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT * FROM PLAYLIST;

CREATE TABLE PLAYLIST_TRACK(
playlist_id	INT,
track_id INT,
FOREIGN KEY (playlist_id) REFERENCES PLAYLIST1(playlist_id));

load data infile
'C:/playlist_track.csv'
into table PLAYLIST_TRACK
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT * FROM PLAYLIST_TRACK;

CREATE TABLE ARTIST(
artist_id INT PRIMARY KEY,
name VARCHAR (300));

load data infile
'C:/artist.csv'
into table ARTIST
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT * FROM ARTIST;

DROP TABLE ALBUM;
CREATE TABLE ALBUM(
album_id INT PRIMARY KEY,	
title	VARCHAR (150),
artist_id INT );

load data infile
'C:/album.csv'
into table ALBUM
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT * FROM ALBUM;
SELECT * FROM INVOICE;

##---------------------------------------- PROJECT QUTIONS -------------------------------------
##----------------------------- Set 1 - Easy -------------------------------

## 1. Who is the senior most employee based on job title? 
 
SELECT * FROM EMPLOYEE;

SELECT TITLE AS "Senior Most Employee",LAST_NAME,FIRST_NAME,LEVELS 
FROM  EMPLOYEE where LEVELS = (SELECT MAX(LEVELS) FROM  EMPLOYEE);

## 2. Which countries have the most Invoices?  

SELECT BILLING_COUNTRY,SUM(TOTAL) 
FROM INVOICE 
GROUP BY BILLING_COUNTRY 
LIMIT 1;

## 3. What are top 3 values of total invoice?  

SELECT * 
FROM INVOICE
ORDER BY TOTAL DESC 
LIMIT 3 ;

## 4. Which city has the best customers? We would like to throw a promotional Music Festival in the 
##  -city we made the most money. Write a query that returns one city that has the highest sum of 
##  -invoice totals. Return both the city name & sum of all invoice totals 


SELECT BILLING_CITY,SUM(TOTAL) AS "Highest Invoice"
FROM INVOICE
GROUP BY BILLING_CITY 
LIMIT 1;

## 5. Who is the best customer? The customer who has spent the most money will be declared the 
##  -best customer. Write a query that returns the person who has spent the most money

SELECT FIRST_NAME,LAST_NAME AS BESTCUSTOMER,TOTAL
FROM INVOICE AS A
INNER JOIN CUSTOMER AS B
ON A.customer_id = B.customer_id
ORDER BY A.TOTAL DESC
LIMIT 1;

SELECT FIRST_NAME,LAST_NAME,MAX(TOTAL) AS VIP
FROM INVOICE AS A
INNER JOIN CUSTOMER AS B
ON A.CUSTOMER_ID = B.CUSTOMER_ID
GROUP BY FIRST_NAME,LAST_NAME
ORDER BY VIP DESC
LIMIT 1;

## ------------------------------ Set 2 – Moderate -------------------------- 
## 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners.Return your list ordered 
## alphabetically by email starting with A 

SELECT EMAIL,FIRST_NAME,LAST_NAME,E.NAME 
FROM CUSTOMER AS A
JOIN INVOICE AS B 
ON A.CUSTOMER_ID = B.CUSTOMER_ID 
JOIN INVOICE_LINE AS C 
ON B.INVOICE_ID=C.INVOICE_ID
JOIN TRACK AS D 
ON C.TRACK_ID = D.TRACK_ID
JOIN GENRE AS E  
ON D.GENRE_ID = E.GENRE_ID 
WHERE E.GENRE_ID=1 
ORDER BY A.EMAIL DESC;

SELECT EMAIL,FIRST_NAME,LAST_NAME,E.NAME 
FROM CUSTOMER AS A
JOIN INVOICE AS B 
ON A.CUSTOMER_ID = B.CUSTOMER_ID 
JOIN INVOICE_LINE AS C 
ON B.INVOICE_ID=C.INVOICE_ID
JOIN TRACK AS D 
ON C.TRACK_ID = D.TRACK_ID
JOIN GENRE AS E  
ON D.GENRE_ID = E.GENRE_ID 
WHERE A.email LIKE "A%" 
ORDER BY A.EMAIL DESC;

## 2. Let's invite the artists who have written the most rock music in our dataset. Write a query that 
## returns the Artist name and total track count of the top 10 rock bands 

SELECT ar.Name AS ArtistName,G.NAME AS GNAME, COUNT(t.Track_Id) AS TotalTrackCount
FROM Artist AS ar
JOIN Album AS al ON ar.Artist_Id = al.Artist_Id
JOIN Track AS t ON al.Album_Id = t.Album_Id
JOIN Genre AS g ON t.Genre_Id = g.Genre_Id
WHERE g.GENRE_ID = 1
GROUP BY ar.Name
ORDER BY TotalTrackCount DESC
LIMIT 10;

## 3.Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds
## for each track. Order by the song length with the longest songs listed first

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;
##  ----------------------Set 3 – Advance ---------------------------

## 1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total 
## -spent 

SELECT c.First_Name AS CustomerName,
       ar.Name AS ArtistName,
       SUM(ii.Unit_Price * ii.Quantity) AS TotalSpent
FROM Customer AS c
JOIN Invoice AS i ON c.Customer_Id = i.Customer_Id
JOIN Invoice_Line AS ii ON i.Invoice_Id = ii.Invoice_Id
JOIN Track AS t ON ii.Track_Id = t.Track_Id
JOIN Album AS al ON t.Album_Id = al.Album_Id
JOIN Artist AS ar ON al.Artist_Id = ar.Artist_Id
GROUP BY c.Customer_Id, ar.Artist_Id
ORDER BY c.First_Name;

## 2. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with
## the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the
## maximum number of purchases is shared return all Genres  

/* Steps to Solve:  There are two parts in question- first most popular music genre and second need data at country level. */

/* Method 1: Using CTE */

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1


/* Method 2: : Using Recursive */

WITH RECURSIVE
	sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY 2,3,4
		ORDER BY 2
	),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY 2
		ORDER BY 2)

SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;



## 3. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns
## the country along with the top customer and how much they spent. For countries where the top amount spent is shared, 
## provide all customers who spent this amount


/* Steps to Solve:  Similar to the above question. There are two parts in question- 
first find the most spent on music for each country and second filter the data for respective customers. */

/* Method 1: using CTE */

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1


/* Method 2: Using Recursive */

WITH RECURSIVE 
	customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 2,3 DESC),

	country_max_spending AS(
		SELECT billing_country,MAX(total_spending) AS max_spending
		FROM customter_with_country
		GROUP BY billing_country)

SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
FROM customter_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;
