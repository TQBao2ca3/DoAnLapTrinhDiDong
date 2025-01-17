const db= require('../config/Database');

const User={
    //Hàm tìm user theo username
    findByUsername:(username,callback)=>{
        const query = 'SELECT a.*,b.cart_id FROM Users a inner join Cart b on a.user_id=b.user_id WHERE username = ?';
        db.query(query,[username],(err,results)=>{
            if(err) return callback(err,null);
            if(results.length===0) return callback(null,null);
            return callback(null,results[0]);
        })
    }
};

module.exports= User