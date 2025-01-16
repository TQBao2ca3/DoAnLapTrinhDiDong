const ProductDetailModel=require('../models/ProductDetailModel');

//hàm xử lý logic getProductDetail
exports.getProductDetail=(req,res)=>{
    const {id}=req.params;
    
    //gọi model để tìm productdetail theo id
    ProductDetailModel.findByProductID(id,(err,productdetail)=>{
        if(err) return res.status(500).send({message:'Server error'});
        if(!productdetail) return res.status(401).send({message:'Productdetail not found'});
        

        //trả về dữ liệu productdetail nếu thành công
        res.status(200).json({productdetail})
    })
}