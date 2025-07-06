const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const managerModel = require("../models/managerModel");

require("dotenv").config();
const JWT_SECRET = process.env.JWT_SECRET_KEY;

// =========== MANAGER LOGIN ===========
exports.login = (req, res) => {
  const { email, password } = req.body;
  console.log(`[LOGIN] Nhận yêu cầu đăng nhập với email: ${email}`);

  managerModel.findByEmail(email, (err, manager) => {
    if (err) {
      console.error("[LOGIN] Lỗi server khi tìm manager:", err);
      return res.status(500).json({ error: "Lỗi server" });
    }
    if (!manager) {
      console.warn(`[LOGIN] Tài khoản không tồn tại: ${email}`);
      return res.status(401).json({ error: "Tài khoản không tồn tại" });
    }

    // So sánh mật khẩu
    bcrypt.compare(password, manager.password_hash, (err, isMatch) => {
      if (err) {
        console.error("[LOGIN] Lỗi xác thực mật khẩu:", err);
        return res.status(500).json({ error: "Lỗi xác thực" });
      }
      if (!isMatch) {
        console.warn(`[LOGIN] Sai mật khẩu cho tài khoản: ${email}`);
        return res.status(401).json({ error: "Sai mật khẩu" });
      }

      // ✅ Tạo JWT có role
      const token = jwt.sign(
        {
          id: manager.id,
          email: manager.email,
          name: manager.name,
          role: manager.role, 
        },
        JWT_SECRET,
        { expiresIn: "1d" }
      );

      console.log(`[LOGIN] Đăng nhập thành công: ${email}`);

      res.json({
        token,
        manager: {
          id: manager.id,
          name: manager.name,
          email: manager.email,
          location: manager.location,
          role: manager.role, // 🟢 Trả về role cho client luôn
        },
      });
    });
  });
};

// =========== CREATE MANAGER ===========
exports.register = (req, res) => {
  const { name, email, password, location, role } = req.body; // thêm role
  console.log(`[REGISTER] Nhận yêu cầu tạo tài khoản cho email: ${email}`);

  if (!name || !email || !password || !location) {
    console.warn("[REGISTER] Thiếu thông tin đăng ký:", {
      name,
      email,
      location,
    });
    return res.status(400).json({ error: "Thiếu thông tin" });
  }

  // Kiểm tra email đã tồn tại chưa
  managerModel.findByEmail(email, (err, manager) => {
    if (err) {
      console.error("[REGISTER] Lỗi server khi kiểm tra email:", err);
      return res.status(500).json({ error: "Lỗi server" });
    }
    if (manager) {
      console.warn(`[REGISTER] Email đã tồn tại: ${email}`);
      return res.status(409).json({ error: "Email đã tồn tại" });
    }

    // Hash mật khẩu
    const bcrypt = require("bcrypt");
    bcrypt.hash(password, 10, (err, hash) => {
      if (err) {
        console.error("[REGISTER] Lỗi mã hóa mật khẩu:", err);
        return res.status(500).json({ error: "Lỗi mã hóa mật khẩu" });
      }

      // Gán role mặc định nếu không truyền
      const managerData = {
        name,
        email,
        password_hash: hash,
        location,
        role: role || "admin", // mặc định là 'staff'
      };

      managerModel.create(managerData, (err, result) => {
        if (err) {
          console.error("[REGISTER] Lỗi tạo tài khoản:", err);
          return res.status(500).json({ error: "Lỗi tạo tài khoản" });
        }
        console.log(
          `[REGISTER] Tạo tài khoản thành công cho email: ${email}, id: ${result.insertId}`
        );
        res.json({
          message: "Tạo tài khoản thành công",
          managerId: result.insertId,
        });
      });
    });
  });
};
