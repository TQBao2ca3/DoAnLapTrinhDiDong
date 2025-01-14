const db=require('../config/database');

const ProductDetail={
    //hàm truy vấn ProductDetail theo id
    findByProductID:(id,callback)=>{
        const query = 'SELECT * FROM productdetail WHERE product_id=? ;';
        db.query(query,[id],(err,results)=>{
            if(err) return callback(err,null);
            if(results.length===0) return callback(null,null);
            return callback(null,results); 
        })
    }
}

module.exports=ProductDetail