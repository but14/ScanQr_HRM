const mysql = require('mysql2');

// Tạo kết nối
const connection = mysql.createConnection({
  host: 'localhost',      
  user: 'root',          
  password: '', 
  database: 'hrm'  
});

// Kết nối tới MySQL
connection.connect((err) => {
  if (err) {
    console.error('Kết nối MySQL thất bại:', err);
    return;
  }
  console.log('Kết nối MySQL thành công!');
});

module.exports = connection;
