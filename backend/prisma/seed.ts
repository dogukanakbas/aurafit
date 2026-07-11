import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 AURA B2B2C SaaS - Süper Admin & İlk Veri Seeding İşlemi Başladı...');

  const superAdminEmail = 'superadmin@aura.com';
  const existingAdmin = await prisma.user.findUnique({
    where: { email: superAdminEmail },
  });

  if (!existingAdmin) {
    const hashedPassword = await bcrypt.hash('AuraSuperSecret2026!', 10);
    const superAdmin = await prisma.user.create({
      data: {
        email: superAdminEmail,
        password: hashedPassword,
        fullName: 'AURA SÜPER ADMİN (SYSTEM OWNER)',
        role: 'ADMIN',
        isActive: true,
      },
    });
    console.log('✅ Süper Admin başarıyla oluşturuldu:', {
      id: superAdmin.id,
      email: superAdmin.email,
      role: superAdmin.role,
    });
  } else {
    console.log('ℹ️ Süper Admin zaten sistemde mevcut:', superAdminEmail);
  }

  // Örnek onaylı bir aktif koç (Atlas Demir) - Davet/referans testleri için
  const coachEmail = 'atlas@aura.com';
  let coachUser = await prisma.user.findUnique({ where: { email: coachEmail } });
  if (!coachUser) {
    const hashedCoachPass = await bcrypt.hash('123456', 10);
    coachUser = await prisma.user.create({
      data: {
        email: coachEmail,
        password: hashedCoachPass,
        fullName: 'Atlas Demir (Pro Koç)',
        role: 'COACH',
        isActive: true,
        coachProfile: {
          create: {
            packageType: 'PREMIUM',
            phone: '+90 532 111 22 33',
            iban: 'TR12 0006 2000 0001 2345 6789 01',
            status: 'ACTIVE',
            referralCode: 'AURA-ATLAS-2026',
            commissionRate: 15.0,
            fixedMonthlyFee: 2500,
            customAppName: 'ATLAS FIT PRO',
            primaryColor: '#65A30D',
          },
        },
      },
    });
    console.log('✅ Örnek Aktif Koç (Atlas Demir) oluşturuldu. Davet Kodu: AURA-ATLAS-2026');
  }

  console.log('🌟 Seeding tamamlandı!');
}

main()
  .catch((e) => {
    console.error('❌ Seed hatası:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
