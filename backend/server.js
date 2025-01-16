// File 1: server.js
const express = require('express');
const userRoutes=require('./routes/userRoutes')
const productDetailRoutes= require('./routes/productDetailRoutes')
const productRoutes=require('./routes/productRoute')
const productHomePageRoutes=require('./routes/productHomePageRoute')
const app = express();
app.use(express.json());

//định nghĩa route cho user
app.use('/api/user',userRoutes)
//console.log('Routes for /api/user have been defined.'); // Thông báo debug

//định nghĩa route cho productdetail
app.use('/api/productdetail',productDetailRoutes)

//định nghĩa route cho product
app.use('/api/product',productRoutes)

//định nghĩa route cho productHomePage
app.use('/api/productHomePage',productHomePageRoutes)

// Start Server
app.listen(3000, () => console.log('Server running on port 3000'));
