const db=require('../config/Database');

const CartItemModel = {
    // Trong CartItemModel.js
    checkExistingItem: async (cart_id, product_detail_id, color, storage) => {
        try {
            const [rows] = await db.promise().query(
                'SELECT * FROM CartItem WHERE cart_id = ? AND product_detail_id = ? AND colors = ? AND storage = ?',
                [cart_id, product_detail_id, color, storage]
            );
            return rows;
        } catch (e) {
            console.error('Error checking existing item: ', e);
            throw e;
        }
    },
    
    addToCart: async (cart_id, product_detail_id, quantity, color, storage, price) => {
        try {
            const [result] = await db.promise().query(
                'INSERT INTO CartItem (cart_id, product_detail_id, quantity, colors, storage, price) VALUES (?, ?, ?, ?, ?, ?)',
                [cart_id, product_detail_id, quantity, color, storage, price]
            );
            return result;
        } catch (e) {
            console.error('Error adding to cart: ', e);
            throw e;
        }
    },
    
    getCartItemList: async (user_id) => {
        try {
            const [rows] = await db.promise().query(
                `SELECT 
                    ci.cart_item_id,
                    ci.cart_id,
                    ci.product_detail_id,
                    ci.quantity,
                    ci.colors,
                    ci.storage,
                    ci.price,
                    pd.image_url,
                    p.name as description
                 FROM Cart c 
                 INNER JOIN CartItem ci ON c.cart_id = ci.cart_id
                 INNER JOIN ProductDetail pd ON ci.product_detail_id = pd.product_detail_id
                 INNER JOIN Products p ON pd.product_id = p.product_id
                 WHERE c.user_id = ?`,
                [user_id]
            );
            return rows;
        } catch (e) {
            console.error('Error fetching cartItem list: ', e);
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
    updateQuantity: async (cart_id, product_detail_id, quantity, color, storage) => {
        try {
            const [result] = await db.promise().query(
                'UPDATE CartItem SET quantity = ? WHERE cart_id = ? AND product_detail_id = ? AND colors = ? AND storage = ?',
                [quantity, cart_id, product_detail_id, color, storage]
            );
            return result;
        } catch (e) {
            console.error('Error updating quantity: ', e);
            throw e;
        }
    },
    // Thêm phương thức mới cho việc xóa
    deleteCartItem: async (cart_id, product_detail_id, color, storage) => {
        try {
            // Log để debug
            console.log('Deleting cart item with:', {cart_id, product_detail_id, color, storage});
            
            const [result] = await db.promise().query(
                'DELETE FROM CartItem WHERE cart_id = ? AND product_detail_id = ? AND colors = ? AND storage = ?',
                [cart_id, product_detail_id, color, storage]
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