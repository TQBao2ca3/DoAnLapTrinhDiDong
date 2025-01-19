const mysql=require('mysql2');

//cấu hình kết nối cơ sở dữ liệu
const db=mysql.createConnection({
     host: 'monorail.proxy.rlwy.net',
    port: 33332,
    user: 'root',
    password: 'EdpRdJrtNGOTaGPPydqPCRtbkMNZlNjj',
    database: 'railway'
});

module.exports=db;