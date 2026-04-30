const express = require('express');
const app = express();
const port = 3000;

// Endpoint chính
app.get('/', (req, res) => {
  res.json({ 
    message: 'Hello World from Microservice!',
    status: 'Success',
    version: '1.0.0'
  });
});

// Endpoint để Kubernetes kiểm tra sức khỏe (Health Check)
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

app.listen(port, () => {
  console.log(`Microservice app listening at http://localhost:${port}`);
});