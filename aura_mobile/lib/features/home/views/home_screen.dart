import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../notifications/views/notifications_screen.dart';
import '../../workout/views/body_map_target_screen.dart';
import '../../workout/views/workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ringAnimController;
  late Animation<double> _ringAnimation;
  final PageController _sliderController = PageController();
  int _currentSliderIdx = 0;

  // Koçun Günlük Atadığı Görevler Durumu
  bool _isWorkoutCompleted = false;
  bool _isNutritionCompleted = false;
  bool _isWaterCompleted = false;
  double _waterLiters = 2.1;

  final List<Map<String, dynamic>> _sliderItems = [
    {
      'tag': '🔥 KAMPANYA & FIRSAT',
      'title': 'Aura İzole Whey %18 İndirimli!',
      'subtitle': 'Kas protein sentezini maksimuma çıkar, koç onaylı formül.',
      'btn': 'MAĞAZAYI İNCELE ➔',
      'colors': [Color(0xFF0F172A), Color(0xFF1E293B)],
      'badgeColor': AppColors.emeraldGreen,
    },
    {
      'tag': '🏆 ŞAMPİYONLAR LİGİ',
      'title': 'Yaz Dönemi Challenge Başladı',
      'subtitle': 'Aktivite halkalarını 30 gün doldur, 1 ay ücretsiz koçluk kazan.',
      'btn': 'DETAYLARI GÖR ➔',
      'colors': [Color(0xFF065F46), Color(0xFF047857)],
      'badgeColor': AppColors.limeGreen,
    },
    {
      'tag': '💡 KOÇ ATLAS İPUCU',
      'title': 'Hipertrofi İçin Uyku & Toparlanma',
      'subtitle': 'Derin uyku büyüme hormonunu %300 artırır. 8 saat uyku hedefle.',
      'btn': 'REHBERİ OKU ➔',
      'colors': [Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
      'badgeColor': Colors.amber,
    },
  ];

  @override
  void initState() {
    super.initState();
    _ringAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _ringAnimation = CurvedAnimation(
      parent: _ringAnimController,
      curve: Curves.easeOutCubic,
    );
    _ringAnimController.forward();
  }

  @override
  void dispose() {
    _ringAnimController.dispose();
    _sliderController.dispose();
    super.dispose();
  }

  void _toggleTask(String type) {
    HapticFeedback.mediumImpact();
    setState(() {
      if (type == 'WORKOUT') {
        _isWorkoutCompleted = !_isWorkoutCompleted;
      } else if (type == 'NUTRITION') {
        _isNutritionCompleted = !_isNutritionCompleted;
      } else if (type == 'WATER') {
        _isWaterCompleted = !_isWaterCompleted;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🔥 Görev durumu güncellendi. Koçuna bildirim iletildi!',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.obsidianBlack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SABİT HEADER: Günaydın + Koç Bilgisi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GÜNAYDIN, ERLİK HAN 👋',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMuted,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Bugünün Programı Hazır',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.obsidianBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.notifications_active_rounded,
                            color: AppColors.emeraldGreen,
                            size: 20,
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 1. MACFit Tarzı Haftalık Seri Barı & Oyunlaştırma Metrikleri
              _buildMacfitWeeklyStreakAndGamificationBar(),
              const SizedBox(height: 24),

              // 2. MACFit Tarzı: NEREDE SPOR YAPMAK İSTERSİN? (KULÜPTE • EVDE • DIŞARIDA)
              _buildMacfitWhereToWorkoutSection(),
              const SizedBox(height: 24),

              // 3. MACFit Tarzı: ODAK BÖLGELERİN NERESİ? (İnteraktif Vücut Haritası)
              _buildMacfitInteractiveBodyMapCard(),
              const SizedBox(height: 24),

              // YENİ: HABERLER, KAMPANYALAR VE MARKET SLIDER (CAROUSEL)
              _buildTopNewsAndMarketSlider(),
              const SizedBox(height: 24),

              // 2. PARLAYAN İÇ İÇE 3 YEŞİL İLERLEME HALKASI (CustomPaint)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(32),
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
                    AnimatedBuilder(
                      animation: _ringAnimation,
                      builder: (context, child) {
                        return SizedBox(
                          width: 220,
                          height: 220,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(220, 220),
                                painter: _AuraThreeRingsPainter(
                                  workoutProgress: (_isWorkoutCompleted
                                          ? 1.0
                                          : 0.75) *
                                      _ringAnimation.value,
                                  calorieProgress: (_isNutritionCompleted
                                          ? 1.0
                                          : 0.82) *
                                      _ringAnimation.value,
                                  waterProgress:
                                      (_isWaterCompleted ? 1.0 : 0.60) *
                                          _ringAnimation.value,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    color: AppColors.emeraldGreen,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    '%86',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.obsidianBlack,
                                    ),
                                  ),
                                  Text(
                                    'GÜNLÜK HEDEF',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textMuted,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Halka Lejantı
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildRingLegend(
                            'Antrenman',
                            _isWorkoutCompleted ? 'Tamamlandı' : '5 Egzersiz',
                            AppColors.emeraldGreen),
                        _buildRingLegend(
                            'Beslenme',
                            _isNutritionCompleted
                                ? 'Tamamlandı'
                                : '1980 / 2450 Kcal',
                            AppColors.limeGreen),
                        _buildRingLegend(
                            'Su Tüketimi',
                            _isWaterCompleted ? 'Tamamlandı' : '2.1 / 3.0 Litre',
                            const Color(0xFF10B981)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. KOÇUN GÜNLÜK ATADIĞI GÖREVLER & TAMAMLANDI İŞARETLEME BUTONLARI
              const Text(
                'KOÇUN ATADIĞI GÜNLÜK GÖREVLER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),

              _buildCoachTaskCard(
                type: 'WORKOUT',
                title: '1. Gün • İtme (Push) Antrenmanı',
                subtitle:
                    '5 Egzersiz • Koç İpucu: Barbell Bench Press açısına dikkat et.',
                icon: Icons.fitness_center_rounded,
                isCompleted: _isWorkoutCompleted,
              ),
              const SizedBox(height: 12),

              _buildCoachTaskCard(
                type: 'NUTRITION',
                title: 'Günlük Makro & Beslenme Hedefi',
                subtitle:
                    '2450 Kcal • 185g Protein • Öğün listelerine uymayı unutma.',
                icon: Icons.restaurant_menu_rounded,
                isCompleted: _isNutritionCompleted,
              ),
              const SizedBox(height: 12),

              _buildCoachTaskCard(
                type: 'WATER',
                title: 'Günlük Hidrasyon & Su Hedefi',
                subtitle:
                    'En az 3 litre su iç. Antrenman esnasında mineral takviyesi al.',
                icon: Icons.water_drop_rounded,
                isCompleted: _isWaterCompleted,
              ),
              const SizedBox(height: 24),

              // 4. YEREL VERİLERDEN GELEN GÜNLÜK ADIM KARTI (Apple Health / Google Fit)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.emeraldGreen,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.directions_walk_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '8,420 ADIM',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Apple Health / Google Fit Senkronize',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.sync_rounded,
                      color: AppColors.emeraldGreen,
                      size: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5. HIZLI KOÇ İLETİŞİM & CANLI DESTEK KARTI
              _buildCoachConnectCard(),
              const SizedBox(height: 20),

              // 6. GÜNLÜK HİDRASYON HIZLI TAKİP KARTI (+250ML / +500ML)
              _buildQuickWaterTracker(),
              const SizedBox(height: 20),

              // 7. HAFTALIK UYUM & MAKRO ÖZET ŞERİDİ (STREAK STRIP)
              _buildWeeklyStreakStrip(),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNewsAndMarketSlider() {
    return Column(
      children: [
        SizedBox(
          height: 145,
          child: PageView.builder(
            controller: _sliderController,
            onPageChanged: (idx) => setState(() => _currentSliderIdx = idx),
            itemCount: _sliderItems.length,
            itemBuilder: (context, idx) {
              final item = _sliderItems[idx];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: item['colors'],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: item['badgeColor'],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item['tag'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Icon(Icons.auto_awesome_rounded,
                            color: Colors.white70, size: 18),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['subtitle'],
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          item['btn'],
                          style: const TextStyle(
                            color: AppColors.emeraldGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_sliderItems.length, (idx) {
            final active = _currentSliderIdx == idx;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? AppColors.emeraldGreen : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCoachConnectCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80',
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.emeraldGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ATLAS DEMİR • KİŞİSEL KOÇUN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Soru veya form videosu gönderebilirsin.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.obsidianBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '💬 Hızlı Mesaj Yaz',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.emeraldGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '📹 Canlı Seans',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickWaterTracker() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.water_drop_rounded,
                      color: Color(0xFF0284C7), size: 20),
                  const SizedBox(width: 6),
                  const Text(
                    'GÜNLÜK SU TAKİBİ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.obsidianBlack,
                    ),
                  ),
                ],
              ),
              Text(
                '${_waterLiters.toStringAsFixed(2)} / 3.0 Litre',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0284C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_waterLiters / 3.0).clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFE0F2FE),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _waterLiters += 0.25);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '+ 250 ML EKLE 💧',
                        style: TextStyle(
                          color: Color(0xFF0284C7),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _waterLiters += 0.50);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '+ 500 ML EKLE 🚰',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStreakStrip() {
    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cts', 'Paz'];
    final completedDays = [true, true, true, true, true, false, false];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'HAFTALIK ANTRENMAN SERİSİ (STREAK)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '🔥 5 Gün Üst Üste',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.emeraldGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (idx) {
              final done = completedDays[idx];
              final isToday = idx == 4;
              return Column(
                children: [
                  Text(
                    days[idx],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isToday ? FontWeight.w900 : FontWeight.w700,
                      color: isToday
                          ? AppColors.obsidianBlack
                          : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: done
                          ? AppColors.emeraldGreen
                          : AppColors.lightBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isToday
                            ? AppColors.emeraldGreen
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      done ? Icons.check_rounded : Icons.more_horiz_rounded,
                      color: done ? Colors.white : AppColors.textMuted,
                      size: 18,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachTaskCard({
    required String type,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isCompleted,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.emeraldGreen.withValues(alpha: 0.08)
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isCompleted ? AppColors.emeraldGreen : Colors.grey.shade200,
          width: isCompleted ? 1.8 : 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.emeraldGreen
                  : AppColors.lightBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isCompleted ? Colors.white : AppColors.emeraldGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.obsidianBlack,
                    decoration:
                        isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // TAMAMLANDI İŞARETLEME BUTONU
          GestureDetector(
            onTap: () => _toggleTask(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.emeraldGreen
                    : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.emeraldGreen
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color:
                        isCompleted ? Colors.white : AppColors.obsidianBlack,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isCompleted ? 'BİTTİ' : 'BİTİR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color:
                          isCompleted ? Colors.white : AppColors.obsidianBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRingLegend(String title, String value, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.obsidianBlack,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // MACFIT TARZI 1: HAFTALIK SERİ TAKVİMİ & OYUNLAŞTIRMA SATIRI
  // ==========================================
  Widget _buildMacfitWeeklyStreakAndGamificationBar() {
    final days = ['P', 'S', 'Ç', 'P', 'C', 'C', 'P'];
    final activeDayIndex = 5; // Örn: Cumartesi (C)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Haftalık Günler Barı
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (index) {
              final isToday = index == activeDayIndex;
              final isCompleted = index < activeDayIndex;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isToday
                      ? AppColors.obsidianBlack.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      days[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isToday ? FontWeight.w900 : FontWeight.w700,
                        color: isToday
                            ? AppColors.obsidianBlack
                            : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted || isToday
                            ? AppColors.emeraldGreen
                            : Colors.transparent,
                        border: Border.all(
                          color: isCompleted || isToday
                              ? AppColors.emeraldGreen
                              : Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),

        // 3'lü Oyunlaştırma & İstatistik Satırı
        Row(
          children: [
            Expanded(
              child: _buildMacfitStatCard(
                title: 'HAFTALIK SERİ',
                value: '5 GÜN 🔥',
                subtitle: 'Seri Devam Ediyor',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMacfitStatCard(
                title: 'GÖREVLER',
                value: '1 / 2 🏅',
                subtitle: 'YENİ • Rookie',
                isBadge: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMacfitStatCard(
                title: 'LİDERLİK',
                value: '#12 👑',
                subtitle: 'Elit Lig',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacfitStatCard({
    required String title,
    required String value,
    required String subtitle,
    bool isBadge = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isBadge)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'YENİ',
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.obsidianBlack,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.emeraldGreen,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MACFIT TARZI 2: NEREDE SPOR YAPMAK İSTERSİN?
  // ==========================================
  Widget _buildMacfitWhereToWorkoutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NEREDE SPOR YAPMAK İSTERSİN?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.obsidianBlack,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildLocationCard(
                title: 'KULÜPTE',
                imageUrl:
                    'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=400&q=80',
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WorkoutScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildLocationCard(
                title: 'EVDE',
                imageUrl:
                    'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=400&q=80',
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WorkoutScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildLocationCard(
                title: 'DIŞARIDA',
                imageUrl:
                    'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?auto=format&fit=crop&w=400&q=80',
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WorkoutScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationCard({
    required String title,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // MACFIT TARZI 3: ODAK BÖLGELERİN NERESİ? KARTI
  // ==========================================
  Widget _buildMacfitInteractiveBodyMapCard() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BodyMapTargetScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.obsidianBlack,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.obsidianBlack.withValues(alpha: 0.25),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.emeraldGreen.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.accessibility_new_rounded,
                color: AppColors.emeraldGreen,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ODAK BÖLGELERİN NERESİ?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'İnteraktif anatomik vücut haritasından hedef kas bölgesini seç, sana özel programları keşfet.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.75),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.emeraldGreen,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _AuraThreeRingsPainter extends CustomPainter {
  final double workoutProgress;
  final double calorieProgress;
  final double waterProgress;

  _AuraThreeRingsPainter({
    required this.workoutProgress,
    required this.calorieProgress,
    required this.waterProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    void drawRing(double radius, double progress, Color color, double stroke) {
      final bgPaint = Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;

      final fgPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(center, radius, bgPaint);

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        fgPaint,
      );
    }

    drawRing(98, workoutProgress, AppColors.emeraldGreen, 10);
    drawRing(83, calorieProgress, AppColors.limeGreen, 10);
    drawRing(68, waterProgress, const Color(0xFF10B981), 10);
  }

  @override
  bool shouldRepaint(covariant _AuraThreeRingsPainter oldDelegate) {
    return oldDelegate.workoutProgress != workoutProgress ||
        oldDelegate.calorieProgress != calorieProgress ||
        oldDelegate.waterProgress != waterProgress;
  }
}
