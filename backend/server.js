// File 1: server.js
const express = require('express');
const userRoutes=require('./routes/userRoutes')
const productDetailRoutes= require('./routes/productDetailRoutes')
const productRoutes=require('./routes/productRoute')
const productHomePageRoutes=require('./routes/productHomePageRoute')
const cartItemRoutes=require('./routes/cartItemRoutes')
// const mysql = require('mysql2');
const app = express();
app.use(express.json());


const connection = require('./config/Database');

//định nghĩa route cho user
app.use('/api/user',userRoutes)
//console.log('Routes for /api/user have been defined.'); // Thông báo debug

//định nghĩa route cho productdetail
app.use('/api/productdetail',productDetailRoutes)

//định nghĩa route cho product
app.use('/api/product',productRoutes)

//định nghĩa route cho productHomePage
app.use('/api/productHomePage', productHomePageRoutes)

//định nghĩa route cho cartItem
app.use('/api/cart',cartItemRoutes)



app.get('/api/orders/:user_id', async (req, res) => {
  try {
    const user_id = req.params.user_id;

    // Validate user_id
    if (!user_id || isNaN(user_id)) {
      return res.status(400).json({
        message: 'ID người dùng không hợp lệ'
      });
    }

    // Kiểm tra user có tồn tại không
    const [userExists] = await connection.promise().query(
      'SELECT user_id FROM railway.Users WHERE user_id = ?',
      [user_id]
    );

    if (userExists.length === 0) {
      return res.status(404).json({
        message: 'Không tìm thấy người dùng'
      });
    }

    // Query lấy chi tiết đơn hàng
    const [orderDetails] = await connection.promise().query(`
      SELECT
        railway.Orders.order_id,
        railway.ProductDetail.image_url,
        railway.Products.name,
        railway.OrdersDetail.quantity,
        railway.OrdersDetail.storage,
        railway.OrdersDetail.price,
        railway.Orders.status_order,
        SUM(railway.OrdersDetail.quantity * railway.OrdersDetail.price) as TongTien
      FROM railway.Orders
      INNER JOIN railway.OrdersDetail
        ON railway.Orders.order_id = railway.OrdersDetail.order_id
      INNER JOIN railway.ProductDetail
        ON railway.OrdersDetail.product_detail_id = railway.ProductDetail.product_detail_id
      INNER JOIN railway.Products
        ON railway.ProductDetail.product_id = railway.Products.product_id
      WHERE railway.Orders.user_id = ?
      GROUP BY
        railway.Orders.order_id,
        railway.ProductDetail.image_url,
        railway.Products.name,
        railway.OrdersDetail.quantity,
        railway.OrdersDetail.storage,
        railway.OrdersDetail.price,
        railway.Orders.status_order
    `, [user_id]);

    // Kiểm tra có đơn hàng không
    if (orderDetails.length === 0) {
      return res.status(200).json([]);  // Trả về mảng rỗng nếu không có đơn hàng
    }

    // Format dữ liệu trả về
    const formattedDetails = orderDetails.map(detail => ({
      orderId: detail.order_id,
      imageUrl: detail.image_url,
      name: detail.name,
      quantity: detail.quantity,
      storage: detail.storage,
      price: parseFloat(detail.price),
      total: parseFloat(detail.TongTien),
      status: detail.status_order
    }));

    res.json(formattedDetails);

  } catch (error) {
    // Log lỗi chi tiết để debug
    console.error('Database error:', error);

    // Xác định loại lỗi và trả về response phù hợp
    if (error.code === 'ER_NO_SUCH_TABLE') {
      res.status(500).json({
        message: 'Lỗi cấu trúc database'
      });
    } else if (error.code === 'PROTOCOL_CONNECTION_LOST') {
      res.status(500).json({
        message: 'Mất kết nối database'
      });
    } else {
      res.status(500).json({
        message: 'Lỗi server khi lấy chi tiết đơn hàng',
        error: process.env.NODE_ENV === 'development' ? error.message : undefined
      });
    }
  }
});

// API endpoint để cập nhật status
app.put('/api/orders/update-status/:orderId', async (req, res) => {
  try {
    const orderId = req.params.orderId;
    const { status } = req.body;

    await connection.promise().query(
      'UPDATE railway.Orders SET status_order = ? WHERE order_id = ?',
      [status, orderId]
    );

    res.json({ message: 'Cập nhật trạng thái thành công' });
  } catch (error) {
    console.error('Error updating order status:', error);
    res.status(500).json({ message: 'Lỗi khi cập nhật trạng thái đơn hàng' });
  }
});

// Start Server
app.listen(3000, () => console.log('Server running on port 3000'));
