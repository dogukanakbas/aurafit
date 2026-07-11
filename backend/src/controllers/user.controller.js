const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Kullanıcı Profilini ve İlişkili Koç/Danışan Verisini Getir
exports.getProfile = async (req, res) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      include: {
        trainer: { select: { id: true, fullName: true, email: true } },
        clients: { select: { id: true, fullName: true, goal: true } },
        measurements: { take: 5, orderBy: { createdAt: 'desc' } }
      }
    });
    if (!user) return res.status(404).json({ success: false, message: 'Kullanıcı bulunamadı.' });

    // Şifreyi gizle
    const { password, ...userProfile } = user;
    res.json({ success: true, data: userProfile });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Biyometrik Demografiyi Güncelle
exports.updateDemographics = async (req, res) => {
  const { fullName, gender, age, height, weight, goal, experienceLevel, trainerId } = req.body;
  try {
    const updatedUser = await prisma.user.update({
      where: { id: req.user.id },
      data: {
        fullName,
        gender,
        age: age ? Number(age) : undefined,
        height: height ? Number(height) : undefined,
        weight: weight ? Number(weight) : undefined,
        goal,
        experienceLevel,
        trainerId
      }
    });
    const { password, ...safeUser } = updatedUser;
    res.json({ success: true, data: safeUser });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
