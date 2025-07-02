const connection = require("../database/connect");

// =========== SCAN CCCD ===========
exports.scanCCCD = (req, res) => {
  const {
    full_name,
    date_of_birth,
    gender,
    nationality,
    id_number,
    date_of_issue,
    place_of_origin,
    place_of_residence,
    manager_id, // truyền từ client hoặc lấy từ token
    scan_notes, // tùy chọn
  } = req.body;

  console.log(`[SCAN] Nhận yêu cầu quét CCCD: ${id_number}`);

  if (!id_number || !full_name || !manager_id) {
    console.warn("[SCAN] Thiếu thông tin bắt buộc:", {
      id_number,
      full_name,
      manager_id,
    });
    return res.status(400).json({ error: "Thiếu thông tin bắt buộc" });
  }

  // Lấy location của manager
  connection.query(
    "SELECT location FROM managers WHERE id = ?",
    [manager_id],
    (err, managerResults) => {
      if (err) {
        console.error("[SCAN] Lỗi truy vấn location manager:", err);
        return res.status(500).json({ error: "Lỗi server" });
      }
      if (managerResults.length === 0) {
        console.warn(`[SCAN] Không tìm thấy manager với id: ${manager_id}`);
        return res.status(404).json({ error: "Không tìm thấy manager" });
      }
      const scan_location = managerResults[0].location;

      // Kiểm tra nhân viên đã tồn tại chưa
      connection.query(
        "SELECT * FROM employees WHERE id_number = ?",
        [id_number],
        (err, results) => {
          if (err) {
            console.error("[SCAN] Lỗi truy vấn:", err);
            return res.status(500).json({ error: "Lỗi server" });
          }
          if (results.length > 0) {
            console.log(`[SCAN] Nhân viên đã tồn tại: ${id_number}`);
            // Ghi log quét
            const employeeId = results[0].id;
            insertScanLog(employeeId, manager_id, scan_location, scan_notes);
            return res.json({
              employee: results[0],
              message: "Nhân viên đã tồn tại",
            });
          }

          // Nếu chưa có, tạo mới nhân viên
          const insertQuery = `
            INSERT INTO employees
            (full_name, date_of_birth, gender, nationality, id_number, date_of_issue, place_of_origin, place_of_residence, manager_id)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
          `;
          connection.query(
            insertQuery,
            [
              full_name,
              date_of_birth,
              gender,
              nationality,
              id_number,
              date_of_issue,
              place_of_origin,
              place_of_residence,
              manager_id,
            ],
            (err, result) => {
              if (err) {
                console.error("[SCAN] Lỗi tạo mới nhân viên:", err);
                return res.status(500).json({ error: "Lỗi tạo mới nhân viên" });
              }
              console.log(
                `[SCAN] Đã tạo mới nhân viên: ${id_number} (ID: ${result.insertId})`
              );
              // Lấy lại thông tin nhân viên vừa tạo
              connection.query(
                "SELECT * FROM employees WHERE id = ?",
                [result.insertId],
                (err, results) => {
                  if (err) {
                    console.error(
                      "[SCAN] Lỗi lấy lại thông tin nhân viên:",
                      err
                    );
                    return res
                      .status(500)
                      .json({ error: "Lỗi lấy lại thông tin nhân viên" });
                  }
                  // Ghi log quét
                  insertScanLog(
                    result.insertId,
                    manager_id,
                    scan_location,
                    scan_notes
                  );
                  res.json({
                    employee: results[0],
                    message: "Đã tạo mới nhân viên",
                  });
                }
              );
            }
          );
        }
      );
    }
  );

  // Hàm ghi log vào bảng scan_logs
  function insertScanLog(employeeId, managerId, location, notes) {
    if (!employeeId || !managerId) {
      console.warn("[SCAN_LOG] Thiếu employeeId hoặc managerId khi ghi log.");
      return;
    }
    connection.query(
      `INSERT INTO scan_logs (employee_id, manager_id, scan_location, scan_notes)
       VALUES (?, ?, ?, ?)`,
      [employeeId, managerId, location || null, notes || null],
      (err, result) => {
        if (err) {
          console.error("[SCAN_LOG] Lỗi ghi log quét:", err);
        } else {
          console.log(
            `[SCAN_LOG] Đã ghi log quét: employee_id=${employeeId}, manager_id=${managerId}, scan_location=${location}`
          );
        }
      }
    );
  }
};

// =========== GET ALL SCANS ===========
exports.getAllEmployees = (req, res) => {
  const connection = require("../database/connect");
  connection.query("SELECT * FROM employees", (err, results) => {
    if (err) {
      console.error("[EMPLOYEE] Lỗi truy vấn tất cả nhân viên:", err);
      return res.status(500).json({ error: "Lỗi server" });
    }
    res.json({ employees: results });
  });
};

//=========== GET EMPLOYEE by Date ===========
exports.getEmployeesByDate = (req, res) => {
  const connection = require("../database/connect");
  const { date } = req.query; // YYYY-MM-DD
  if (!date) {
    return res.status(400).json({ error: "Thiếu ngày" });
  }
  connection.query(
    "SELECT * FROM employees WHERE DATE(created_at) = ?",
    [date],
    (err, results) => {
      if (err) {
        console.error("[EMPLOYEE] Lỗi truy vấn theo ngày:", err);
        return res.status(500).json({ error: "Lỗi server" });
      }
      res.json({ employees: results });
    }
  );
};

// GET employees by manager
exports.getEmployeesByManager = (req, res) => {
  const connection = require("../database/connect");
  const { manager_id } = req.query;
  if (!manager_id) {
    return res.status(400).json({ error: "Thiếu manager_id" });
  }
  connection.query(
    "SELECT * FROM employees WHERE manager_id = ?",
    [manager_id],
    (err, results) => {
      if (err) {
        console.error("[EMPLOYEE] Lỗi truy vấn theo manager:", err);
        return res.status(500).json({ error: "Lỗi server" });
      }
      res.json({ employees: results });
    }
  );
};
