create database swiggy;
use swiggy;
CREATE TABLE swiggy_restaurants (
    ID INT PRIMARY KEY,
    Area VARCHAR(100),
    City VARCHAR(100),
    Restaurant VARCHAR(255),
    Price DECIMAL(10,2),
    Avg_ratings DECIMAL(2,1),
    Total_ratings INT,
    Food_type TEXT,
    Address VARCHAR(255),
    Delivery_time INT
);

SET SESSION SQL_MODE = "";

load data infile
"C:/swiggy.csv"
into table  swiggy_restaurants
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from swiggy_restaurants; 

/*...........................QUESTIONS................................*/

				 /*...........MEDIUM...........*/
/*1. Find the restaurant with the lowest price in 'Koramangala' .*/

SELECT *
FROM swiggy_restaurants
WHERE Area = 'Koramangala'
ORDER BY Price ASC
LIMIT 1;

/*2. List al l restaurants in 'Hyderabad' with delivery times less than 50 minutes. */

SELECT *
FROM swiggy_restaurants
WHERE City = 'Hyderabad' AND Delivery_time < 50;

/*3.Count the number of 'Bengali' food type restaurants in each area of 'Bangalore'.*/

SELECT Area, COUNT(*) AS Bengali_Restaurants
FROM swiggy_restaurants
WHERE City = 'Bangalore' AND Food_type LIKE '%Bengali%'
GROUP BY Area;

/* 4. Find the restaurant with the highest total ratings in 'Indiranagar'.*/

SELECT *
FROM swiggy_restaurants
WHERE Area = 'Indiranagar'
ORDER BY Total_ratings DESC
LIMIT 1;

/* 5. List all 'Italian' food type restaurants in 'Bangalore'.*/

SELECT *
FROM swiggy_restaurants
WHERE City = 'Bangalore' AND Food_type LIKE '%Italian%';

/* 6. Calculate the average delivery time of restaurants in 'Mumbai '.*/

SELECT AVG(Delivery_time) AS Avg_Delivery_Time
FROM swiggy_restaurants
WHERE City = 'Mumbai';

/*7. Find all restaurants with an average rating of exactly 4.5.*/

SELECT *
FROM swiggy_restaurants
WHERE Avg_ratings = 4.5;

/* 8. List the top 3 most expensive restaurants in 'Bangalore'.*/

SELECT *
FROM swiggy_restaurants
WHERE City = 'Bangalore'
ORDER BY Price DESC
LIMIT 3;

/* 9. Find all restaurants serving 'Seafood' in 'Bangalore'.*/

SELECT *
FROM swiggy_restaurants
WHERE City = 'Bangalore' AND Food_type LIKE '%Seafood%';

/* 10. Count the total number of restaurants in 'Indiranagar'.*/

SELECT COUNT(*) AS Total_Restaurants
FROM swiggy_restaurants
WHERE Area = 'Indiranagar';

/* 11. List all 'Fast Food' restaurants in 'Bangalore'.*/

SELECT *
FROM swiggy_restaurants
WHERE City = 'Bangalore' AND Food_type LIKE '%Fast Food%';

/* 12. Find the restaurant with the highest average rating in 'Hyderabad'.*/

SELECT *
FROM swiggy_restaurants
WHERE City = 'Hyderabad'
ORDER BY Avg_ratings DESC
LIMIT 1;

/* 13. Calculate the total number of ratings for all restaurants in 'Koramangala'.*/

SELECT SUM(Total_ratings) AS Total_Ratings
FROM swiggy_restaurants
WHERE Area = 'Koramangala';

/* 14. List the names and delivery times of restaurants serving 'Mexican' food.*/

SELECT Restaurant, Delivery_time
FROM swiggy_restaurants
WHERE Food_type LIKE '%Mexican%';

/* 15. Find the restaurant with the lowest average rating in 'Film Nagar'.*/

SELECT *
FROM swiggy_restaurants
WHERE Area = 'Film Nagar'
ORDER BY Avg_ratings ASC
LIMIT 1;

/* 16.Find the restaurant with the best average rating for each food type in'Bangalore'.*/

SELECT Food_type, Restaurant, MAX(Avg_ratings) AS Best_Rating
FROM swiggy_restaurants
WHERE City = 'Bangalore'
GROUP BY Food_type;

/* 17.Identify the top 3 areas in each city with the highest average restaurant prices.*/

SELECT City, Area, AVG(Price) AS Avg_Price
FROM swiggy_restaurants
GROUP BY City, Area
ORDER BY City, Avg_Price DESC;

/* 18.Calculate the total number of restaurants and the average delivery time 
foreach combination of food types (e.g., 'Biryani ' and 'Chinese' ).*/

SELECT Food_type, COUNT(*) AS Total_Restaurants, AVG(Delivery_time) AS Avg_Delivery_Time
FROM swiggy_restaurants
GROUP BY Food_type;

/* 19. Find all restaurants that serve both 'North Indian' and 'Chinese' food types,
have an average rat ing above 4, and are located in 'Bangalore'.*/

SELECT *
FROM swiggy_restaurants
WHERE City = 'Bangalore'
  AND Food_type LIKE '%North Indian%'
  AND Food_type LIKE '%Chinese%'
  AND Avg_ratings > 4;
  
/* 20.List the top 5 most expensive restaurants in 'Bangalore' that have an average rat ing of at least 4.5.*/

SELECT *
FROM swiggy_restaurants
WHERE City = 'Bangalore' AND Avg_ratings >= 4.5
ORDER BY Price DESC
LIMIT 5;

/* 21.Identify the cities where the average delivery time of 'Mughlai ' restaurants is less than 55 minutes.*/

SELECT City, AVG(Delivery_time) AS Avg_Delivery_Time
FROM swiggy_restaurants
WHERE Food_type LIKE '%Mughlai%'
GROUP BY City
HAVING AVG(Delivery_time) < 55;

/* 22.Find the top 5 restaurants in each city with the highest total ratings for 'Biryani ' food type.*/

SELECT *
FROM swiggy_restaurants
WHERE Food_type LIKE '%Biryani%'
ORDER BY City, Total_ratings DESC
limit 5;

/* 23.Calculate the average price and total number of ratings for 'Fast Food' restaurants in each area of 'Bangalore'.*/

SELECT Area, AVG(Price) AS Avg_Price, SUM(Total_ratings) AS Total_Ratings
FROM swiggy_restaurants
WHERE City = 'Bangalore' AND Food_type LIKE '%Fast Food%'
GROUP BY Area;

/* 24.List all 'Desserts' restaurants in 'Bangalore' that have more than 200 total
ratings and an average rating above the overall average rating of all 'Desserts' restaurants.*/

SELECT *
FROM swiggy_restaurants
WHERE City = 'Bangalore'
  AND Food_type LIKE '%Desserts%'
  AND Total_ratings > 200
  AND Avg_ratings > (
      SELECT AVG(Avg_ratings)
      FROM swiggy_restaurants
      WHERE Food_type LIKE '%Desserts%'
  );

/* 25.Find the top 3 restaurants with the highest average rating in 'Mumbai ' that
serve 'Chinese' food type and have more than 100 total ratings.*/

SELECT *
FROM swiggy_restaurants
WHERE City = 'Mumbai'
  AND Food_type LIKE '%Chinese%'
  AND Total_ratings > 100
ORDER BY Avg_ratings DESC
LIMIT 3;


