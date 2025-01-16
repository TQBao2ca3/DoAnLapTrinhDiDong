const express=require('express');
const productHomePageController=require('../controllers/productHomePageController');

const router = express.Router();

//ánh xạ endpoint `/getProductHomePageList` tới hàm getProductHomeList trong controller
router.get('/getProductHomePageList',productHomePageController.getProductHomePageList);

module.exports=router;