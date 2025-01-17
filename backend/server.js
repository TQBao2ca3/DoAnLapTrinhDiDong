const express = require('express');
const userRoutes = require('./routes/userRoutes')
const productDetailRoutes = require('./routes/productDetailRoutes')
const productRoutes = require('./routes/productRoute')
const productHomePageRoutes = require('./routes/productHomePageRoute')
const cartItemRoutes = require('./routes/cartItemRoutes')
const orderRoutes = require('./routes/orderRoutes')

const app = express();
app.use(express.json());

const connection = require('./config/Database');

//định nghĩa route cho user
app.use('/api/user', userRoutes)

//định nghĩa route cho productdetail
app.use('/api/productdetail', productDetailRoutes)

//định nghĩa route cho product
app.use('/api/product', productRoutes)

//định nghĩa route cho productHomePage
app.use('/api/productHomePage', productHomePageRoutes)

//định nghĩa route cho cartItem
app.use('/api/cart', cartItemRoutes)

//định nghĩa route cho order
app.use('/api/orders', orderRoutes)

// API endpoint để lấy orders theo user_id
app.get('/api/orders/:user_id', async (req, res) => {
  try {
    // ... code xử lý lấy orders theo user_id (giữ nguyên code cũ)
  } catch (error) {
    // ... code xử lý error (giữ nguyên code cũ)
  }
});

// API endpoint để cập nhật status
app.put('/api/orders/update-status/:orderId', async (req, res) => {
  try {
    // ... code xử lý update status (giữ nguyên code cũ)
  } catch (error) {
    // ... code xử lý error (giữ nguyên code cũ)
  }
});

// Start Server
app.listen(3000, () => console.log('Server running on port 3000'));