const express = require("express");
const router = express.Router();
const scanController = require("../controllers/scanController");

// router.post("/create", scanController.createScan);
// router.get("/get", scanController.getScans);
router.post("/scan-cccd", scanController.scanCCCD);
router.get("/all-employees", scanController.getAllEmployees);
router.get("/employees-by-date", scanController.getEmployeesByDate);

module.exports = router;
