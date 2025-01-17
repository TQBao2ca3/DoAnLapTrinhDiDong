// orderController.js
exports.createOrder = async (req, res) => {
    const {
        user_id,
        shipping_address,
        payment_method,
        order_details
    } = req.body;

    try {
        // 1. Thêm vào bảng Orders
        const orderQuery = `
            INSERT INTO Orders 
            (user_id, status_order, shipping_address, order_date, 
             status_payment, payment_method, tracking_number)
            VALUES (?, 'Pending', ?, NOW(), 'Pending', ?, ?)
        `;
        
        const orderResult = await db.query(orderQuery, [
            user_id,
            shipping_address,
            payment_method,
            `TN${Date.now()}`
        ]);

        // 2. Lấy order_id cao nhất (vừa được thêm vào)
        const getLastOrderQuery = `
            SELECT order_id FROM Orders 
            ORDER BY order_id DESC LIMIT 1
        `;
        const lastOrderResult = await db.query(getLastOrderQuery);
        const lastOrderId = lastOrderResult[0].order_id;

        // 3. Thêm vào bảng OrdersDetail với order_id vừa lấy được
        for (const detail of order_details) {
            await db.query(`
                INSERT INTO OrdersDetail 
                (order_id, product_detail_id, quantity, price, storage, color)
                VALUES (?, ?, ?, ?, ?, ?)
            `, [
                lastOrderId,
                detail.product_detail_id,
                detail.quantity,
                detail.price,
                detail.storage,
                detail.color
            ]);
        }

        res.status(201).json({ 
            message: 'Order created successfully',
            orderId: lastOrderId
        });
    } catch (error) {
        console.error('Error creating order:', error);
        res.status(500).json({ message: 'Error creating order' });
    }
};