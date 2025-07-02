const mysql = require("mysql2");
require("dotenv").config(); // Load biến môi trường từ file .env

// Tạo kết nối
const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
});

// Kết nối tới MySQL
connection.connect((err) => {
  if (err) {
    console.error("❌ Kết nối MySQL thất bại:", err);
  } else {
    console.log("✅ Kết nối MySQL thành công!");
  }
});

module.exports = connection;
