const connection = require("../database/connect");

exports.findByEmail = (email, callback) => {
  connection.query(
    "SELECT * FROM managers WHERE email = ?",
    [email],
    (err, results) => {
      if (err) return callback(err);
      callback(null, results[0]);
    }
  );
};


exports.create = (data, callback) => {
  const { name, email, password_hash, location } = data;
  connection.query(
    'INSERT INTO managers (name, email, password_hash, location) VALUES (?, ?, ?, ?)',
    [name, email, password_hash, location],
    callback
  );
};