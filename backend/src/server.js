const app = require('./app');

const PORT = process.env.PORT || 5001;

app.listen(PORT, () => {
  console.log(`🚀 AURA API Server çalışıyor -> http://localhost:${PORT}`);
});
