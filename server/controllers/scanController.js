const scanModel = require('../models/scanModel');

exports.createScan = (req, res) => {
  scanModel.create(req.body, (err, result) => {
    if (err) return res.status(500).json({ error: 'Lỗi lưu dữ liệu' });
    res.json({ success: true, id: result.insertId });
  });
};

exports.getScans = (req, res) => {
  scanModel.getAll(req.query.date, (err, results) => {
    if (err) return res.status(500).json({ error: 'Lỗi truy vấn' });
    res.json(results);
  });
};