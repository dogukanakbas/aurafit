import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  // Diet tablosundan gelen örnek günlük hedefler
  final Map<String, dynamic> _dietPlan = {
    'dailyCalories': 2450,
    'consumedCalories': 1710,
    'proteinGrams': 185,
    'consumedProtein': 137,
    'carbGrams': 260,
    'consumedCarbs': 180,
    'fatGrams': 65,
    'consumedFat': 48,
    'meals': [
      {
        'id': 'meal_1',
        'title': 'Kahvaltı',
        'time': '08:30',
        'calories': 620,
        'protein': 45,
        'carbs': 68,
        'fat': 18,
        'items': ['Yulaf Ezmesi (100g)', '3 Yumurta Beyazı + 1 Tam', 'Avokado (Yarım)', 'Yaban Mersini (50g)'],
        'isCompleted': true,
      },
      {
        'id': 'meal_2',
        'title': 'Öğle Yemeği',
        'time': '13:00',
        'calories': 780,
        'protein': 60,
        'carbs': 85,
        'fat': 22,
        'items': ['Izgara Somon (220g)', 'Esmer Pirinç (150g)', 'Buharda Kuşkonmaz & Brokoli'],
        'isCompleted': true,
      },
      {
        'id': 'meal_3',
        'title': 'Antrenman Sonrası Ara Öğün',
        'time': '17:30',
        'calories': 310,
        'protein': 32,
        'carbs': 30,
        'fat': 6,
        'items': ['Whey Protein İzole Shake (1 Porsiyon)', 'Muz (1 Adet)', 'Çiğ Badem (15g)'],
        'isCompleted': true,
      },
      {
        'id': 'meal_4',
        'title': 'Akşam Yemeği',
        'time': '20:00',
        'calories': 740,
        'protein': 48,
        'carbs': 77,
        'fat': 19,
        'items': ['Izgara Dana Bonfile (200g)', 'Kinoa (120g)', 'Akdeniz Yeşillikleri Salatası'],
        'isCompleted': false,
      },
    ]
  };

  Future<void> _handleBarcodeCameraScan() async {
    HapticFeedback.mediumImpact();

    // permission_handler ile kamera izni iste
    final status = await Permission.camera.request();

    if (status.isGranted || status.isLimited) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BarcodeCameraScannerScreen(),
        ),
      );
    } else {
      // Eğer izin reddedildiyse veya tarayıcıda ise simüle edilmiş kamera görünümüne geç
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BarcodeCameraScannerScreen(
            permissionNote: 'Kamera izni simülasyon modunda açıldı.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'MAKRO & BESLENME TAKİBİ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.obsidianBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Üst Kısımda Makro Hedef Kartları
            _buildMacroOverviewSection(),
            const SizedBox(height: 24),

            // 2. Kamerayla Barkod Oku Butonu (permission_handler)
            PremiumButton(
              onPressed: _handleBarcodeCameraScan,
              label: 'KAMERAYLA BARKOD OKU',
              icon: Icons.qr_code_scanner_rounded,
              isPrimary: true,
            ),
            const SizedBox(height: 28),

            // 3. JSON Detaylarından Gelen Öğün Listesi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GÜNLÜK ÖĞÜN DETAYLARI',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  '3 / 4 Tamamlandı',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.emeraldGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...(_dietPlan['meals'] as List<dynamic>)
                .map((meal) => _buildMealCard(meal as Map<String, dynamic>)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroOverviewSection() {
    final int totalCal = _dietPlan['dailyCalories'];
    final int consCal = _dietPlan['consumedCalories'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GÜNLÜK KALORİ HEDEFİ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$consCal',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.obsidianBlack,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '/ $totalCal kcal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_fire_department_rounded,
                    color: AppColors.emeraldGreen, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Makro Dağılım Kartları (Protein, Karbonhidrat, Yağ)
          Row(
            children: [
              Expanded(
                child: _buildMacroPill(
                  label: 'Protein',
                  consumed: _dietPlan['consumedProtein'],
                  target: _dietPlan['proteinGrams'],
                  unit: 'gr',
                  color: AppColors.emeraldGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMacroPill(
                  label: 'Karbonhidrat',
                  consumed: _dietPlan['consumedCarbs'],
                  target: _dietPlan['carbGrams'],
                  unit: 'gr',
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMacroPill(
                  label: 'Sağlıklı Yağ',
                  consumed: _dietPlan['consumedFat'],
                  target: _dietPlan['fatGrams'],
                  unit: 'gr',
                  color: AppColors.limeGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroPill({
    required String label,
    required int consumed,
    required int target,
    required String unit,
    required Color color,
  }) {
    final double percent = (consumed / target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$consumed / $target $unit',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.obsidianBlack,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    final bool isCompleted = meal['isCompleted'] ?? false;
    final List<String> items = List<String>.from(meal['items'] ?? []);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCompleted
              ? AppColors.emeraldGreen.withValues(alpha: 0.35)
              : Colors.grey.shade200,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.emeraldGreen.withValues(alpha: 0.12)
                            : AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.restaurant_rounded,
                        color: isCompleted
                            ? AppColors.emeraldGreen
                            : AppColors.textMuted,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.obsidianBlack,
                            ),
                          ),
                          Text(
                            'Saat ${meal['time']} • ${meal['calories']} kcal',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${meal['protein']}g P | ${meal['carbs']}g K | ${meal['fat']}g Y',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.obsidianBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Öğün İçeriğindeki Yiyecekler Listesi
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.circle,
                        size: 6, color: AppColors.emeraldGreen),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? AppColors.textMuted
                              : AppColors.obsidianBlack,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

/// Şimdilik boş bir kamera görünümü ve barkod tarama çerçevesi sunan sayfa
class BarcodeCameraScannerScreen extends StatelessWidget {
  final String? permissionNote;

  const BarcodeCameraScannerScreen({super.key, this.permissionNote});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Kamera Arayüz Simülasyonu
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.emeraldGreen, width: 3),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Stack(
                    children: [
                      // Köşe Tarayıcı Nişangah Efekti
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.transparent, AppColors.emeraldGreen, Colors.transparent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.emeraldGreen.withValues(alpha: 0.6),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Center(
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white38,
                          size: 72,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Yiyeceğin veya Takviyenin Barkodunu\nÇerçeve İçine Hizalayın',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (permissionNote != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    permissionNote!,
                    style: const TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Üst Geri Dönüş ve Fener Butonları
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.flashlight_on_rounded,
                            color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'FENER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Alt Manuel Giriş Butonu
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: PremiumButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Barkod Başarıyla Okundu: 8690504033221 (Yulaf Ezmesi 100g) ✅'),
                  ),
                );
              },
              label: 'BARKODU MANUEL GİR VEYA TARAMAYI SİMÜLE ET',
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }
}
