// File 1: server.js
const express = require('express');
const userRoutes=require('./routes/userRoutes')
const productDetailRoutes= require('./routes/productDetailRoutes')
const productRoutes=require('./routes/productRoute')
const productHomePageRoutes=require('./routes/productHomePageRoute')
const mysql = require('mysql2');
const app = express();
app.use(express.json());


const connection = mysql.createConnection({
    host: 'monorail.proxy.rlwy.net',
    port: 33332,
    user: 'root',
    password: 'EdpRdJrtNGOTaGPPydqPCRtbkMNZlNjj',
    database: 'railway'
});


//định nghĩa route cho user
app.use('/api/user',userRoutes)
//console.log('Routes for /api/user have been defined.'); // Thông báo debug

//định nghĩa route cho productdetail
app.use('/api/productdetail',productDetailRoutes)

//định nghĩa route cho product
app.use('/api/product',productRoutes)

//định nghĩa route cho productHomePage
app.use('/api/productHomePage',productHomePageRoutes)



app.get('/api/orders/:user_id', async (req, res) => {
  try {
    const user_id = req.params.user_id;

    const [orderDetails] = await connection.promise().query(`
      SELECT
        railway.ProductDetail.image_url,
        railway.Products.name,
        railway.OrdersDetail.quantity,
        railway.OrdersDetail.storage,
        railway.OrdersDetail.price,
        SUM(railway.OrdersDetail.quantity * railway.OrdersDetail.price) as TongTien
      FROM railway.Orders
      INNER JOIN railway.OrdersDetail ON railway.Orders.order_id = railway.OrdersDetail.order_id
      INNER JOIN railway.ProductDetail ON railway.OrdersDetail.product_deatail_id = railway.ProductDetail.product_detail_id
      INNER JOIN railway.Products ON railway.ProductDetail.product_id = railway.Products.product_id
      WHERE railway.Orders.user_id = ?
      GROUP BY
        railway.ProductDetail.image_url,
        railway.Products.name,
        railway.OrdersDetail.quantity,
        railway.OrdersDetail.storage,
        railway.OrdersDetail.price
    `, [user_id]);

    // Format dữ liệu trả về
    const formattedDetails = orderDetails.map(detail => ({
      imageUrl: detail.image_url,
      name: detail.name,
      quantity: detail.quantity,
      storage: detail.storage,
      price: parseFloat(detail.price),
      total: parseFloat(detail.TongTien)
    }));

    res.json(formattedDetails);

  } catch (error) {
    console.error('Error fetching order details with images:', error);
    res.status(500).json({ message: 'Lỗi server khi lấy chi tiết đơn hàng với hình ảnh' });
  }
});

// Start Server
app.listen(3000, () => console.log('Server running on port 3000'));
