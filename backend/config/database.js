const mysql = require('mysql2');

const db = mysql.createConnection({
    host: 'monorail.proxy.rlwy.net',
    port: 33332,
    user: 'root',
    password: ' ',
    database: 'railway'
});

db.connect((err) => {
    if (err) {
        console.error('Database connection error:', err);
        return;
    }
    console.log('Connected to database successfully');

    // Test query
    db.query('SHOW TABLES', (err, results) => {
        if (err) {
            console.error('Test query error:', err);
            return;
        }
        console.log('Available tables:', results);
    });
});

module.exports = db;