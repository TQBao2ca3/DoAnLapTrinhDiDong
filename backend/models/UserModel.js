const db= require('../config/Database');

const User={
    //Hàm tìm user theo username
    findByUsername:(username,callback)=>{
        const query = 'SELECT * FROM users WHERE username =?';
        db.query(query,[username],(err,results)=>{
            if(err) return callback(err,null);
            if(results.length===0) return callback(null,null);
            return callback(null,results[0]);
        })
    }
};

module.exports= User