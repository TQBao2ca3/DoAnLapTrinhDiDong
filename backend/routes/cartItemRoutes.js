const express = require('express');
const cartItemController=require('../controllers/cartItemController');

const router=express.Router();

//ánh xạ endpoint `/getCartItemList` tới hàm getCartItemList trong controller
router.get('/getCartItemList/:id', cartItemController.getCartItemList);

// Thêm route mới
router.post('/addToCart', cartItemController.addToCart);

// Thêm route mới để cập nhật số lượng
router.put('/updateQuantity', cartItemController.updateQuantity);

// Thêm route để xóa item
router.delete('/deleteCartItem', cartItemController.deleteCartItem);


module.exports=router;