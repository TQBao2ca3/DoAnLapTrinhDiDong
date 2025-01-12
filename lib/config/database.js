const mysql=require('mysql2');

//cấu hình kết nối cơ sở dữ liệu
const db=mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'h2db',
    database: 'phoneshop',
});

module.exports=db;