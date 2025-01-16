const ProductModel=require('../controllers/productHomePageController');
const ProductHomePageModel = require('../models/ProductHomePageModel');

//hàm xử lý logic getProductHomePageList
exports.getProductHomePageList= async(req,res)=>{
    try{
        //gọi hàm getProductHomePageList từ model để lấy danh sách sản phẩm
        const productHomePageList=await ProductHomePageModel.getProductHomePageList();

        //trả về danh sách sản phẩm dưới dạng json
        res.status(200).json({
            success:true,
            data:productHomePageList,
        });
    }catch(error){
        console.log('Error fetching product list: ',error);
        //trả về lỗi nếu có vấn đề xảy ra
        res.status(500).json({
            success:false,
            message:'Failed to fetch product list',
        })
    }
}