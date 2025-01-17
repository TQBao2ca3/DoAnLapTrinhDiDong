const express = require('express');
const orderController = require('../controllers/orderController');

const router = express.Router();

router.post('/create', orderController.createOrder);
router.get('/:user_id', orderController.getOrdersByUserId);
router.get('/detail/:orderId', orderController.getOrderDetail);
router.put('/update-status/:orderId', orderController.updateOrderStatus);

module.exports = router;