const mysql = require('mysql2');

// Tạo kết nối
const connection = mysql.createConnection({
  host: 'localhost',      // Đổi thành host của bạn nếu khác
  user: 'root',           // Đổi thành user của bạn
  password: '', // Đổi thành password của bạn
  database: ''  // Đổi thành tên database của bạn
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
