const CartItemModel=require('../models/CartItemModel');
const db = require('../config/Database');
//hàm xử lý logic getCartItemList
exports.getCartItemList = async (req, res) => {
    const {id} = req.params;
    try {
        const cartItemList = await CartItemModel.getCartItemList(id);
        if (!cartItemList || cartItemList.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'CartItem not found'
            });
        }
        
        res.status(200).json({
            success: true,
            data: cartItemList
        });
    } catch (e) {
        console.log('Error fetching cartItem list: ', e);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch cartItem list'
        });
    }
}

exports.addToCart = async (req, res) => {
    const { cart_id, product_detail_id, quantity, color, storage, price } = req.body;
    try {
        // Check if item exists with same color and storage
        const existingItem = await CartItemModel.checkExistingItem(
            cart_id, 
            product_detail_id, 
            color, 
            storage
        );
        
        if (existingItem.length > 0) {
            // If exists with same color and storage, update quantity
            const newQuantity = existingItem[0].quantity + quantity;
            await CartItemModel.updateQuantity(cart_id, product_detail_id, newQuantity);
        } else {
            // If not exists or different color/storage, add new item
            await CartItemModel.addToCart(
                cart_id, 
                product_detail_id, 
                quantity, 
                color, 
                storage, 
                price
            );
        }
        
        res.status(200).json({
            success: true,
            message: 'Product added to cart successfully'
        });
    } catch (e) {
        console.error('Error adding to cart: ', e);
        res.status(500).json({
            success: false,
            message: 'Failed to add product to cart'
        });
    }
};
exports.updateQuantity = async (req, res) => {
    const { cart_id, product_detail_id, quantity } = req.body;
    console.log('Updating quantity:', {cart_id, product_detail_id, quantity}); // Debug log
    
    try {
        await CartItemModel.updateQuantity(cart_id, product_detail_id, quantity);
        
        res.status(200).json({
            success: true,
            message: 'Quantity updated successfully'
        });
    } catch (e) {
        console.error('Error updating quantity:', e);
        res.status(500).json({
            success: false,
            message: 'Failed to update quantity'
        });
    }
};

exports.deleteCartItem = async (req, res) => {
    console.log('Delete request body:', req.body);
    
    const { cart_id, product_detail_id, color, storage } = req.body;
    
    try {
        await CartItemModel.deleteCartItem(cart_id, product_detail_id, color, storage);
        
        res.status(200).json({
            success: true,
            message: 'Item deleted successfully'
        });
    } catch (e) {
        console.error('Error deleting cart item:', e);
        res.status(500).json({
            success: false,
            message: 'Failed to delete item from cart'
        });
    }
};
exports.getOrCreateCart = async (req, res) => {
    const userId = req.params.userId;
    try {
        // Kiểm tra xem user đã có cart chưa
        const [existingCart] = await db.promise().query(
            'SELECT cart_id FROM Cart WHERE user_id = ?', 
            [userId]
        );

        let cartId;
        if (existingCart.length > 0) {
            cartId = existingCart[0].cart_id;
        } else {
            const [result] = await db.promise().query(
                'INSERT INTO Cart (user_id) VALUES (?)', 
                [userId]
            );
            cartId = result.insertId;
        }

        res.status(200).json({
            success: true,
            cart_id: cartId
        });
    } catch (e) {
        console.error('Error getting/creating cart:', e);
        res.status(500).json({
            success: false,
            message: 'Failed to get/create cart'
        });
    }
};

exports.clearCart = async (req, res) => {
    const { cart_id } = req.body;
    try {
        await CartItemModel.clearCart(cart_id);
        res.status(200).json({
            success: true,
            message: 'Cart cleared successfully'
        });
    } catch (e) {
        console.error('Error clearing cart:', e);
        res.status(500).json({
            success: false,
            message: 'Failed to clear cart'
        });
    }
};