// controller.js
const jwt = require('jsonwebtoken');
const User = require('../models/UserModel');
const {SECRET_KEY} = require('../config/JWTConfig');

exports.login = (req, res) => {
    const {username, password} = req.body;
    console.log("login");
    
    User.findByUsername(username, (err, user) => {
        if(err) return res.status(500).send({message: 'Server error'});
        if(!user) return res.status(401).send({message: 'User not found'});
        
        if(password !== user.password) {
            return res.status(401).send({message: 'Invalid credentials'});
        }
        
        // Tạo token với user_id và cart_id
        const token = jwt.sign(
            {
                id: user.user_id,
                username: user.username,
                cart_id: user.cart_id
            },
            SECRET_KEY,
            {expiresIn: '1h'}
        );

        // Trả về token, user_id và cart_id
        res.send({
            message: 'Login successful',
            token,
            userId: user.user_id,
            cartId: user.cart_id
        });
    });
};