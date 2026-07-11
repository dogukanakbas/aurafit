const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const JWT_SECRET = process.env.JWT_SECRET || 'aura_super_secret_jwt_key_2026';

/**
 * 1. ORTAK AKILLI GİRİŞ (Smart Login Routing)
 * ADMIN -> Süper Admin Paneline
 * COACH -> Koç Dashboard'una (Eğer onaysız ise "Admin onayı bekleniyor" uyarısı verir)
 * STUDENT -> Öğrenci Ana Ekranına
 */
exports.login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await prisma.user.findUnique({
      where: { email },
      include: {
        coachProfile: true,
        studentProfile: true,
      },
    });

    if (!user) {
      return res.status(404).json({ success: false, message: 'Kullanıcı bulunamadı.' });
    }

    const isValid = await bcrypt.compare(password, user.password || user.passwordHash || '');
    if (!isValid) {
      return res.status(401).json({ success: false, message: 'Hatalı e-posta veya şifre.' });
    }

    if (!user.isActive) {
      return res.status(403).json({ success: false, message: 'Hesabınız askıya alınmıştır.' });
    }

    // Koç için Onay Kontrolü (status: PENDING_APPROVAL)
    if (user.role === 'COACH' && user.coachProfile) {
      if (user.coachProfile.status === 'PENDING_APPROVAL') {
        return res.status(403).json({
          success: false,
          pendingApproval: true,
          message: 'Koç başvurunuz henüz Admin tarafından onaylanmamıştır. Onay bekliyor.',
        });
      }
    }

    const token = jwt.sign(
      { id: user.id, role: user.role, email: user.email },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    return res.status(200).json({
      success: true,
      token,
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        role: user.role,
        coachProfile: user.coachProfile,
        studentProfile: user.studentProfile,
      },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

/**
 * 2. SPOR KOÇU KAYIT PANELİ (Coach Registration)
 * Paket Seçimi (BASIC, PRO, PREMIUM), IBAN, Telefon, Referans Kodu, KVKK & Sözleşme Onayları
 * Durumu otomatik olarak status: PENDING_APPROVAL yapılır.
 */
exports.registerCoach = async (req, res) => {
  const {
    fullName,
    email,
    password,
    phone,
    iban,
    packageType,
    referralCode,
    kvkkConsent,
    serviceAgreementConsent,
  } = req.body;

  try {
    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ success: false, message: 'Bu e-posta adresi zaten kayıtlı.' });
    }

    if (!kvkkConsent || !serviceAgreementConsent) {
      return res.status(400).json({
        success: false,
        message: 'KVKK ve Koçluk Hizmet Sözleşmesini onaylamanız gereklidir.',
      });
    }

    // Varsa davet eden koçun kontrolü
    let referredByCoachId = null;
    if (referralCode) {
      const inviter = await prisma.coachProfile.findUnique({ where: { referralCode } });
      if (inviter) referredByCoachId = inviter.id;
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const ipAddress = req.headers['x-forwarded-for'] || req.socket.remoteAddress;

    const newCoachUser = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        fullName,
        role: 'COACH',
        isActive: true,
        coachProfile: {
          create: {
            packageType: packageType || 'BASIC',
            phone,
            iban,
            status: 'PENDING_APPROVAL', // Admin onaylayana kadar PENDING
            referredByCoachId,
          },
        },
        consents: {
          createMany: {
            data: [
              { documentType: 'KVKK_COACH', ipAddress },
              { documentType: 'SERVICE_AGREEMENT_COACH', ipAddress },
            ],
          },
        },
      },
      include: {
        coachProfile: true,
      },
    });

    return res.status(201).json({
      success: true,
      message: 'Koç kaydınız alındı. Admin onayı sonrasında sisteme giriş yapabileceksiniz.',
      data: newCoachUser,
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

/**
 * 3. ÖĞRENCİ KAYIT AKIŞI (Student Onboarding)
 * Koç Davet Kodu / Koç Seçimi, Biyometrik Demografi (Cinsiyet, Yaş, Boy, Kilo, Hedef), Sağlık Beyanı & Üyelik Sözleşmesi
 */
exports.registerStudent = async (req, res) => {
  const {
    fullName,
    email,
    password,
    coachInviteCode,
    selectedCoachId,
    gender,
    age,
    height,
    weight,
    goal,
    membershipConsent,
    healthDeclarationConsent,
  } = req.body;

  try {
    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ success: false, message: 'Bu e-posta adresi zaten kayıtlı.' });
    }

    if (!membershipConsent || !healthDeclarationConsent) {
      return res.status(400).json({
        success: false,
        message: 'Üyelik sözleşmesi ve Sağlık Beyanını onaylamanız zorunludur.',
      });
    }

    // Koçu belirle: Davet Kodu girildiyse onu kullan, yoksa selectedCoachId
    let targetCoachId = selectedCoachId || null;
    if (coachInviteCode) {
      const coachByCode = await prisma.coachProfile.findUnique({
        where: { referralCode: coachInviteCode },
      });
      if (coachByCode) {
        targetCoachId = coachByCode.id;
      }
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const ipAddress = req.headers['x-forwarded-for'] || req.socket.remoteAddress;

    const newStudentUser = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        fullName,
        role: 'STUDENT',
        isActive: true,
        studentProfile: {
          create: {
            coachId: targetCoachId,
            gender,
            age: age ? parseInt(age) : null,
            height: height ? parseFloat(height) : null,
            weight: weight ? parseFloat(weight) : null,
            goal,
            activeStatus: true,
          },
        },
        consents: {
          createMany: {
            data: [
              { documentType: 'STUDENT_MEMBERSHIP_AGREEMENT', ipAddress },
              { documentType: 'STUDENT_HEALTH_DECLARATION', ipAddress },
            ],
          },
        },
      },
      include: {
        studentProfile: true,
      },
    });

    const token = jwt.sign(
      { id: newStudentUser.id, role: newStudentUser.role, email: newStudentUser.email },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    return res.status(201).json({
      success: true,
      token,
      user: newStudentUser,
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};
