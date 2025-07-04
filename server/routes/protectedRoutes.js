const express = require('express');
const router = express.Router();
const { authenticate, authorize } = require('../middleware/auth');

// Route chỉ cho admin
router.get('/admin-data', authenticate, authorize(['admin']), (req, res) => {
  res.json({ message: `Xin chào admin ${req.user.name}` });
});

// Route cho cả admin và hr
router.get('/hr-data', authenticate, authorize(['admin', 'hr']), (req, res) => {
  res.json({ message: `Chào ${req.user.role}, bạn được quyền truy cập` });
});

module.exports = router;
