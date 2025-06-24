const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());
app.use('/api/scan', require('./routes/scanRoutes'));

app.listen(port, () => {
  console.log(`Server đang chạy tại http://localhost:${port}`);
});