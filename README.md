# AURA – Premium Mobil Fitness & Koçluk Platformu

**AURA**, danışanlar ve koçları yapay zeka destekli eşleştirme, gerçek zamanlı sağlık/performans takibi, özel antrenman/beslenme programları ve yüksek kaliteli etkileşimle buluşturan **mobil öncelikli (Mobile-First)** premium bir fitness ve koçluk ekosistemidir.

---

## 🏗️ Sistem Mimarisi & Klasör Ağacı

Proje **iki ana katmandan** oluşur:
1. **`backend/`**: Node.js + Express REST API, Prisma ORM ve SQLite (Production için PostgreSQL uyumlu) altyapısı.
2. **`aura_mobile/`**: Flutter (Dart) + Riverpod ile inşa edilmiş, "Clean Studio Light" ve "Obsidian Dark" temalarını barındıran mobil istemci.

```
spor2/
├── README.md                      # Proje mimarisi ve kurulum belgesi
├── backend/                       # Node.js + Express API
│   ├── prisma/
│   │   ├── schema.prisma          # Prisma veritabanı şeması (User, Workout, Diet, vb.)
│   │   └── seed.js                # Koç ve danışan başlangıç verileri
│   ├── src/
│   │   ├── server.js              # Sunucu giriş noktası
│   │   ├── app.js                 # Express konfigürasyonu
│   │   ├── middleware/
│   │   │   └── auth.middleware.js # JWT kimlik doğrulama ara katmanı
│   │   ├── controllers/           # Auth, Trainer, Workout, Diet, Health işleyicileri
│   │   └── routes/                # API rotaları (/api/v1/...)
│   └── package.json
└── aura_mobile/                   # Flutter Mobil Uygulama
    ├── pubspec.yaml               # Bağımlılıklar (flutter_riverpod, fl_chart, lottie vb.)
    └── lib/
        ├── main.dart              # Uygulama başlatıcı & Tema/Riverpod konfigürasyonu
        ├── core/
        │   ├── theme/             # Clean Studio Light & Obsidian Dark temaları
        │   │   ├── app_colors.dart
        │   │   └── app_theme.dart
        │   ├── utils/
        │   │   └── haptic_feedback_helper.dart # Global Haptic Feedback yardımcı yapısı
        │   └── services/          # Yerel depolama (Offline-first) ve HealthKit servisleri
        └── features/
            ├── onboarding/        # 3 Adımlı AI Koç Eşleştirme & Onboarding Modülü
            ├── navigation/        # Özel Haptic Destekli Alt Navigasyon Çubuğu
            ├── home/              # İlerleme Halkaları & Kalori/Su/Adım Takibi
            ├── workout/           # Çevrimdışı Destekli Antrenman & Lottie Konfeti Kutlaması
            ├── chat/              # Koç & Danışan İletişim Merkezi (Ses/Fotoğraf/Metin)
            ├── nutrition/         # Beslenme Takibi & Barkod Okuyucu Entegrasyonu
            └── profile/           # fl_chart Etkileşimli Gelişim Grafikleri & Fotoğraf Yükleme
```

---

## 💎 Temel Modüller ve Özellikler

### 1. Backend & Veritabanı (Prisma ORM)
- **Modeller**: `User` (Roller: `CLIENT`, `TRAINER`, `ADMIN`), `Workout`, `Diet`, `CheckIn`, `Message`, `Measurement`, `DailyActivity`.
- **Güvenlik**: Bcrypt ile parola şifreleme ve JWT (JSON Web Token) tabanlı oturum yönetimi.

### 2. Clean Studio & Obsidian Dark Tema Mimarisi
- **Clean Studio Light**: Zümrüt Yeşili (`#059669`) ve Kireç Yeşili (`#65A30D`) vurgularla zenginleştirilmiş yüksek ferahlık hissi.
- **Obsidian Dark**: Koyu obsidyen siyahı (`#090A0F`) üzerinde parlayan neon yeşil aksanlar.
- **Global Haptic Feedback**: Uygulama içi her geçiş ve etkileşimde `HapticFeedback.lightImpact()` tetikleyen sarmalayıcı yapı.

### 3. Akıllı Onboarding & AI Koç Eşleştirme
- **Adım 1**: Boy, kilo, yaş, aktivite düzeyi ve hedef seçimi formu.
- **Adım 2**: Kullanıcı hedeflerine göre hesaplanan dinamik eşleşme oranı (`%94 Eşleşiyor`) ile koç kartları.
- **Adım 3**: KVKK ve Hizmet Sözleşmesi onaylı koç seçimi ve hesap aktivasyonu.
