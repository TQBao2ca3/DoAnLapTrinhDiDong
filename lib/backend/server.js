// File 1: server.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const mysql = require('mysql2');

const app = express();
app.use(bodyParser.json());
app.use(cors());

// MySQL connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '123456',
  database: 'phoneshop',
});

// Secret Key for JWT
const SECRET_KEY = 'your_jwt_secret_key';

// Login API
app.post('/api/login', (req, res) => {
  const { username, password } = req.body;
  const query = 'SELECT * FROM users WHERE username = ?';
  db.query(query, [username], (err, results) => {
    if (err) return res.status(500).send({ message: 'Server error' });
    if (results.length === 0) return res.status(401).send({ message: 'User not found' });

    const user = results[0];
    // So sánh mật khẩu từ client với mật khẩu trong cơ sở dữ liệu
    if (password !== user.password) {

      return res.status(401).send({ message: 'Invalid credentials' });
    }
      

    const token = jwt.sign({ id: user.id, email: user.email }, SECRET_KEY, { expiresIn: '1h' });
    res.send({ message: 'Login successful', token });
  });
});

// Start Server
app.listen(3000, () => console.log('Server running on port 3000'));
