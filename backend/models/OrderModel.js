const db = require('../config/Database');

const OrderModel = {
    createOrder: async (orderData) => {
        try {
            const [result] = await db.promise().query(
                `INSERT INTO Orders (
                    user_id, 
                    shipping_address,
                    status_order,
                    status_payment,
                    payment_method
                ) VALUES (?, ?, ?, ?, ?)`,
                [
                    orderData.user_id,
                    orderData.shipping_address,
                    orderData.status_order,
                    orderData.status_payment,
                    orderData.payment_method
                ]
            );
            return result;
        } catch (error) {
            console.error('Error in createOrder:', error);
            throw error;
        }
    },

    createOrderDetail: async (detailData) => {
        try {
            const [result] = await db.promise().query(
                `INSERT INTO OrdersDetail (
                    order_id,
                    product_detail_id,
                    quantity,
                    price
                ) VALUES (?, ?, ?, ?)`,
                [
                    detailData.order_id,
                    detailData.product_detail_id,
                    detailData.quantity,
                    detailData.price
                ]
            );
            return result;
        } catch (error) {
            console.error('Error in createOrderDetail:', error);
            throw error;
        }
    },

    getOrdersByUserId: async (userId) => {
        try {
            const [rows] = await db.promise().query(
                'SELECT * FROM Orders WHERE user_id = ? ORDER BY order_date DESC',
                [userId]
            );
            return rows;
        } catch (error) {
            throw error;
        }
    },

    getOrderDetailById: async (orderId) => {
        try {
            const [rows] = await db.promise().query(
                `SELECT 
                    od.*,
                    pd.product_id,
                    pd.storage,
                    pd.colors,
                    pd.price,
                    pd.image_url,
                    pd.description
                FROM OrdersDetail od
                JOIN ProductDetail pd ON od.product_detail_id = pd.product_detail_id
                WHERE od.order_id = ?`,
                [orderId]
            );
            return rows;
        } catch (error) {
            throw error;
        }
    }
};

module.exports = OrderModel;