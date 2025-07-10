import express from "express";
import cors from "cors";
import dotenv from "dotenv";
//configuration
const app = express();
app.use(express.json());
app.use(cors());
import pkg from 'pg';
const { Pool } = pkg;
dotenv.config(); 
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: { rejectUnauthorized: false }
  });
const ALLOWED_TABLES = {
  onwatch:         'onwatch',
  onwatch_honeywell_s70:    'onwatch_honeywell_s70',
  onwatch_s70_nogpu:     'onwatch_s70_nogpu',
  onwatch_jetsons: 'onwatch_small_jetsons',
  onaccess_ipcctv: 'onaccess_ipcctv',
};
app.get('/api/options', async (req, res) => {
  try {
    const options = {};

    for (const [key, tableName] of Object.entries(ALLOWED_TABLES)) {
      const { rows } = await pool.query(
        `SELECT DISTINCT max_streams
         FROM ${tableName}
         ORDER BY max_streams`
      );
      options[key] = rows.map(r => r.max_streams);
    }

    res.json(options);
  } catch (err) {
    console.error('Error fetching options:', err);
    res.status(500).json({ error: 'Could not load options' });
  }
});
app.get('/api/size', async (req, res) => {
  const { assumption, streams } = req.query;
  const streamCount = parseInt(streams, 10);

  // Validate assumption
  if (!ALLOWED_TABLES[assumption]) {
    return res.status(400).json({ error: 'Invalid assumption type' });
  }

  // Validate streams
  if (Number.isNaN(streamCount) || streamCount < 0) {
    return res.status(400).json({ error: 'Invalid stream count' });
  }

  const tableName = ALLOWED_TABLES[assumption];
  const sql = `
    SELECT *
    FROM ${tableName}
    WHERE max_streams >= $1
    ORDER BY max_streams
    LIMIT 1;
  `;

  try {
    const { rows } = await pool.query(sql, [streamCount]);
    if (rows.length === 0) {
      return res.status(404).json({ error: 'No matching configuration' });
    }
    res.json(rows[0]);
  } catch (err) {
    console.error('Database query error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});
// Example route
app.get("/", (req, res) => {
    res.send("Server is running!");
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});

