const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  if (!authHeader) {
    return res.status(401).json({ success: false, message: 'Yetkilendirme tokenı eksik.' });
  }

  const token = authHeader.split(' ')[1];
  if (!token) {
    return res.status(401).json({ success: false, message: 'Geçersiz token formatı.' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'aura_super_secret_jwt_key_2026');
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(403).json({ success: false, message: 'Geçersiz veya süresi dolmuş token.' });
  }
};

const requireRole = (...roles) => {
  return (req, res, next) => {
    if (!req.user || !roles.includes(req.user.role)) {
      return res.status(403).json({ success: false, message: 'Bu işlem için yetkiniz bulunmuyor.' });
    }
    next();
  };
};

module.exports = {
  verifyToken,
  requireRole
};
