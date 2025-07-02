require("dotenv").config(); // Load biến môi trường từ .env

const express = require("express");
const cors = require("cors");
const app = express();

// Lấy PORT và HOST từ biến môi trường
const port = process.env.PORT || 3000;
const host = process.env.HOST || "127.0.0.1";

app.use(cors());
app.use(express.json());

// Route
app.use("/api/scan", require("./routes/scanRoutes"));
app.use("/api/auth", require("./routes/authRoutes"));

// Khởi động server
app.listen(port, host, () => {
  console.log(`🚀 Server đang chạy tại http://${host}:${port}`);
});
