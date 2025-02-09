-- Drop existing tables to reset the database
DROP TABLE IF EXISTS Track;
DROP TABLE IF EXISTS Album;
DROP TABLE IF EXISTS Musician;

-- Create Musician table
CREATE TABLE Musician (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    country VARCHAR(50),
    debut_year YEAR

);

-- Create Album table
CREATE TABLE Album (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    musician_id INTEGER NOT NULL,
    name VARCHAR(150) NOT NULL,
    year INTEGER NOT NULL,
    genre VARCHAR(50),
    UNIQUE(musician_id, name, year), 
    FOREIGN KEY(musician_id) REFERENCES Musician(id)
);

-- Create Track table
CREATE TABLE Track (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    album_id INTEGER NOT NULL,
    name VARCHAR(150) NOT NULL,
    duration TIME,
    track_number INT,
    FOREIGN KEY(album_id) REFERENCES Album(id)
);
SELECT DISTINCT Album.id AS albumId, Album.name AS albumName, Album.year AS albumYear
FROM Musician
JOIN Album ON Musician.id = Album.musician_id
WHERE LOWER(Musician.name) = LOWER(?)
ORDER BY Album.year;

-- Insert sample data
INSERT INTO Musician (name) VALUES 
('Taylor Swift'), 
('Ed Sheeran');

-- Insert Albums for Musicians
INSERT OR IGNORE INTO Album (musician_id, name, year) VALUES
(1, 'Fearless', 2008), 
(1, '1989', 2014),
(2, 'Divide', 2017), 
(2, 'Multiply', 2014);

-- Insert Tracks for Albums
INSERT INTO Track (album_id, name) VALUES
-- Taylor Swift's "Fearless" album
(1, 'Love Story'), (1, 'You Belong with Me'), (1, 'Fearless'),
-- Taylor Swift's "1989" album
(2, 'Blank Space'), (2, 'Shake It Off'), (2, 'Style'),
-- Ed Sheeran's "Divide" album
(3, 'Shape of You'), (3, 'Perfect'), (3, 'Castle on the Hill'),
-- Ed Sheeran's "Multiply" album
(4, 'Sing'), (4, 'Thinking Out Loud'), (4, 'Photograph');
