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


