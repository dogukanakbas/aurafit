const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Yeni Vücut & Kardiyovasküler Ölçümü Ekle
exports.createMeasurement = async (req, res) => {
  const {
    waist, chest, arm, leg, hip,
    fatRatio, muscleRatio,
    restingHeartRate, glucoseLevel, bloodPressure
  } = req.body;

  try {
    const measurement = await prisma.measurement.create({
      data: {
        userId: req.user.id,
        waist: waist ? Number(waist) : null,
        chest: chest ? Number(chest) : null,
        arm: arm ? Number(arm) : null,
        leg: leg ? Number(leg) : null,
        hip: hip ? Number(hip) : null,
        fatRatio: fatRatio ? Number(fatRatio) : null,
        muscleRatio: muscleRatio ? Number(muscleRatio) : null,
        restingHeartRate: restingHeartRate ? Number(restingHeartRate) : null,
        glucoseLevel: glucoseLevel ? Number(glucoseLevel) : null,
        bloodPressure
      }
    });

    res.status(201).json({ success: true, data: measurement });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Kullanıcının Tüm Ölçüm Geçmişini Listele
exports.getMeasurements = async (req, res) => {
  try {
    const list = await prisma.measurement.findMany({
      where: { userId: req.user.id },
      orderBy: { createdAt: 'desc' }
    });
    res.json({ success: true, data: list });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
