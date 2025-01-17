const express = require('express');
const cartItemController=require('../controllers/cartItemController');

const router=express.Router();

//ánh xạ endpoint `/getCartItemList` tới hàm getCartItemList trong controller
router.get('/getCartItemList/:id', cartItemController.getCartItemList);

module.exports=router;