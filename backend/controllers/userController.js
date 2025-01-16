const jwt = require('jsonwebtoken');//import model user
const User=require('../models/UserModel');//import JWT secret key
const {SECRET_KEY} = require('../config/JWTConfig')

//hàm xử lý logic login
exports.login = (req, res) => {
    const {username, password} = req.body;
    
    User.findByUsername(username, (err, user) => {
        if (err) return res.status(500).send({message: 'Server error'});
        if (!user) return res.status(401).send({message: 'User not found'});
    
        if (password !== user.password) {
            return res.status(401).send({message: 'Invalid credentials'});
        }

        // Print out user object to verify
        console.log('User object:', user);

        const token = jwt.sign(
            { 
                id: user.id || user.user_id,  // Try multiple possible ID keys
                username: user.username 
            },
            SECRET_KEY,
            { expiresIn: '1h' }
        );

        console.log('Generated Token Details:', {
            id: user.id || user.user_id,
            username: user.username
        });

        res.send({
            message: 'Login successful',
            token: token,
            userId: user.id || user.user_id  // Send back user ID for verification
        });
    });
};

exports.register = (req, res) => {
    const { username, password, email, full_name, phone, address } = req.body;
    console.log("register");

    // Kiểm tra xem username đã tồn tại chưa
    User.findByUsername(username, (err, existingUser) => {
        if (err) return res.status(500).send({ message: 'Server error' });
        if (existingUser) return res.status(400).send({ message: 'Username already exists' });

        // Kiểm tra email đã tồn tại chưa
        User.findByEmail(email, (err, existingEmail) => {
            if (err) return res.status(500).send({ message: 'Server error' });
            if (existingEmail) return res.status(400).send({ message: 'Email already exists' });

            // Tạo user mới
            const newUser = {
                username: username,
                password: password, // Nên mã hóa password trước khi lưu
                email: email,
                full_name: full_name,
                phone: phone,
                address: address,
                created_at: new Date()
            };

            // Lưu user vào database
            User.create(newUser, (err, user) => {
                if (err) return res.status(500).send({ message: 'Error creating user' });

                // Tạo JWT token cho user mới
                const token = jwt.sign(
                    { id: user.id, username: user.username },
                    SECRET_KEY,
                    { expiresIn: '1h' }
                );

                // Trả về thông báo thành công và token
                res.status(201).send({
                    message: 'Registration successful',
                    token: token
                });
            });
        });
    });
};

exports.authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    console.log('Full Authorization Header:', req.headers['authorization']);
    console.log('Extracted Token:', token);
    
    if (!token) {
        return res.status(401).json({
            success: false,
            message: 'No token provided'
        });
    }

    jwt.verify(token, SECRET_KEY, (err, decoded) => {
        if (err) {
            console.log('Token verification error:', err);
            return res.status(403).json({
                success: false,
                message: 'Invalid token'
            });
        }
        
        console.log('Fully Decoded Token:', decoded);
        
        // IMPORTANT: Ensure this matches your token structure
        req.user = {
            id: decoded.id || decoded.user_id, // Try multiple possible ID keys
            username: decoded.username
        };
        
        next();
    });
};
exports.getProfile = (req, res) => {
    // Log all request details
    console.log('Request Headers:', req.headers);
    console.log('Decoded User:', req.user);

    // Lấy user ID từ token đã decode
    const userId = req.user?.id || req.user?.user_id;
    
    console.log('Attempting to get profile for userId:', userId);

    if (!userId) {
        return res.status(400).json({
            success: false,
            message: 'User ID not found in token'
        });
    }

    User.getProfileById(userId, (err, user) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).json({
                success: false,
                message: 'Database error'
            });
        }

        if (!user) {
            console.error('No user found with ID:', userId);
            return res.status(404).json({
                success: false,
                message: 'User not found'
            });
        }

        // Đảm bảo format response đúng
        res.status(200).json({
            success: true,
            data: {
                id: user.id || user.user_id,
                username: user.username,
                full_name: user.full_name,
                email: user.email,
                phone: user.phone,
                address: user.address || ''
            }
        });
    });
};