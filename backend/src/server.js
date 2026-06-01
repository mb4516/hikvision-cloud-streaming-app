require('dotenv').config();
const express = require('express');
const cors = require('cors');
const axios = require('axios');

const app = express();
app.use(cors());
app.use(express.json());

const MEDIA_MTX_URL = 'http://mediamtx:8889';

// In-memory storage (use MongoDB/PostgreSQL in production)
const cameras = new Map();

// Add new Hikvision camera
app.post('/api/cameras', async (req, res) => {
  const { name, rtspUrl, username, password } = req.body;

  const pathName = `cam_${Date.now()}`;

  try {
    // Add stream to MediaMTX
    await axios.post(`${MEDIA_MTX_URL}/v3/paths/add/${pathName}`, {
      source: rtspUrl,
      sourceOnDemand: true,
      sourceUsername: username,
      sourcePassword: password
    });

    cameras.set(pathName, { name, pathName, rtspUrl });

    res.json({
      success: true,
      streamUrl: `http://your-domain:8888/${pathName}/index.m3u8`,
      pathName
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get all cameras
app.get('/api/cameras', (req, res) => {
  res.json(Array.from(cameras.values()));
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Backend running on port ${PORT}`);
});
