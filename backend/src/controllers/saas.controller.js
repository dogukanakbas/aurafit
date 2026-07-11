const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

/**
 * 1. COACH PROFILE & WHITE-LABEL ÖZELLEŞTİRME API
 */
exports.upsertCoachProfile = async (req, res) => {
  try {
    const {
      userId,
      packageType,
      subscriptionEndDate,
      commissionRate,
      fixedMonthlyFee,
      referralCode,
      referredByCoachId,
      customAppName,
      customLogoUrl,
      primaryColor,
    } = req.body;

    const profile = await prisma.coachProfile.upsert({
      where: { userId },
      update: {
        packageType,
        subscriptionEndDate,
        commissionRate,
        fixedMonthlyFee,
        customAppName,
        customLogoUrl,
        primaryColor,
      },
      create: {
        userId,
        packageType: packageType || 'BASIC',
        subscriptionEndDate,
        commissionRate: commissionRate || 15.0,
        fixedMonthlyFee,
        referralCode,
        referredByCoachId,
        customAppName,
        customLogoUrl,
        primaryColor,
      },
    });

    res.status(200).json({ success: true, data: profile });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * 2. STUDENT PROFILE API
 */
exports.createStudentProfile = async (req, res) => {
  try {
    const { userId, coachId, subscriptionEndDate, gender, age, height, weight, goal } = req.body;
    const student = await prisma.studentProfile.create({
      data: {
        userId,
        coachId,
        subscriptionEndDate,
        gender,
        age,
        height,
        weight,
        goal,
      },
    });
    res.status(201).json({ success: true, data: student });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * 3. WORKOUT TEMPLATE API (isTemplate desteği)
 */
exports.createWorkoutTemplate = async (req, res) => {
  try {
    const { coachId, studentId, isTemplate, dayNumber, title, exerciseDetails } = req.body;
    const workout = await prisma.workout.create({
      data: {
        coachId,
        studentId,
        isTemplate: isTemplate ?? false,
        dayNumber,
        title,
        exerciseDetails: typeof exerciseDetails === 'object' ? JSON.stringify(exerciseDetails) : exerciseDetails,
      },
    });
    res.status(201).json({ success: true, data: workout });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

exports.getCoachWorkoutTemplates = async (req, res) => {
  try {
    const { coachId } = req.params;
    const templates = await prisma.workout.findMany({
      where: { coachId, isTemplate: true },
    });
    res.status(200).json({ success: true, data: templates });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * 4. DIET TEMPLATE API (isTemplate desteği)
 */
exports.createDietTemplate = async (req, res) => {
  try {
    const { coachId, studentId, isTemplate, dailyCalories, proteinGrams, carbGrams, fatGrams, mealDetails } = req.body;
    const diet = await prisma.diet.create({
      data: {
        coachId,
        studentId,
        isTemplate: isTemplate ?? false,
        dailyCalories,
        proteinGrams,
        carbGrams,
        fatGrams,
        mealDetails: typeof mealDetails === 'object' ? JSON.stringify(mealDetails) : mealDetails,
      },
    });
    res.status(201).json({ success: true, data: diet });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * 5. PAYMENT & COMMISSION API
 */
exports.createPayment = async (req, res) => {
  try {
    const { coachId, amount, type, status } = req.body;
    const payment = await prisma.payment.create({
      data: {
        coachId,
        amount,
        type, // "SUBSCRIPTION", "COMMISSION"
        status: status || 'PENDING',
      },
    });
    res.status(201).json({ success: true, data: payment });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * 6. CONTRACT CONSENT API (KVKK & Hizmet Sözleşmesi - Denetim İzi)
 */
exports.recordContractConsent = async (req, res) => {
  try {
    const { userId, documentType } = req.body;
    const ipAddress = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
    const consent = await prisma.contractConsent.create({
      data: {
        userId,
        documentType, // "KVKK", "HIZMET_SOZLESMESI"
        ipAddress,
      },
    });
    res.status(201).json({ success: true, data: consent });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * 7. NOTIFICATION API (Sistem Hatırlatıcıları - Örn: "Su İçmeyi Unutma")
 */
exports.sendNotification = async (req, res) => {
  try {
    const { userId, title, body } = req.body;
    const notification = await prisma.notification.create({
      data: { userId, title, body },
    });
    res.status(201).json({ success: true, data: notification });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

/**
 * 8. MARKET ITEM API (Pazar Yeri ve Komisyon)
 */
exports.createMarketItem = async (req, res) => {
  try {
    const { name, category, price, coachCommissionRate } = req.body;
    const item = await prisma.marketItem.create({
      data: {
        name,
        category,
        price,
        coachCommissionRate: coachCommissionRate || 10.0,
      },
    });
    res.status(201).json({ success: true, data: item });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};
