const CartItemModel=require('../models/CartItemModel');

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
    const { cart_id, product_detail_id, quantity } = req.body;
    try {
        // Kiểm tra xem sản phẩm đã tồn tại trong giỏ hàng chưa
        const existingItem = await CartItemModel.checkExistingItem(cart_id, product_detail_id);
        
        if (existingItem.length > 0) {
            // Nếu đã tồn tại, cập nhật số lượng
            const newQuantity = existingItem[0].quantity + quantity;
            await CartItemModel.updateCartItem(cart_id, product_detail_id, newQuantity);
        } else {
            // Nếu chưa tồn tại, thêm mới
            await CartItemModel.addToCart(cart_id, product_detail_id, quantity);
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
}

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
    // Log để debug
    console.log('Delete request body:', req.body);
    
    const { cart_id, product_detail_id } = req.body;
    
    try {
        await CartItemModel.deleteCartItem(cart_id, product_detail_id);
        
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