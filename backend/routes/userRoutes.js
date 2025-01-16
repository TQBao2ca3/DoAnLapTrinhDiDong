const express = require('express');
const userController = require('../controllers/UserController');

const router = express.Router();


//Ánh xạ endpoint `/login` tới hàm `login` trong controller
router.post('/login', userController.login);

router.post('/register', userController.register);

// userRoutes.js
router.get('/profile', userController.authenticateToken, userController.getProfile);

module.exports = router;
