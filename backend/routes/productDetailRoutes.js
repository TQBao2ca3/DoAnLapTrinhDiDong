const express= require('express');
const productDetailController= require('../controllers/productDetailController');

const router= express.Router();

//ánh xạ endpoint `/getProductDetail` tới hàm getProductDetail trong controller
router.get('/getProductDetail/:id',productDetailController.getProductDetail);

module.exports= router;