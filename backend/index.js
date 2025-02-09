const express = require("express");
const cors = require("cors");
const sqlite3 = require("sqlite3").verbose();

const app = express();
const PORT = 5000;

app.use(cors());
app.use(express.json());

// Initialize SQLite database
const db = new sqlite3.Database("./music.db", (err) => {
    if (err) {
        console.error("Error connecting to SQLite database:", err.message);
    } else {
        console.log("Connected to SQLite database.");
    }
});

// Endpoint to query musician and their albums
app.get("/musician", (req, res) => {
    const { name } = req.query;

    const sql = `
        SELECT Album.id AS albumId, Album.name AS albumName, Album.year AS albumYear
        FROM Musician
        JOIN Album ON Musician.id = Album.musician_id
        WHERE LOWER(Musician.name) = LOWER(?)
    `;

    db.all(sql, [name.trim()], (err, rows) => {
        if (err) {
            return res.status(500).json({ error: "Database query failed." });
        }
        if (rows.length === 0) {
            return res.json({ albums: [] });
        }

        // Remove duplicates by creating a Set of album names
        const uniqueAlbums = [];
        const albumNames = new Set();

        rows.forEach((row) => {
            if (!albumNames.has(row.albumName)) {
                albumNames.add(row.albumName);
                uniqueAlbums.push({
                    id: row.albumId,
                    name: row.albumName,
                    year: row.albumYear,
                });
            }
        });

        res.json({ albums: uniqueAlbums });
    });
});



// Endpoint to query album tracks
app.get("/album/:id", (req, res) => {
    const albumId = parseInt(req.params.id);

    const sql = `
        SELECT name AS trackName
        FROM Track
        WHERE album_id = ?
    `;

    db.all(sql, [albumId], (err, rows) => {
        if (err) {
            return res.status(500).json({ error: "Database query failed." });
        }

        const tracks = rows.map((row) => row.trackName);
        res.json({ tracks });
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
