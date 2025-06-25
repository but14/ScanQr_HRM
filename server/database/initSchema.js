const connection = require('./connect');

const createManagersTable = `
CREATE TABLE IF NOT EXISTS managers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);`; 

const createEmployeesTable = `
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender ENUM('Nam', 'Nữ', 'Khác'),
    nationality VARCHAR(50),
    id_number VARCHAR(20) UNIQUE NOT NULL,
    date_of_issue DATE,
    place_of_origin VARCHAR(255),
    place_of_residence VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);`;

const createScanLogsTable = `
CREATE TABLE IF NOT EXISTS scan_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    manager_id INT NOT NULL,
    scanned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    scan_notes TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    FOREIGN KEY (manager_id) REFERENCES managers(id)
);`;

connection.query(createManagersTable, (err) => {
    if (err) throw err;
    console.log('Table managers created or already exists.');
    connection.query(createEmployeesTable, (err) => {
        if (err) throw err;
        console.log('Table employees created or already exists.');
        connection.query(createScanLogsTable, (err) => {
            if (err) throw err;
            console.log('Table scan_logs created or already exists.');
            connection.end();
        });
    });
});