const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());


//URL
app.use('/api/scan', require('./routes/scanRoutes'));
app.use('/api/auth', require('./routes/authRoutes'));

app.listen(port, () => {
  console.log(`Server đang chạy tại http://localhost:${port}`);
});