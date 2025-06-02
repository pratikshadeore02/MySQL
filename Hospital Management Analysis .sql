create database final_project;
use final_project;

create table admissions(
patient_id int,
admission_date date,
discharge_date date,
diagnosis varchar(50),
attending_doctor_id int
);

SET SESSION SQL_MODE = "";

load data infile
"C:/admissions.csv"
into table admissions
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from admissions;

create table doctors(
doctor_id int,
first_name varchar(50),
last_name varchar(50),
specialty varchar(50)
);

load data infile
"C:/doctors.csv"
into table doctors
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from doctors;

create table patients(
patient_id int,
first_name varchar(50),
last_name varchar(50),
gender	varchar(50),
birth_date varchar(50),
city varchar(50),
province_id int,
allergies varchar(50),
height	float,
weight float
);

load data infile
"C:/patients.csv"
into table patients
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from patients;

create table province_name(
province_id int,
province_name varchar(50)
);

load data infile
"C:/province_names.csv"
into table province_name
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from province_name;


/*HOSPITAL MANAGEMENT ANALYSIS QUESTIONS*/

/*1] SHOW FIRST NAME,LAST NAME AND GENDER OF PATIENTS WHOSE GENDER IS 'M' */

select first_name,last_name,gender from patients
where gender='M';

/*2] SHOW FIRST NAME AND LAST NAME OF PATIENTS THAT WEIGHT THE RANGE OF 100 TO 120.*/

select first_name,last_name,weight from patients
 where 
 weight between '100' and '120'; 
 


/*3] SHOW FIRST NAME OF PATIENTS THAT STARTS WITH THE LETTER 'C'*/

select first_name from patients 
where first_name like "C%";

/*4] SHOW FIRST NAME AND LAST NAME CONCATINATED INTO ONE COLUMN TO SHOW THEIR FULL NAME.*/

select concat(first_name," ",last_name)
 as full_name from patients;

/*5] SHOW FIRST NAME,LAST NAME AND THE FULL PROVINCE NAME OF EACH PATIENT(EXAMPLE:'ONTARIO' INSTEAD OF 'ON'.*/

select first_name,last_name,province_name 
from patients 
join province_name
 on patients.province_id = province_name.province_id;


 
/*6] SHOW HOW MANY PATIENTS HAVE A BIRTHDATE WITH 2010 AS THE BIRTH YEAR.*/

select count(*) as total_patients from patients
where year(birth_date)='2010';

/*7] SHOW THE FIRST NAME,LAST NAME AND HEIGHT OF THE PATIENT WITH THE GREATEST HEIGHT.*/



select first_name,last_name,height from patients
order by height desc limit 1;


/*8] SHOW ALL COLUMNS FOR PATIENTS WHO HAVE ONE OF THE FOLLOWING PATIENTIDS:1,45,534,879,1000.*/

select * from patients
 where patient_id in(1,45,534,879,1000);

/*9] SHOW THE TOTAL NUMBER OF ADMISSIONS.*/

select count(*) as total_admissions from admissions;

/*10] SHOW ALL THE COLUMN FROM ADMISSIONS WHERE THE PATIENT WAS ADMITTED AND DISCHARGED ON THE SAME DAY.*/

select * from admissions where 
admission_date = discharge_date;

/*11] SHOW THE PATIENTS ID AND THE TOTAL NUMBER OF ADMISSION FOR PATIENTID 579.*/

select patient_id,count(patient_id) as total_admissions 
from admissions where patient_id = 579;

select patient_id,count(*) as total_admissions 
from admissions where patient_id = 579;

/*12] BASED ON THE CITIES THAT OUR PATIENTS LIVE IN SHOW UNIQUE CITIES THAT ARE IN PROVINCEID 'NS'?.*/

select distinct city from patients where province_id ='NS';

/*13] WRITE A QUERY TO FIND THE FIRST NAME,LAST NAME AND BIRTH DATE OF PATIENTS WHO HAS HEIGHT GREATER THAN 160 AND WEIGHT GREATER THAN 70.*/

select first_name,last_name,birth_date,height,weight from patients
where height>160 and weight>70;

/*14] WRITE A QUERY TO FIND LIST OF PATIENTS FIRST NAME,LAST NAME AND ALLERGIES WHERE ALLERGIES ARE NOT NULL AND ARE FROM THE CITY OF 'HAMILTON'.*/

SELECT first_name,last_name,allergies FROM patients
WHERE allergies IS NOT NULL AND city = 'Hamilton';