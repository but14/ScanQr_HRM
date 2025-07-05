const mysql = require("mysql2");
require("dotenv").config(); // Load .env

// Tạo pool
const pool = mysql.createPool({
  connectionLimit: 10, // tuỳ chỉnh theo nhu cầu
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
});

// Kiểm tra kết nối
pool.getConnection((err, connection) => {
  if (err) {
    console.error("❌ Kết nối MySQL thất bại:", err);
  } else {
    console.log("✅ Kết nối MySQL thành công!");
    connection.release(); // trả lại pool
  }
});

module.exports = pool;
