import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';
import 'body_map_target_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  static const String _cacheKey = 'aura_cached_workout_accordion_v2';
  String _selectedCategory = 'Tüm Programlar';
  final Set<String> _completedSets = {};

  final List<String> _categories = [
    'Tüm Programlar',
    'Aura Hipertrofi',
    'Güç & Kondisyon',
    'Ev FIT (Ekipmansız)',
    'Karın & Core',
  ];

  final List<Map<String, dynamic>> _popularSeries = [
    {
      'id': 'series_1',
      'rank': '#01',
      'title': 'Aura Elite Shred',
      'subtitle': 'Yüksek Kalori Yakımı & Sıkılaşma',
      'duration': '40 Dk',
      'level': 'İleri Seviye',
      'targetMuscle': 'Tüm Vücut / Core',
      'color': AppColors.emeraldGreen,
    },
    {
      'id': 'series_2',
      'rank': '#02',
      'title': 'Titan V-Shape Sırt',
      'subtitle': 'Geniş Kanat & Dik Postür',
      'duration': '50 Dk',
      'level': 'Orta Seviye',
      'targetMuscle': 'Sırt & Biceps',
      'color': const Color(0xFF10B981),
    },
    {
      'id': 'series_3',
      'rank': '#03',
      'title': '3D Omuz & Göğüs Zırhı',
      'subtitle': 'Hacim Odaklı Güç Programı',
      'duration': '45 Dk',
      'level': 'İleri Seviye',
      'targetMuscle': 'Göğüs & Omuz',
      'color': AppColors.limeGreen,
    },
  ];

  final List<Map<String, dynamic>> _workoutDays = [
    {
      'dayId': 'day_1',
      'dayTitle': '1. GÜN • GÖĞÜS & ÖN KOL PRO',
      'subtitle': '4 Egzersiz • Tahmini 48 Dk',
      'icon': Icons.fitness_center_rounded,
      'isInitiallyExpanded': true,
      'exercises': [
        {
          'id': 'd1_ex_1',
          'title': 'Barbell Bench Press',
          'targetMuscle': 'Ana Göğüs',
          'sets': 4,
          'reps': '8 - 10 Tekrar',
          'rest': '90 sn',
          'tip': 'Barı kontrollü indir, göğüs alt noktada esnemeyi hisset.',
        },
        {
          'id': 'd1_ex_2',
          'title': 'Incline Dumbbell Press',
          'targetMuscle': 'Üst Göğüs',
          'sets': 4,
          'reps': '10 - 12 Tekrar',
          'rest': '60 sn',
          'tip': '30 derece eğim, tepe noktada göğüs kasını tam sıkılaştır.',
        },
        {
          'id': 'd1_ex_3',
          'title': 'Cable Crossover Fly',
          'targetMuscle': 'İç Göğüs & İzole',
          'sets': 3,
          'reps': '12 - 15 Tekrar',
          'rest': '45 sn',
          'tip': 'Elleri önde birleştir, 1 saniye izometrik bekleme yap.',
        },
        {
          'id': 'd1_ex_4',
          'title': 'EZ Barbell Biceps Curl',
          'targetMuscle': 'Ön Kol (Biceps)',
          'sets': 3,
          'reps': '10 - 12 Tekrar',
          'rest': '45 sn',
          'tip': 'Dirsekleri gövdeye sabitle, sallanmadan nizami kaldır.',
        },
      ],
    },
    {
      'dayId': 'day_2',
      'dayTitle': '2. GÜN • SIRT & ARKA KOL KONDİSYON',
      'subtitle': '4 Egzersiz • Tahmini 50 Dk',
      'icon': Icons.shield_rounded,
      'isInitiallyExpanded': false,
      'exercises': [
        {
          'id': 'd2_ex_1',
          'title': 'Wide-Grip Lat Pulldown',
          'targetMuscle': 'Üst Sırt & Kanat',
          'sets': 4,
          'reps': '10 Tekrar',
          'rest': '75 sn',
          'tip': 'Göğsü öne çıkar, barı üst göğüs hattına çek.',
        },
        {
          'id': 'd2_ex_2',
          'title': 'Bent-Over Barbell Row',
          'targetMuscle': 'Orta Sırt Kalınlık',
          'sets': 4,
          'reps': '8 - 10 Tekrar',
          'rest': '90 sn',
          'tip': 'Bel omurgasını düz tut, kürek kemiklerini birbirine yaklaştır.',
        },
        {
          'id': 'd2_ex_3',
          'title': 'Rope Triceps Pushdown',
          'targetMuscle': 'Arka Kol (Triceps)',
          'sets': 4,
          'reps': '12 - 15 Tekrar',
          'rest': '45 sn',
          'tip': 'Halatı alt noktada dışa doğru açarak triceps başını sık.',
        },
        {
          'id': 'd2_ex_4',
          'title': 'Overhead Dumbbell Extension',
          'targetMuscle': 'Uzun Baş Triceps',
          'sets': 3,
          'reps': '12 Tekrar',
          'rest': '60 sn',
          'tip': 'Başın arkasında tam esneme sağla, dirsekleri sabit tut.',
        },
      ],
    },
    {
      'dayId': 'day_3',
      'dayTitle': '3. GÜN • BACAK, KALÇA & OMUZ ZIRHI',
      'subtitle': '5 Egzersiz • Tahmini 55 Dk',
      'icon': Icons.bolt_rounded,
      'isInitiallyExpanded': false,
      'exercises': [
        {
          'id': 'd3_ex_1',
          'title': 'Barbell Back Squat',
          'targetMuscle': 'Üst Bacak & Quadriceps',
          'sets': 4,
          'reps': '8 Tekrar',
          'rest': '120 sn',
          'tip': 'Topuklardan güç al, paralel derinliğe kadar in.',
        },
        {
          'id': 'd3_ex_2',
          'title': 'Romanian Deadlift (RDL)',
          'targetMuscle': 'Arka Bacak & Kalça',
          'sets': 4,
          'reps': '10 Tekrar',
          'rest': '90 sn',
          'tip': 'Kalçayı geriye it, hamstringlerde esnemeyi hisset.',
        },
        {
          'id': 'd3_ex_3',
          'title': 'Seated Dumbbell Shoulder Press',
          'targetMuscle': 'Ön & Yan Omuz',
          'sets': 4,
          'reps': '10 Tekrar',
          'rest': '75 sn',
          'tip': 'Dambılları kulak hizasına indir, yukarıda tam kilitleme.',
        },
        {
          'id': 'd3_ex_4',
          'title': 'Dumbbell Lateral Raise',
          'targetMuscle': 'Yan Omuz Genişliği',
          'sets': 4,
          'reps': '15 Tekrar',
          'rest': '45 sn',
          'tip': 'Dirsekleri hafif bükülü tut, omuz hizasını aşma.',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCompletedSets();
  }

  Future<void> _loadCompletedSets() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_cacheKey);
    if (saved != null) {
      setState(() {
        _completedSets.addAll(saved);
      });
    }
  }

  Future<void> _toggleSet(String setKey) async {
    HapticFeedback.lightImpact();
    setState(() {
      if (_completedSets.contains(setKey)) {
        _completedSets.remove(setKey);
      } else {
        _completedSets.add(setKey);
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_cacheKey, _completedSets.toList());
  }

  void _showWorkoutDetailSummaryModal(Map<String, dynamic> series) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      series['rank'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.emeraldGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      series['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.obsidianBlack,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                series['subtitle'],
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryChip(
                      Icons.timer_outlined, series['duration'], 'Süre'),
                  _buildSummaryChip(
                      Icons.bolt_rounded, series['level'], 'Seviye'),
                  _buildSummaryChip(Icons.local_fire_department_rounded,
                      '~480 kcal', 'Yakım'),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fitness_center_rounded,
                        color: AppColors.emeraldGreen, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HEDEF KAS GRUBU',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            series['targetMuscle'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.obsidianBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PremiumButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.pop(context);
                },
                label: 'AURA SERİSİNİ BAŞLAT',
                icon: Icons.play_arrow_rounded,
                isPrimary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryChip(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.emeraldGreen, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.obsidianBlack,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AURA PRO TRAINING',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.obsidianBlack,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Özel Koç Programların & Akıllı Egzersiz Takibi',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.accessibility_new_rounded,
                color: AppColors.emeraldGreen,
                size: 20,
              ),
            ),
            tooltip: 'Hedef Kas Seçici',
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BodyMapTargetScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori Yatay Filtre Hapları
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedCategory = cat);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.obsidianBlack
                            : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.obsidianBlack
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? Colors.white
                              : AppColors.obsidianBlack,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // 1. AURA SIGNATURE HERO CARD ("AURA PRO SPOTLIGHT")
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF1E293B),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: AppColors.emeraldGreen.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'AURA PRO SPOTLIGHT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.emeraldGreen,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const Icon(Icons.verified_rounded,
                          color: AppColors.emeraldGreen, size: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'ELITE HYPERTROPHY PROTOCOL',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kas fibrillerini maksimum uyaran 4 haftalık profesyonel hipertrofi ve hacim serisi.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.75),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildHeroTag('4 Hafta'),
                      const SizedBox(width: 8),
                      _buildHeroTag('18 Antrenman'),
                      const SizedBox(width: 8),
                      _buildHeroTag('Özel Koç Onaylı'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        _showWorkoutDetailSummaryModal({
                          'rank': 'PRO',
                          'title': 'ELITE HYPERTROPHY PROTOCOL',
                          'subtitle': '4 Haftalık Yoğun Kas Kazanım Serisi',
                          'duration': '50 Dk / Seans',
                          'level': 'Tüm Seviyeler',
                          'targetMuscle': 'Tüm Vücut & İskelet Sistemi',
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emeraldGreen,
                        foregroundColor: AppColors.obsidianBlack,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'PROGRAMI İNCELE & BAŞLAT',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. POPÜLER AURA SERİLERİ (Yatay Şık Kartlar)
            const Text(
              'ÖZEL AURA SERİLERİ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.obsidianBlack,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _popularSeries.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final series = _popularSeries[index];
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showWorkoutDetailSummaryModal(series);
                    },
                    child: Container(
                      width: 240,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
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
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.emeraldGreen
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  series['rank'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.emeraldGreen,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  size: 14, color: AppColors.textMuted),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                series['title'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.obsidianBlack,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                series['subtitle'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.timer_outlined,
                                  size: 14, color: AppColors.emeraldGreen),
                              const SizedBox(width: 4),
                              Text(
                                series['duration'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.obsidianBlack,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                series['targetMuscle'],
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.emeraldGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // 3. HAFTALIK GÜNLÜK ANTRENMAN AKORDİYON MENÜSÜ
            const Text(
              'GÜNLÜK ANTRENMAN RUTİNİN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.obsidianBlack,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),

            ..._workoutDays.map((day) => _buildExpandableDayCard(day)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildExpandableDayCard(Map<String, dynamic> day) {
    final exercises = day['exercises'] as List<Map<String, dynamic>>;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: day['isInitiallyExpanded'] == true,
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          childrenPadding:
              const EdgeInsets.only(left: 18, right: 18, bottom: 18),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.emeraldGreen.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(day['icon'] as IconData,
                color: AppColors.emeraldGreen, size: 24),
          ),
          title: Text(
            day['dayTitle'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.obsidianBlack,
            ),
          ),
          subtitle: Text(
            day['subtitle'],
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          children: exercises.map((ex) {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          ex['title'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.obsidianBlack,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          ex['targetMuscle'],
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.emeraldGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '💡 ${ex['tip']}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Set ve Tekrar Butonları
                  Row(
                    children: List.generate(ex['sets'] as int, (setIndex) {
                      final setNum = setIndex + 1;
                      final setKey = '${ex['id']}_set_$setNum';
                      final isCompleted = _completedSets.contains(setKey);

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _toggleSet(setKey),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.only(
                                right: setIndex < (ex['sets'] as int) - 1
                                    ? 6
                                    : 0),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppColors.emeraldGreen
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isCompleted
                                    ? AppColors.emeraldGreen
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isCompleted
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  size: 14,
                                  color: isCompleted
                                      ? Colors.white
                                      : AppColors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$setNum. Set',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: isCompleted
                                        ? Colors.white
                                        : AppColors.obsidianBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
