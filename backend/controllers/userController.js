const jwt = require('jsonwebtoken');//import model user
const User=require('../models/UserModel');//import JWT secret key
const { SECRET_KEY } = require('../config/JWTConfig');
const db = require('../config/Database');

//hàm xử lý logic login
// userController.js
exports.login = (req, res) => {
    const {username, password} = req.body;
    
    User.findByUsername(username, (err, user) => {
        if (err) return res.status(500).send({message: 'Server error'});
        if (!user) return res.status(401).send({message: 'User not found'});
    
        if (password !== user.password) {
            return res.status(401).send({message: 'Invalid credentials'});
        }
        
       
        // Bỏ expiresIn để token không hết hạn
        const token = jwt.sign(
            { 
                id: user.id || user.user_id,
                username: user.username 
            },
            SECRET_KEY
            // Bỏ { expiresIn: '1h' } để token không hết hạn
        );

        res.send({
            message: 'Login successful',
            token: token,
            userId: user.id || user.user_id
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
            User.findByPhone(phone, (err, existingPhone) => {
                if (err) return res.status(500).send({ message: 'Server error' });
                if (existingPhone) return res.status(400).send({ message: 'Phone already exists' });
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
    });
};

exports.authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    if (!token) {
        return res.status(401).json({
            success: false,
            message: 'No token provided'
        });
    }

    jwt.verify(token, SECRET_KEY, (err, decoded) => {
        if (err && err.name !== 'TokenExpiredError') { // Chỉ kiểm tra các lỗi khác ngoài hết hạn
            console.log('Token verification error:', err);
            return res.status(403).json({
                success: false,
                message: 'Invalid token'
            });
        }
        
        req.user = {
            id: decoded.id || decoded.user_id,
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
exports.updateProfile = async (req, res) => {

    
  try {
    const userId = req.user.id;
    const { full_name, email, phone, address } = req.body;

    // Validate input if needed
    const updateQuery = `
      UPDATE Users 
      SET 
        full_name = CASE WHEN ? IS NULL THEN full_name ELSE ? END,
        email = CASE WHEN ? IS NULL THEN email ELSE ? END,
        phone = CASE WHEN ? IS NULL THEN phone ELSE ? END,
        address = CASE WHEN ? IS NULL THEN address ELSE ? END
      WHERE user_id = ?
    `;

    const values = [
      full_name, full_name,
      email, email,
      phone, phone,
      address, address,
      userId
    ];

    db.query(updateQuery, values, (err, result) => {
      if (err) {
        console.error('Update error:', err);
        return res.status(500).json({ 
          success: false, 
          message: 'Database update error' 
        });
      }

      // Get updated user info
      User.getProfileById(userId, (profileErr, updatedUser) => {
        if (profileErr || !updatedUser) {
          return res.status(500).json({ 
            success: false, 
            message: 'Error retrieving updated profile' 
          });
        }

        // Return updated user data
        return res.status(200).json({
          success: true,
          data: {
            id: updatedUser.user_id,
            username: updatedUser.username,
            full_name: updatedUser.full_name,
            email: updatedUser.email,
            phone: updatedUser.phone,
            address: updatedUser.address || ''
          }
        });
      });
    });
  } catch (error) {
    console.error('Controller error:', error);
    return res.status(500).json({
      success: false, 
      message: 'Server error'
    });
  }
};

exports.changePassword = async (req, res) => {
    try {
        const userId = req.user.id;
        const { old_password, new_password } = req.body;

        if (!old_password || !new_password) {
            return res.status(400).json({
                success: false,
                message: 'Vui lòng nhập đầy đủ mật khẩu cũ và mới'
            });
        }

        // Kiểm tra mật khẩu cũ
        User.verifyPassword(userId, old_password, (verifyErr, isMatch) => {
            if (verifyErr) {
                return res.status(500).json({
                    success: false,
                    message: 'Lỗi khi kiểm tra mật khẩu'
                });
            }

            if (!isMatch) {
                return res.status(400).json({
                    success: false,
                    message: 'Mật khẩu cũ không chính xác'
                });
            }

            // Nếu mật khẩu cũ chính xác, cập nhật mật khẩu mới
            User.updatePassword(userId, new_password, (updateErr, result) => {
                if (updateErr) {
                    return res.status(500).json({
                        success: false,
                        message: 'Lỗi khi cập nhật mật khẩu'
                    });
                }

                return res.status(200).json({
                    success: true,
                    message: 'Cập nhật mật khẩu thành công'
                });
            });
        });
    } catch (error) {
        console.error('Change password error:', error);
        return res.status(500).json({
            success: false,
            message: 'Lỗi server'
        });
    }
};