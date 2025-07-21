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
