const express = require('express');
const app = express();
const port = 3000;
const db = require('./db');
const signageRouter = require('./router');
require('dotenv').config();
const path = require('path');

app.use(express.json());

app.use('/files', express.static(path.join(__dirname, 'uploads')));

app.use('/signage', signageRouter);

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.get('/data', (req, res) => {
  db.query('SELECT * FROM banners', (err, results) => {
    if (err) {
      res.status(500).send('Error fetching data');
      return;
    }
    res.json(results);
  });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server running at http://localhost:${port}`);
});
