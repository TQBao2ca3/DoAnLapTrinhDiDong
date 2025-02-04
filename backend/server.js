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

// API đăng nhập



app.get('/api/ordersStatus/:user_id', async (req, res) => {
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
app.put('/api/ordersStatus/update-status/:orderId', async (req, res) => {
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

//admin
// API lấy chi tiết đơn hàng
app.get('/api/ordersStatus/:user_id/order/:order_id/details', async (req, res) => {
  try {
    const user_id = req.params.user_id;
    const order_id = req.params.order_id;

    const [orderDetails] = await connection.promise().query(`
      SELECT
        railway.Products.name,
        railway.OrdersDetail.quantity,
        railway.OrdersDetail.order_id,
        railway.OrdersDetail.storage,
        railway.OrdersDetail.price,
        SUM(railway.OrdersDetail.quantity * railway.OrdersDetail.price) as TongTien
      FROM railway.Orders
      INNER JOIN railway.OrdersDetail ON railway.Orders.order_id = railway.OrdersDetail.order_id
      INNER JOIN railway.ProductDetail ON railway.OrdersDetail.product_detail_id = railway.ProductDetail.product_detail_id
      INNER JOIN railway.Products ON railway.ProductDetail.product_id = railway.Products.product_id
      WHERE railway.Orders.user_id = ? AND railway.OrdersDetail.order_id = ?
      GROUP BY
        railway.Products.name,
        railway.OrdersDetail.quantity,
        railway.OrdersDetail.order_id,
        railway.OrdersDetail.storage,
        railway.OrdersDetail.price
    `, [user_id, order_id]);

    // Format dữ liệu trả về
    const formattedDetails = orderDetails.map(detail => ({
      name: detail.name,
      quantity: detail.quantity,
      order_id: detail.order_id,
      storage: detail.storage,
      price: parseFloat(detail.price),
      total: parseFloat(detail.TongTien)
    }));

    res.json(formattedDetails);

  } catch (error) {
    console.error('Error fetching order details:', error);
    res.status(500).json({ message: 'Lỗi server khi lấy chi tiết đơn hàng' });
  }
});

app.post('/api/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    const [rows] = await connection.promise().query(
      'SELECT * FROM Users WHERE username = ? AND password = ?',
      [username, password]
    );

    if (rows.length === 0) {
      return res.status(401).json({ message: 'Users hoặc mật khẩu không đúng' });
    }

    const user = rows[0];

    res.json({
      message: 'Đăng nhập thành công',
      user: {
        username: user.username,
        email: user.email,
        phone: user.phone
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: 'Lỗi server' });
  }
});

// API cập nhật thông tin user
app.put('/api/users/update', async (req, res) => {
  const { username, email, phone } = req.body;

  try {
    const [result] = await connection.promise().query(
      'UPDATE Users SET email = ?, phone = ? WHERE username = ?',
      [email, phone, username]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }

    res.json({
      message: 'Cập nhật thông tin thành công',
      user: { username, email, phone }
    });
  } catch (error) {
    console.error('Update error:', error);
    res.status(500).json({ message: 'Lỗi server' });
  }
});

app.put('/api/ordersStatus/update/:user_id', async (req, res) => {
  const user_id = req.params.user_id;
  const { status, order_id } = req.body;  // Lấy cả status và order_id từ request body

  try {
    const [result] = await connection.promise().query(
      'UPDATE Orders SET status_order = ? WHERE user_id = ? AND order_id = ?',
      [status, user_id, order_id]  // Truyền status, user_id và order_id vào query
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: `Không tìm thấy đơn hàng cho người dùng ${user_id}`,
        order_id: order_id
      });
    }

    res.json({
      message: `Cập nhật trạng thái thành công cho đơn hàng ${order_id}`,
      status: status
    });
  } catch (error) {
    console.error('Update error:', error);
    res.status(500).json({
      message: `Lỗi server khi cập nhật đơn hàng`,
      error: error.message
    });
  }
});

// API lấy danh sách đơn hàng
app.get('/api/ordersStatus', async (req, res) => {
  try {
    const [orders] = await connection.promise().query(`
      SELECT
        a.user_id,
        GROUP_CONCAT(DISTINCT a.order_id) as order_ids,
        GROUP_CONCAT(b.full_name) as customerNames,
        GROUP_CONCAT(b.phone) as phones,
        GROUP_CONCAT(DISTINCT d.image_url) as image_urls,
        GROUP_CONCAT(DISTINCT a.status_order) as statuses,
        GROUP_CONCAT(DISTINCT a.order_date) as dates,
        SUM(c.quantity * c.price) as total
      FROM railway.Orders a
      INNER JOIN railway.Users b ON a.user_id = b.user_id
      INNER JOIN railway.OrdersDetail c ON a.order_id = c.order_id
      INNER JOIN railway.ProductDetail d ON c.product_detail_id = d.product_detail_id
      GROUP BY
        a.user_id,
        a.order_id
    `);

    // Log toàn bộ dữ liệu gốc
    console.log('Raw Orders Data:', JSON.stringify(orders, null, 2));

    // Log số lượng đơn hàng
    console.log('Number of Orders:', orders.length);

    // Log chi tiết từng đơn hàng
    orders.forEach((order, index) => {
      console.log(`Order ${index + 1}:`);
      console.log('User ID:', order.user_id);
      console.log('Order IDs:', order.order_ids);
      console.log('Customer Names:', order.customerNames);
      console.log('Phones:', order.phones);
      console.log('Image URLs:', order.image_urls);
      console.log('Statuses:', order.statuses);
      console.log('Dates:', order.dates);
      console.log('Total:', order.total);
      console.log('---');
    });

    // Format dữ liệu trả về
    const formattedOrders = orders.map(order => ({
      id: order.user_id,
      order_ids: order.order_ids.split(','),
      customerName: order.customerNames.split(',')[0],
      phone: order.phones.split(',')[0],
      image_url: order.image_urls.split(','),
      status: order.statuses.split(',').map(Number),
      date: order.dates.split(',').map(date => date.split('T')[0]),
      total: parseFloat(order.total)
    }));

    // Log dữ liệu sau khi format
    console.log('Formatted Orders:', JSON.stringify(formattedOrders, null, 2));

    res.json(formattedOrders);

  } catch (error) {
    console.error('Error fetching orders:', error);
    res.status(500).json({ message: 'Lỗi server khi lấy danh sách đơn hàng' });
  }
});


// Start Server
app.listen(3000, () => console.log('Server running on port 3000'));