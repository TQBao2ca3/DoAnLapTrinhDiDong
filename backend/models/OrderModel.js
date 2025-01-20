const db = require('../config/Database');

class OrderModel {
    static async createOrder(orderData) {
        try {
            const [result] = await db.promise().query(
                `INSERT INTO Orders (
                    user_id, 
                    shipping_address,
                    status_order,
                    status_payment,
                    payment_method,
                    payment_date
                ) VALUES (?, ?, ?, ?, ?, ?)`,
                [
                    orderData.user_id,
                    orderData.shipping_address,
                    0,  // status_order mặc định là 0
                    orderData.payment_method === 1 ? 1 : 0,  // status_payment
                    orderData.payment_method,
                    orderData.payment_method === 1 ? new Date() : null
                ]
            );
            return result;
        } catch (error) {
            console.error('Error in createOrder:', error);
            throw error;
        }
    }

    static async createOrderDetail(detailData) {
        try {
            const [result] = await db.promise().query(
                `INSERT INTO OrdersDetail (
                    order_id,
                    product_detail_id,
                    quantity,
                    price,
                    storage,
                    color
                ) VALUES (?, ?, ?, ?, ?, ?)`,
                [
                    detailData.order_id,
                    detailData.product_detail_id,
                    detailData.quantity,
                    detailData.price,
                    detailData.storage,
                    detailData.color
                ]
            );
            return result;
        } catch (error) {
            console.error('Error in createOrderDetail:', error);
            throw error;
        }
    }

    static async getOrdersByUserId(userId) {
        try {
            const [rows] = await db.promise().query(
                'SELECT * FROM Orders WHERE user_id = ? ORDER BY order_date DESC',
                [userId]
            );
            return rows;
        } catch (error) {
            throw error;
        }
    }

    static async getOrderDetailById(orderId) {
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
    static async updateOrderStatus(orderId, status) {
        try {
            const [result] = await db.promise().query(
                'UPDATE Orders SET status_order = ? WHERE order_id = ?',
                [status, orderId]
            );
            return result;
        } catch (error) {
            console.error('Error updating order status:', error);
            throw error;
        }
    }
}

module.exports = OrderModel;