const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// Sağlık kontrolü
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'AURA API Running', version: '1.0.0' });
});

// AI Koç Listeleme & Eşleştirme Rotası (Adım 2)
app.get('/api/v1/trainers/ai-match', (req, res) => {
  const { goal = 'MUSCLE_GAIN' } = req.query;

  const sampleTrainers = [
    {
      id: 'trainer_1',
      fullName: 'Atlas Demir',
      specialty: 'Hipertrofi & Güç Kondisyonu',
      bio: 'Olimpik ağırlık kaldırma ve elit atlet beslenmesinde 8 yıl tecrübe.',
      avatarUrl: 'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=600&q=80',
      aiMatchScore: 94,
      tag: 'Hedeflerinle %94 Eşleşiyor'
    },
    {
      id: 'trainer_2',
      fullName: 'Selin Yılmaz',
      specialty: 'Yağ Yakımı & HIIT Uzmanı',
      bio: 'Fonksiyonel fitness ve metabolik yeniden yapılandırma odaklı programlar.',
      avatarUrl: 'https://images.unsplash.com/photo-1548690312-e3b507d8c110?auto=format&fit=crop&w=600&q=80',
      aiMatchScore: 91,
      tag: 'Hedeflerinle %91 Eşleşiyor'
    },
    {
      id: 'trainer_3',
      fullName: 'Caner Özkan',
      specialty: 'Dayanıklılık & Mobilite',
      bio: 'Maraton hazırlığı ve sakatlık önleyici postür çalışmaları.',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
      aiMatchScore: 88,
      tag: 'Hedeflerinle %88 Eşleşiyor'
    }
  ];

  res.json({
    success: true,
    data: sampleTrainers
  });
});

// Günlük İstatistik & Apple Health / Google Fit Senkronizasyon Rotası
app.get('/api/v1/clients/daily-summary', (req, res) => {
  res.json({
    success: true,
    data: {
      steps: 8450,
      stepTarget: 10000,
      caloriesBurned: 540,
      waterIntakeMl: 2200,
      waterTargetMl: 3000,
      workoutCompletionPercentage: 75,
      activeStreakDays: 14
    }
  });
});

// Çevrimdışı Destekli Günlük Antrenman Rotası
app.get('/api/v1/workouts/today', (req, res) => {
  res.json({
    success: true,
    data: {
      id: 'workout_today_01',
      title: 'İleri Seviye Göğüs & Hipertrofi Serisi',
      category: 'Güç / Hipertrofi',
      durationMins: 50,
      caloriesBurn: 480,
      isCompleted: false,
      exercises: [
        { name: 'Incline Dumbbell Press', sets: 4, reps: '10-12', restSec: 90 },
        { name: 'Cable Fly (Mid to Low)', sets: 3, reps: '12-15', restSec: 60 },
        { name: 'Weighted Dips', sets: 3, reps: '8-10', restSec: 90 },
        { name: 'Overhead Tricep Extension', sets: 4, reps: '12', restSec: 60 }
      ]
    }
  });
});

// Koç-Danışan Chat Mesajları Rotası
app.get('/api/v1/messages', (req, res) => {
  res.json({
    success: true,
    data: [
      {
        id: 'msg_1',
        senderId: 'trainer_1',
        senderName: 'Atlas Demir',
        content: 'Günaydın! Bugünkü göğüs antrenmanı öncesi omuz ısınmanı unutma.',
        messageType: 'TEXT',
        createdAt: new Date(Date.now() - 3600000).toISOString(),
        isMine: false
      },
      {
        id: 'msg_2',
        senderId: 'client_me',
        senderName: 'Ben',
        content: 'Tamamdır hocam! Dün akşam makroları tam tutturdum.',
        messageType: 'TEXT',
        createdAt: new Date(Date.now() - 1800000).toISOString(),
        isMine: true
      },
      {
        id: 'msg_3',
        senderId: 'trainer_1',
        senderName: 'Atlas Demir',
        content: 'Harika gidiyorsun 🔥 Form kontrolü için ikinci setin videosunu veya fotoğrafını atabilirsin.',
        messageType: 'VOICE',
        mediaUrl: 'https://aura.fit/voice/sample1.mp3',
        durationSec: 14,
        createdAt: new Date(Date.now() - 600000).toISOString(),
        isMine: false
      }
    ]
  });
});

module.exports = app;
