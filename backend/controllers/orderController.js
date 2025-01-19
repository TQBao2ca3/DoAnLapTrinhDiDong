const OrderModel = require('../models/OrderModel');

exports.createOrder = async (req, res) => {
    const {
        user_id,
        shipping_address,
        payment_method,
        status_order,
        status_payment,
        order_details
    } = req.body;

    try {
        // Tạo order mới
        const orderResult = await OrderModel.createOrder({
            user_id,
            shipping_address,
            status_order,
            status_payment,
            payment_method
        });

        const order_id = orderResult.insertId;

        // Tạo order details
        await Promise.all(order_details.map(detail => 
            OrderModel.createOrderDetail({
                order_id,
                product_detail_id: detail.product_detail_id,
                quantity: detail.quantity,
                price: detail.price
            })
        ));

        res.status(200).json({
            success: true,
            message: 'Order created successfully',
            data: {
                order_id
            }
        });
    } catch (error) {
        console.error('Error creating order:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to create order'
        });
    }
};

exports.getOrders = async (req, res) => {
    const { userId } = req.params;
    try {
        const orders = await OrderModel.getOrdersByUserId(userId);
        res.status(200).json({
            success: true,
            data: orders
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Failed to fetch orders'
        });
    }
};

exports.getOrderDetail = async (req, res) => {
    const { orderId } = req.params;
    try {
        const orderDetails = await OrderModel.getOrderDetailById(orderId);
        res.status(200).json({
            success: true,
            data: orderDetails
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Failed to fetch order details'
        });
    }
};

// Trong orderController.js thêm:

exports.getOrdersByUserId = async (req, res) => {
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
  
      // ... phần code xử lý response giữ nguyên
    } catch (error) {
      // ... phần code xử lý error giữ nguyên
    }
  };
  
  exports.updateOrderStatus = async (req, res) => {
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
  };