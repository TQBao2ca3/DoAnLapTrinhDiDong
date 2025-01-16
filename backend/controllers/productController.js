const ProductModel=require('../models/ProductModel');

//hàm xử lý logic getProductList
exports.getProductList= async (req,res)=>{
    try{
        //gọi hàm getProductList từ model để lấy danh sách sản phẩm
        const productList= await ProductModel.getProductList();

        //trả về danh sách sản phẩm dưới dạng json
        res.status(200).json({
            success:true,
            data:productList,
        });
    }catch(error){
        console.log('Error fetching product list:', error);

        //trả về lỗi nếu có vấn đề xảy ra
        res.status(500).json({
            success:false,
            message:'Failed to fetch product list',
        })
    }
}