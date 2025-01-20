const db= require('../config/Database');

const User = {
    //Hàm tìm user theo username
    findByUsername: (username, callback) => {
        const query = 'SELECT * FROM Users WHERE username = ?';
        db.query(query, [username], (err, results) => {
            if (err) return callback(err, null);
            if (results.length === 0) return callback(null, null);
            return callback(null, results[0]);
        })
    },
    findByEmail: (email, callback) => {
        const query = 'SELECT * FROM Users WHERE email = ?';
        db.query(query, [email], (err, results) => {
            if (err) return callback(err, null);
            if (results.length === 0) return callback(null, null);
            return callback(null, results[0]);
        })
    },
    findByEmailUpdate: (email, callback) => {
        const query = 'SELECT * FROM Users WHERE email = ?';
        db.query(query, [email], (err, results) => {
            if (err) return callback(err, null);
            if (results.length >= 1) return callback(null, null);
            return callback(null, results[0]);
        })
    },
    findByPhone: (phone, callback) => {
        const query = 'SELECT * FROM Users WHERE phone = ?';
        db.query(query, [phone], (err, results) => {
            if (err) return callback(err, null);
            if (results.length === 0) return callback(null, null);
            return callback(null, results[0]);
        })
    },
    create: (userData, callback) => {
        const query = `
            INSERT INTO Users (username, password, email, full_name, phone) 
            VALUES (?, ?, ?, ?, ?)
        `;
        const values = [
            userData.username,
            userData.password,
            userData.email,
            userData.full_name,
            userData.phone
        ];
        
        db.query(query, values, (err, result) => {
            if (err) return callback(err, null);
            return callback(null, result);
        });
    },
    getProfileById: (userId, callback) => {
        const query = `
        SELECT user_id, username, full_name, email, phone, address
        FROM Users 
        WHERE user_id = ?
    `;
    
        db.query(query, [userId], (err, results) => {
            if (err) {
                console.error('Database error:', err);
                return callback(err, null);
            }
            if (results.length === 0) {
                return callback(null, null);
            }
            return callback(null, results[0]);
        });

        // In UserModel.js - Add this new method
        updateProfile: (userId, userData, callback) => {
            const query = `
        UPDATE Users 
        SET 
            full_name = COALESCE(?, full_name),
            email = COALESCE(?, email),
            phone = COALESCE(?, phone),
            address = COALESCE(?, address)
        WHERE user_id = ?
    `;

            const values = [
                userData.full_name || null,
                userData.email || null,
                userData.phone || null,
                userData.address || null,
                userId
            ];

            db.query(query, values, (err, result) => {
                if (err) return callback(err, null);
                return callback(null, result);
            });
        }
    },
    updatePassword: (userId, newPassword, callback) => {
        const query = `
            UPDATE Users 
            SET password = ?
            WHERE user_id = ?
        `;
        
        db.query(query, [newPassword, userId], (err, result) => {
            if (err) {
                console.error('Update password error:', err);
                return callback(err, null);
            }
            return callback(null, result);
        });
    },

    // Thêm phương thức kiểm tra mật khẩu cũ
    verifyPassword: (userId, oldPassword, callback) => {
        const query = `
            SELECT password 
            FROM Users 
            WHERE user_id = ? AND password = ?
        `;
        
        db.query(query, [userId, oldPassword], (err, results) => {
            if (err) {
                console.error('Verify password error:', err);
                return callback(err, null);
            }
            // Trả về true nếu mật khẩu khớp, false nếu không khớp
            return callback(null, results.length > 0);
        });
    }
};

module.exports= User