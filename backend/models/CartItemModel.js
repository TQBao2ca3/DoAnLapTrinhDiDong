const db=require('../config/Database');

const CartItemModel = {
    getCartItemList: async (user_id) => {
        try {
            const [rows] = await db.promise().query(
                `SELECT a.cart_id, a.user_id, b.cart_item_id, b.product_detail_id, 
                        b.quantity, c.product_id, c.storage, c.price, 
                        c.image_url, c.description, c.colors 
                 FROM Cart a 
                 INNER JOIN CartItem b ON a.cart_id = b.cart_id 
                 INNER JOIN ProductDetail c ON b.product_detail_id = c.product_detail_id 
                 WHERE a.cart_id = ?`,
                [user_id]
            );
            return rows;
        } catch (e) {
            console.error('Error fetching cartItem list: ', e);
            throw e;
        }
    },
    checkExistingItem: async (cart_id, product_detail_id) => {
        try {
            const [rows] = await db.promise().query(
                'SELECT * FROM CartItem WHERE cart_id = ? AND product_detail_id = ?',
                [cart_id, product_detail_id]
            );
            return rows;
        } catch (e) {
            console.error('Error checking existing item: ', e);
            throw e;
        }
    },

    addToCart: async (cart_id, product_detail_id, quantity) => {
        try {
            const [result] = await db.promise().query(
                'INSERT INTO CartItem (cart_id, product_detail_id, quantity) VALUES (?, ?, ?)',
                [cart_id, product_detail_id, quantity]
            );
            return result;
        } catch (e) {
            console.error('Error adding to cart: ', e);
            throw e;
        }
    },

    updateCartItem: async (cart_id, product_detail_id, quantity) => {
        try {
            const [result] = await db.promise().query(
                'UPDATE CartItem SET quantity = ? WHERE cart_id = ? AND product_detail_id = ?',
                [quantity, cart_id, product_detail_id]
            );
            return result;
        } catch (e) {
            console.error('Error updating cart item: ', e);
            throw e;
        }
    },
    updateQuantity: async (cart_id, product_detail_id, quantity) => {
        try {
            const [result] = await db.promise().query(
                'UPDATE CartItem SET quantity = ? WHERE cart_id = ? AND product_detail_id = ?',
                [quantity, cart_id, product_detail_id]
            );
            return result;
        } catch (e) {
            console.error('Error updating quantity: ', e);
            throw e;
        }
    },
    // Thêm phương thức mới cho việc xóa
    deleteCartItem: async (cart_id, product_detail_id) => {
        try {
            // Log để debug
            console.log('Deleting cart item with:', {cart_id, product_detail_id});
            
            const [result] = await db.promise().query(
                'DELETE FROM CartItem WHERE cart_id = ? AND product_detail_id = ?',
                [cart_id, product_detail_id]
            );
            
            // Log kết quả
            console.log('Delete result:', result);
            
            return result;
        } catch (e) {
            console.error('Error in deleteCartItem:', e);
            throw e;
        }
    }
};

module.exports=CartItemModel;