const express = require('express');
const userController = require('../controllers/userController');

const router = express.Router();

//Ánh xạ endpoint `/login` tới hàm `login` trong controller
router.post('/login',userController.login);

module.exports = router;
