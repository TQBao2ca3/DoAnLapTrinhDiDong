const db=require('../config/Database');

const ProductModel={
    //hàm truy vấn danh sách Product
    getProductList:async()=>{
        try{
            const [rows]=await db.promise().query('SELECT a.product_id,a.name,b.description,b.image_url,b.price,b.storage,b.colors,a.created_at,b.stock_quantity FROM products a inner join productdetail b on a.product_id=b.product_id');
            return rows;//trả về danh sách sản phẩm
        }catch(error){
            console.error('Error fetching product list: ',error);
            throw error;
        }
    }
}

module.exports= ProductModel;