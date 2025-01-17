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
                 WHERE a.user_id = ?`,
                [user_id]
            );
            return rows;
        } catch (e) {
            console.error('Error fetching cartItem list: ', e);
            throw e;
        }
    }
};

module.exports=CartItemModel;