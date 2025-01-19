CREATE TABLE album (
    album_id INT PRIMARY KEY,
    title TEXT NOT NULL,
    artist_id INT NOT NULL
);
select * from album;

CREATE TABLE artist (
    artist_id INTEGER PRIMARY KEY,
    name VARCHAR(255)
);
select * from artist;

CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    company VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(50),
    country VARCHAR(255),
    postal_code VARCHAR(20),
    phone VARCHAR(50),
    fax VARCHAR(50),
    email VARCHAR(255),
    support_rep_id INTEGER
);
select * from customer;

CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    last_name VARCHAR(255),
    first_name VARCHAR(255),
    title VARCHAR(255),
    reports_to INTEGER,
    levels VARCHAR(10),
    birthdate DATE,
    hire_date DATE,
    address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(50),
    country VARCHAR(255),
    postal_code VARCHAR(20),
    phone VARCHAR(50),
    fax VARCHAR(50),
    email VARCHAR(255)
);
select * from employee;

CREATE TABLE genre (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
select * from genre;

CREATE TABLE invoice (
    invoice_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    invoice_date TIMESTAMP NOT NULL,
    billing_address VARCHAR(255),
    billing_city VARCHAR(100),
    billing_state VARCHAR(50),
    billing_country VARCHAR(100),
    billing_postal_code VARCHAR(50),
    total NUMERIC(10, 2) NOT NULL
);
select * from invoice;

CREATE TABLE invoice_line (
    invoice_line_id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL,
    track_id INTEGER NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,
    quantity INTEGER NOT NULL
);
select * from invoice_line

CREATE TABLE media_type (
    media_type_id INT PRIMARY KEY,
    name TEXT
);
select * from media_type

CREATE TABLE playlist (
    playlist_id INT PRIMARY KEY,
    name TEXT
);
select * from playlist;

CREATE TABLE track (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    album_id INT,
    media_type_id INT,
    genre_id INT,
    composer VARCHAR(255),
    milliseconds INT,
    bytes INT,
    unit_price NUMERIC(5, 2)
);
select * from track;

CREATE TABLE playlist_track (
    playlist_id INT,
    track_id INT,
    PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id),
    FOREIGN KEY (track_id) REFERENCES track(id)
);
select * from playlist_track;

-- Question Set 1 - Easy
--Q1: Who is the senior most employee based on job title?
select * from employee
order by levels desc
limit 1

--Q2: Which Countries have the most invoices?
select count(*) as c, billing_country 
from invoice
group by billing_country
order by c desc

--Q3: What are top 3 values of total invoice
select total from invoice
order by total desc
limit 3;

--Q4: Which city has the best customers? We would like to throw a promotional Music 
--Festival in the city we made the most money. Write a query that returns one city that 
--has the highest sum of invoice totals. Return both the city name & sum of all invoice 
--totals
select billing_city, sum(total) as invoice_total
from invoice
group by billing_city
order by sum(total) desc

--Q5: Who is the best customer? The customer who has spent the most money will be 
--declared the best customer. Write a query that returns the person who has spent the 
--most money 
select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
from customer
JOIN invoice ON customer.customer_id = invoice.customer_id 
GROUP BY customer.customer_id
ORDER BY total DESC
limit 1;

-- Question Set 2 - Moderate
--Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--Return your list ordered alphabetically by email starting with A
select Distinct email, first_name, last_name
from customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	select id from track 
	JOIN genre ON track.genre_id = genre.genre_id
	Where genre.name LIKE 'ROCK'
)
ORDER BY email;

--Q2: Let's invite the artists who have written the most rock music in our dataset. Write a 
--query that returns the Artist name and total track count of the top 10 rock bands 
select artist.artist_id, artist.name, COUNT(artist.artist_id) as number_of_songs
from track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'ROCK'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

--Q3:  Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the 
--longest songs listed first
select name, milliseconds
from track
where milliseconds > (
	select avg(milliseconds) as avg_track_length
	from track)
order by milliseconds desc;	

-- Question Set 3 - Advance
--Q1: Find how much amount spent by each customer on artists? Write a query to return 
--customer name, artist name and total spent
WITH best_selling_artist AS(
	select artist.artist_id as artist_id, artist.name as artist_name, 
	sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN album ON album.album_id = track.album_id
    JOIN artist ON artist.artist_id = album.artist_id
    GROUP BY 1
    ORDER BY 3 DESC
    LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) as amount 
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.abum_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

--Q2: We want to find out the most popular music Genre for each country. We determine the 
--most popular genre as the genre with the highest amount of purchases. Write a query 
--that returns each country along with the top Genre. For countries where the maximum 
--number of purchases is shared return all Genres
WITH popular_genre AS(
	SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
	ROW_NUMBER() OVER (PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
	FROM invoice_line
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.gentre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1

--Q3: Write a query that determines the customer that has spent the most on music for each 
--country. Write a query that returns the country along with the top customer and how 
--much they spent. For countries where the top amount spent is shared, provide all 
--customers who spent this amount
--1st method
WITH RECURSIVE
    customer_with_country as(
		select customer.customer_id, first_name, last_name, billing_country, SUM(total) as total_spending
        from invoice 
        JOIN customer ON customer.customer_id = invoice.customer_id
        GROUP BY 1,2,3,4
        ORDER BY 2,3 DESC),
		
	country_max_spending as(
		select billing_country, MAX(total_spending) as max_spending
		FROM customer_with_country
		GROUP BY billing_country)
		
SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
FROM customer_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country

--2nd method
WITH Customer_with_country AS(
	SELECT customer.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending,
	ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo
	FROM invoice
	JOIN customer ON customer.customer_id = invoice.customer_id
	GROUP BY 1,2,3,4
	ORDER BY 4 ASC, 5 DESC) 
SELECT * FROM Customer_with_country WHERE RowNo <= 1


















	






















