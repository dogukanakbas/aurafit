import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';

class BodyMapTargetScreen extends StatefulWidget {
  const BodyMapTargetScreen({super.key});

  @override
  State<BodyMapTargetScreen> createState() => _BodyMapTargetScreenState();
}

class _BodyMapTargetScreenState extends State<BodyMapTargetScreen> {
  String _selectedZone = 'Tüm vücut';

  final List<Map<String, dynamic>> _zones = [
    {
      'id': 'Göğüs',
      'label': 'Göğüs',
      'align': const Alignment(0.45, -0.22),
      'exercises': ['Barbell Bench Press', 'Incline Dumbbell Press', 'Cable Flyes'],
      'desc': 'Üst, orta ve alt göğüs liflerini hedefleyen hacim ve sıkılaşma programları.',
    },
    {
      'id': 'Sırt',
      'label': 'Sırt',
      'align': const Alignment(-0.65, -0.42),
      'exercises': ['Lat Pulldown', 'Bent-Over Row', 'Seated Cable Row'],
      'desc': 'Kanat genişliği ve dik duruş için postür odaklı sırt egzersizleri.',
    },
    {
      'id': 'Omuz',
      'label': 'Omuz',
      'align': const Alignment(0.65, -0.48),
      'exercises': ['Seated Dumbbell Press', 'Lateral Raise', 'Face Pull'],
      'desc': 'Geniş omuz çatısı ve estetik 3D omuz başları için izole hareketler.',
    },
    {
      'id': 'Karın Kasları',
      'label': 'Karın Kasları',
      'align': const Alignment(-0.75, -0.10),
      'exercises': ['Hanging Leg Raise', 'Plank Hold', 'Cable Crunch'],
      'desc': 'Merkez bölgesi (Core) stabilitesi ve karın kaslarını belirginleştirme.',
    },
    {
      'id': 'Kol',
      'label': 'Kol',
      'align': const Alignment(-0.75, 0.15),
      'exercises': ['EZ Barbell Curl', 'Rope Triceps Pushdown', 'Hammer Curl'],
      'desc': 'Biceps ve Triceps kaslarını büyüten izole kol antrenmanları.',
    },
    {
      'id': 'Kalça',
      'label': 'Kalça',
      'align': const Alignment(0.70, 0.15),
      'exercises': ['Barbell Hip Thrust', 'Bulgarian Split Squat', 'Cable Kickback'],
      'desc': 'Kalça kaslarını şekillendiren ve glute aktivasyonu sağlayan hareketler.',
    },
    {
      'id': 'Bacak',
      'label': 'Bacak',
      'align': const Alignment(0.60, 0.45),
      'exercises': ['Barbell Back Squat', 'Leg Press', 'Walking Lunges'],
      'desc': 'Alt vücut dayanıklılığı ve güçlü bacak kasları için temel egzersizler.',
    },
    {
      'id': 'Tüm vücut',
      'label': 'Tüm vücut',
      'align': const Alignment(0.0, 0.85),
      'exercises': ['Full Body HIIT', 'Metabolic Conditioning', 'Functional Circuit'],
      'desc': 'Tüm kas gruplarını aynı anda çalıştıran yüksek kalori yakımlı program.',
    },
  ];

  void _selectZone(String zoneId) {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedZone = zoneId;
    });
  }

  Map<String, dynamic> get _currentZoneData {
    return _zones.firstWhere(
      (z) => z['id'] == _selectedZone,
      orElse: () => _zones.last,
    );
  }

  @override
  Widget build(BuildContext context) {
    final zoneData = _currentZoneData;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.obsidianBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ODAK BÖLGELERİN NERESİ?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.obsidianBlack,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // İlerleme Çubuğu (Step Progress Bar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: List.generate(6, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: index < 5 ? 6 : 0),
                      decoration: BoxDecoration(
                        color: index <= 2
                            ? AppColors.emeraldGreen
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Hedef kas grubuna dokun, sana en uygun egzersizleri getirelim',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // İnteraktif Anatomik Vücut Haritası & Butonlar Alanı
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Anatomik Vücut Silüeti Grafiği
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 220,
                        height: 340,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(110),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.emeraldGreen.withValues(alpha: 0.15),
                              AppColors.obsidianBlack.withValues(alpha: 0.06),
                            ],
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.accessibility_new_rounded,
                              size: 240,
                              color: AppColors.obsidianBlack.withValues(alpha: 0.75),
                            ),
                            // Seçilen kas bölgesi pırıltısı
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.emeraldGreen
                                    .withValues(alpha: 0.22),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Harita Etrafındaki Seçilebilir Kas Butonları
                  ..._zones.map((zone) {
                    final isSelected = _selectedZone == zone['id'];
                    final Alignment alignment = zone['align'] as Alignment;

                    return Align(
                      alignment: alignment,
                      child: GestureDetector(
                        onTap: () => _selectZone(zone['id']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.emeraldGreen
                                : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.emeraldGreen
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? AppColors.emeraldGreen
                                        .withValues(alpha: 0.35)
                                    : Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            zone['label'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.obsidianBlack,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Alt Bilgi Kartı & DEVAM ET Butonu
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          color: AppColors.emeraldGreen,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        zoneData['label'].toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.obsidianBlack,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    zoneData['desc'],
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: (zoneData['exercises'] as List<String>)
                        .map((ex) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.lightBackground,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                '💪 $ex',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.obsidianBlack,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 18),
                  PremiumButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      Navigator.pop(context, zoneData['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '✅ Hedef bölge "${zoneData['label']}" olarak ayarlandı. Özel antrenmanların hazır!'),
                          backgroundColor: AppColors.emeraldGreen,
                        ),
                      );
                    },
                    label: 'DEVAM ET',
                    icon: Icons.arrow_forward_rounded,
                    isPrimary: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
