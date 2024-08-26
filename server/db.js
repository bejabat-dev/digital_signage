const mysql = require('mysql2');
require('dotenv').config(); // Load environment variables from .env file

// Create a MySQL connection using environment variables
const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

// Connect to the database
connection.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    process.exit(1); // Exit the process if there is an error
  }
  console.log('Connected to the MySQL database.');
});

module.exports = connection;
