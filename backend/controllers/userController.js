const jwt = require('jsonwebtoken');//import model user
const User=require('../models/UserModel');//import JWT secret key
const {SECRET_KEY} = require('../config/jwtConfig')

//hàm xử lý logic login
exports.login=(req,res)=>{
    const {username,password}=req.body;
    console.log("login");
    //gọi model để tìm user theo username
    User.findByUsername(username,(err,user)=>{
        if(err) return res.status(500).send({message:'Server error'});
        if(!user) return res.status(401).send({message:'User not found'});
    
        //kiểm tra password
        if(password!==user.password){
            return res.status(401).send({message:'Invalid credentials'});
        }

        //tạo JWT token
        const token=jwt.sign({id:user.id,username:user.username},SECRET_KEY,{expiresIn:'1h'});
        res.send({message:'Login successful',token});
    });
};