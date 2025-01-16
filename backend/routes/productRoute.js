const express=require('express');
const productController=require('../controllers/productController');

const router= express.Router();

//ánh xạ endpoint `/getProductList` tới hàm getProductList trong controller
router.get('/getProductList',productController.getProductList);

module.exports=router;