const db= require('../config/Database');

const User={
    //Hàm tìm user theo username
    findByUsername:(username,callback)=>{
        const query = 'SELECT * FROM Users WHERE username = ?';
        db.query(query,[username],(err,results)=>{
            if(err) return callback(err,null);
            if(results.length===0) return callback(null,null);
            return callback(null,results[0]);
        })
    },
    findByEmail:(email,callback)=>{
        const query = 'SELECT * FROM Users WHERE email = ?';
        db.query(query,[email],(err,results)=>{
            if(err) return callback(err,null);
            if(results.length===0) return callback(null,null);
            return callback(null,results[0]);
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
            if(err) return callback(err, null);
            return callback(null, result);
        });
    },
     // UserModel.js
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
}
};

module.exports= User