require("dotenv").config(); // Load biến môi trường từ .env

const express = require("express");
const cors = require("cors");
const app = express();

const db = require("./connect"); // Kết nối MySQL

const port = process.env.PORT || 3000;
// không cần gán host cố định, hosting sẽ xử lý
// chỉ cần app.listen(port)

app.use(cors());
app.use(express.json());

// Routes
app.use("/api/scan", require("./routes/scanRoutes"));
app.use("/api/auth", require("./routes/authRoutes"));
app.use("/api/protected", require("./routes/protectedRoutes"));

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: "Not found" });
});

// Start server
app.listen(port, () => {
  console.log(`🚀 Server đang chạy trên port ${port}`);
});
