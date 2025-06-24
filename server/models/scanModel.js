const connection = require('../database/connect');

exports.create = (data, callback) => {
  const { name, cccd, dob, address, scanTime } = data;
  connection.query(
    'INSERT INTO scans (name, cccd, dob, address, scan_time) VALUES (?, ?, ?, ?, ?)',
    [name, cccd, dob, address, scanTime],
    callback
  );
};

exports.getAll = (date, callback) => {
  let sql = 'SELECT * FROM scans';
  let params = [];
  if (date) {
    sql += ' WHERE DATE(scan_time) = ?';
    params.push(date);
  }
  connection.query(sql, params, callback);
};