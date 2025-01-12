// File 1: server.js
const express = require('express');
const userRoutes=require('./routes/userRoutes')

const app = express();
app.use(express.json());

//định nghĩa route cho user
app.use('/api/user',userRoutes)
//console.log('Routes for /api/user have been defined.'); // Thông báo debug

// Start Server
app.listen(3000, () => console.log('Server running on port 3000'));