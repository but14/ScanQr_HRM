const express = require('express');
const router = express.Router();
const scanController = require('../controllers/scanController');

router.post('/create', scanController.createScan);
router.get('/get', scanController.getScans);

module.exports = router;