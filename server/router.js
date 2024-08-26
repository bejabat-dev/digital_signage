// signageRouter.js
const express = require('express');
const multer = require('multer');
const path = require('path');
const router = express.Router();
const db = require('./db');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, './uploads')); // Adjust path if necessary
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const basename = path.basename(file.originalname, ext);
    cb(null, `${basename}${ext}`);
  },
});

const upload = multer({ storage });

router.post('/upload', upload.single('image'), (req, res) => {
  const { name, type, url } = req.body;

  if (!req.file) {
    return res.status(400).send('No file uploaded.');
  }

  // SQL query to check if the type already exists
  const checkQuery = 'SELECT COUNT(*) AS count FROM banners WHERE type = ?';
  db.query(checkQuery, [type], (err, results) => {
    if (err) {
      return res.status(500).send('Database query error.');
    }

    const exists = results[0].count > 0;
    let query, queryParams;

    if (exists) {
      // Update existing record
      query = 'UPDATE banners SET url = ? WHERE type = ?';
      queryParams = [url, type];
    } else {
      // Insert new record
      query = 'INSERT INTO banners (name, type, url) VALUES (?,?, ?)';
      queryParams = [name, type, url];
    }

    db.query(query, queryParams, (err) => {
      if (err) {
        return res.status(500).send('Database operation error.');
      }

      res.send('Image uploaded and database updated successfully.');
    });
  });
});

router.get('/get_banners', (req, res) => {
  db.query('SELECT * FROM banners', (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).send('Error!');
    }
    res.json(results);
  });

});

router.post('/text', (req, res) => {
  const { type, url } = req.body;
  
  // Ensure 'type' and 'url' are provided
  if (!type || !url) {
    return res.status(400).json({ error: 'Type and URL are required' });
  }

  db.query('UPDATE banners SET url = ? WHERE type = ?', [url, type], (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
    res.json({ message: 'Update successful' });
  });
});



module.exports = router;
