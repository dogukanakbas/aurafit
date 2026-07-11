import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool _isLoading = true;
  bool _isOfflineMode = false;
  List<Map<String, dynamic>> _exercises = [];
  final Set<String> _completedSets = {};

  static const String _cacheKey = 'cached_workout_plan_v2';

  // Varsayılan Zengin Egzersiz JSON Verisi
  final List<Map<String, dynamic>> _defaultExercises = [
    {
      'id': 'ex_1',
      'title': 'Barbell Bench Press',
      'targetMuscle': 'Göğüs & Ön Omuz',
      'sets': 4,
      'reps': '8 - 10 Tekrar',
      'rest': '90 sn',
      'tip': 'Barı göğüs ucuna kontrollü indir, dirsekleri %45 açıda tut.',
      'videoUrl': 'https://www.youtube.com/watch?v=gRVjAtPip0Y',
    },
    {
      'id': 'ex_2',
      'title': 'Incline Dumbbell Press',
      'targetMuscle': 'Üst Göğüs',
      'sets': 3,
      'reps': '10 - 12 Tekrar',
      'rest': '60 sn',
      'tip': 'Sehpa açısını 30 dereceye ayarla, tepe noktada göğsü sık.',
      'videoUrl': 'https://www.youtube.com/watch?v=SrqOu55lrYU',
    },
    {
      'id': 'ex_3',
      'title': 'Cable Flyes (High to Low)',
      'targetMuscle': 'Alt Göğüs İzole',
      'sets': 3,
      'reps': '12 - 15 Tekrar',
      'rest': '45 sn',
      'tip': 'Kabloları birleştirirken 1 saniye izometrik kasılma uygula.',
      'videoUrl': 'https://www.youtube.com/watch?v=Iwe6AmxVf7o',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
  }

  /// 1. JSON tabanlı Workout verisini shared_preferences ile önbelleğe alan fonksiyon
  Future<void> _loadWorkoutData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();

      // Çevrimiçi ağ senaryosunu simüle edip yerel önbelleğe (SharedPreferences) kaydet
      final jsonString = jsonEncode(_defaultExercises);
      await prefs.setString(_cacheKey, jsonString);

      setState(() {
        _exercises = _defaultExercises;
        _isOfflineMode = false;
        _isLoading = false;
      });
    } catch (e) {
      // Çevrimdışı (Offline) durum: SharedPreferences önbelleğinden getir
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_cacheKey);
      if (cachedJson != null) {
        final decoded = List<Map<String, dynamic>>.from(jsonDecode(cachedJson));
        setState(() {
          _exercises = decoded;
          _isOfflineMode = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _exercises = _defaultExercises;
          _isOfflineMode = true;
          _isLoading = false;
        });
      }
    }
  }

  /// 2. Set onaylandığında mediumImpact titremesi ve set durumunu değiştirme
  void _toggleSet(String exerciseId, int setIndex) {
    HapticFeedback.mediumImpact();
    final key = '${exerciseId}_set_$setIndex';
    setState(() {
      if (_completedSets.contains(key)) {
        _completedSets.remove(key);
      } else {
        _completedSets.add(key);
      }
    });

    // Eğer tüm setler tamamlandıysa otomatik kutlama kontrolü
    final totalSets = _exercises.fold<int>(0, (sum, e) => sum + (e['sets'] as int));
    if (_completedSets.length == totalSets) {
      _triggerCelebrationAnimation();
    }
  }

  /// "Doğru Form Videosu İzle" modalı
  void _showVideoGuideModal(Map<String, dynamic> exercise) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.play_circle_fill_rounded,
                      color: AppColors.emeraldGreen, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Doğru Biyomekanik Form Rehberi',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded,
                      color: AppColors.emeraldGreen, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      exercise['tip'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PremiumButton(
              onPressed: () => Navigator.pop(context),
              label: 'ANLADIM, ANTRENMANA DÖN',
              isPrimary: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// 3. Antrenman bittiğinde ekranı kaplayan "Tebrikler" Lottie animasyonu
  void _triggerCelebrationAnimation() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: Lottie.asset(
                  'assets/lottie/celebration.json',
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.emoji_events_rounded,
                          size: 100, color: AppColors.warning),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'TEBRİKLER ŞAMPİYON! 🏆',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.obsidianBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Bugünkü tüm egzersiz setlerini başarıyla tamamladın ve aktivite halkalarını doldurdun.',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PremiumButton(
                onPressed: () => Navigator.pop(context),
                label: 'HARİKA!',
                isPrimary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.emeraldGreen)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ANTRENMAN PROGRAMI',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.obsidianBlack,
              ),
            ),
            if (_isOfflineMode)
              Row(
                children: const [
                  Icon(Icons.offline_bolt_rounded,
                      color: AppColors.warning, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Çevrimdışı Mod - Önbellek Aktif',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_done_rounded,
                color: AppColors.emeraldGreen),
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Antrenman verileri önbellekte güvende ✅')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ..._exercises.map((exercise) => _buildExerciseCard(exercise)),
            const SizedBox(height: 24),
            PremiumButton(
              onPressed: _triggerCelebrationAnimation,
              label: 'ANTRENMANI TAMAMLA & KUTLA',
              icon: Icons.emoji_events_rounded,
              isPrimary: true,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    final int setsCount = exercise['sets'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise['targetMuscle'].toString().toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.emeraldGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exercise['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.obsidianBlack,
                      ),
                    ),
                  ],
                ),
              ),
              // "Doğru Form Videosu İzle" Butonu
              TextButton.icon(
                onPressed: () => _showVideoGuideModal(exercise),
                icon: const Icon(Icons.play_circle_fill_rounded,
                    color: AppColors.emeraldGreen, size: 20),
                label: const Text(
                  'Form Video',
                  style: TextStyle(
                    color: AppColors.emeraldGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            exercise['tip'],
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Her Bir Set İçin Titreşimli Onay Checkbox'ları (HapticFeedback.mediumImpact)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(setsCount, (index) {
              final setNum = index + 1;
              final key = '${exercise['id']}_set_$setNum';
              final isDone = _completedSets.contains(key);

              return GestureDetector(
                onTap: () => _toggleSet(exercise['id'], setNum),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppColors.emeraldGreen
                        : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDone
                          ? AppColors.emeraldGreen
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isDone
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: isDone ? Colors.white : AppColors.textMuted,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Set $setNum',
                        style: TextStyle(
                          color:
                              isDone ? Colors.white : AppColors.obsidianBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
