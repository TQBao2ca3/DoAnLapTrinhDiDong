const db=require('../config/Database');

const CartItemModel = {
    getCartItemList: async (user_id) => {
        try {
            const [rows] = await db.promise().query(
                `SELECT ci.cart_item_id, ci.cart_id, ci.product_detail_id, ci.quantity,
                        pd.storage, pd.price, pd.image_url, pd.description, pd.colors 
                 FROM Cart c
                 INNER JOIN CartItem ci ON c.cart_id = ci.cart_id
                 INNER JOIN ProductDetail pd ON ci.product_detail_id = pd.product_detail_id
                 WHERE c.user_id = ?`,
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
    },
    clearCart: async (cartId) => {
        try {
            const [result] = await db.promise().query(
                'DELETE FROM CartItem WHERE cart_id = ?',
                [cartId]
            );
            return result;
        } catch (e) {
            console.error('Error in clearCart:', e);
            throw e;
        }
    },
    getCartByUserId: async (userId) => {
        try {
            const [rows] = await db.promise().query(
                'SELECT cart_id FROM Cart WHERE user_id = ?',
                [userId]
            );
            return rows[0];
        } catch (e) {
            console.error('Error getting cart:', e);
            throw e;
        }
    },

    createCart: async (userId) => {
        try {
            const [result] = await db.promise().query(
                'INSERT INTO Cart (user_id) VALUES (?)',
                [userId]
            );
            return { cart_id: result.insertId };
        } catch (e) {
            console.error('Error creating cart:', e);
            throw e;
        }
    }
};


module.exports=CartItemModel;