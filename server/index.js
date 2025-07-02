const express = require("express");
const cors = require("cors");
const app = express();
const port = 5000;

app.use(cors());
app.use(express.json());

//URL
app.use("/api/scan", require("./routes/scanRoutes"));
app.use("/api/auth", require("./routes/authRoutes"));

app.listen(port, "0.0.0.0", () => {
  console.log(`Server đang chạy tại http://0.0.0.0:${port}`);
});
