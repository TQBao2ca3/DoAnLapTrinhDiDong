const mysql=require('mysql2');

//cấu hình kết nối cơ sở dữ liệu
const db=mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '123456',
    database: 'phoneshop',
});

module.exports=db;