const db=require('../config/Database');

const ProductHomePageModel={
    //hàm truy vấn danh sách Product
    getProductHomePageList:async()=>{
        try{
            const [rows]=await db.promise().query('SELECT distinct(a.product_id),a.name,b.image_url,b.description,a.created_at FROM Products a inner join ProductDetail b on a.product_id=b.product_id');
            return rows;
        }
        catch(error){
            console.error('Error fetching product list: ',error);
            throw error;
        }
    }
}

module.exports=ProductHomePageModel