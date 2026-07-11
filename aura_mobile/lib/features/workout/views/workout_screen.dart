import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  static const String _cacheKey = 'aura_cached_workout_accordion_v1';
  bool _isLoading = true;
  bool _isOfflineMode = false;
  final Set<String> _completedSets = {};

  final List<Map<String, dynamic>> _workoutDays = [
    {
      'dayId': 'day_1',
      'dayTitle': '1. GÜN • GÖĞÜS & ÖN KOL (PAZARTESİ)',
      'subtitle': '3 Egzersiz • Tahmini 45 Dk',
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
          'tip': 'Barı göğüs ucuna kontrollü indir, dirsekleri %45 açıda tut.',
          'videoUrl': 'https://www.youtube.com/watch?v=gRVjAtPip0Y',
        },
        {
          'id': 'd1_ex_2',
          'title': 'Incline Dumbbell Press',
          'targetMuscle': 'Üst Göğüs',
          'sets': 3,
          'reps': '10 - 12 Tekrar',
          'rest': '60 sn',
          'tip': 'Sehpa açısını 30 dereceye ayarla, tepe noktada göğsü sık.',
          'videoUrl': 'https://www.youtube.com/watch?v=SrqOu55lrYU',
        },
        {
          'id': 'd1_ex_3',
          'title': 'EZ Barbell Curl',
          'targetMuscle': 'Ön Kol (Biceps)',
          'sets': 3,
          'reps': '12 Tekrar',
          'rest': '45 sn',
          'tip': 'Dirsekleri gövdeye sabitle, belden vurma yapmadan kaldır.',
          'videoUrl': 'https://www.youtube.com/watch?v=Iwe6AmxVf7o',
        },
      ],
    },
    {
      'dayId': 'day_2',
      'dayTitle': '2. GÜN • SIRT & ARKA KOL (ÇARŞAMBA)',
      'subtitle': '3 Egzersiz • Tahmini 50 Dk',
      'icon': Icons.shield_rounded,
      'isInitiallyExpanded': false,
      'exercises': [
        {
          'id': 'd2_ex_1',
          'title': 'Lat Pulldown (Geniş Tutuş)',
          'targetMuscle': 'Kanat (Latissimus)',
          'sets': 4,
          'reps': '10 Tekrar',
          'rest': '60 sn',
          'tip': 'Barı göğsünün üstüne çekerken kürek kemiklerini sıkıştır.',
          'videoUrl': 'https://www.youtube.com/watch?v=CAwf7n6Luuc',
        },
        {
          'id': 'd2_ex_2',
          'title': 'Bent-Over Barbell Row',
          'targetMuscle': 'Orta Sırt',
          'sets': 4,
          'reps': '8 - 10 Tekrar',
          'rest': '75 sn',
          'tip': 'Sırtı düz tutarak barı karın boşluğuna doğru çek.',
          'videoUrl': 'https://www.youtube.com/watch?v=G8l_8chR5BE',
        },
        {
          'id': 'd2_ex_3',
          'title': 'Rope Triceps Pushdown',
          'targetMuscle': 'Arka Kol (Triceps)',
          'sets': 3,
          'reps': '12 - 15 Tekrar',
          'rest': '45 sn',
          'tip': 'Halatı aşağı bastırırken ellerini dışa doğru aç.',
          'videoUrl': 'https://www.youtube.com/watch?v=vB5OHsJ3EME',
        },
      ],
    },
    {
      'dayId': 'day_3',
      'dayTitle': '3. GÜN • BACAK & OMUZ (CUMA)',
      'subtitle': '3 Egzersiz • Tahmini 55 Dk',
      'icon': Icons.bolt_rounded,
      'isInitiallyExpanded': false,
      'exercises': [
        {
          'id': 'd3_ex_1',
          'title': 'Barbell Back Squat',
          'targetMuscle': 'Ön Bacak & Kalça',
          'sets': 4,
          'reps': '8 Tekrar',
          'rest': '120 sn',
          'tip': 'Dizler ayak parmak yönünü takip etmeli, derin çök.',
          'videoUrl': 'https://www.youtube.com/watch?v=bEv6CCg2BC8',
        },
        {
          'id': 'd3_ex_2',
          'title': 'Seated Dumbbell Shoulder Press',
          'targetMuscle': 'Ön & Yan Omuz',
          'sets': 3,
          'reps': '10 Tekrar',
          'rest': '60 sn',
          'tip': 'Dambılları kulak hizasına kadar indir ve yukarı presle.',
          'videoUrl': 'https://www.youtube.com/watch?v=qEwKCR5JCog',
        },
        {
          'id': 'd3_ex_3',
          'title': 'Dumbbell Lateral Raise',
          'targetMuscle': 'Yan Omuz',
          'sets': 4,
          'reps': '15 Tekrar',
          'rest': '45 sn',
          'tip': 'Dirsekler hafif bükülü, omuz hizasına kadar yana aç.',
          'videoUrl': 'https://www.youtube.com/watch?v=3VcKaXpzqRo',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
  }

  Future<void> _loadWorkoutData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(_workoutDays));
      setState(() {
        _isOfflineMode = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isOfflineMode = true;
        _isLoading = false;
      });
    }
  }

  void _toggleSet(String exerciseId, int setNum) {
    HapticFeedback.mediumImpact();
    final key = '${exerciseId}_set_$setNum';
    setState(() {
      if (_completedSets.contains(key)) {
        _completedSets.remove(key);
      } else {
        _completedSets.add(key);
      }
    });
  }

  void _showVideoGuideModal(Map<String, dynamic> exercise) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${exercise['title']} • Doğru Form Guide',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.obsidianBlack),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=800&q=80',
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 220,
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.emeraldGreen
                                .withValues(alpha: 0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 36),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'KOÇUN TAVSİYESİ:',
                style: TextStyle(
                  color: AppColors.emeraldGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                exercise['tip'],
                style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.obsidianBlack,
                    fontWeight: FontWeight.w600,
                    height: 1.4),
              ),
              const Spacer(),
              PremiumButton(
                onPressed: () => Navigator.pop(context),
                label: 'ANLADIM, ANTRENMANA DÖN',
                isPrimary: true,
              ),
            ],
          ),
        );
      },
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
              'ANTRENMAN PROGRAMLARIM',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.obsidianBlack,
              ),
            ),
            Text(
              'Açılır menülerden gününüzü seçin ve antrenmana başlayın',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ..._workoutDays.map((day) => _buildExpandableDayAccordion(day)),
            const SizedBox(height: 16),
            PremiumButton(
              onPressed: () {
                HapticFeedback.heavyImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tebrikler! Günlük antrenman programın başarıyla tamamlandı 🏆'),
                    backgroundColor: AppColors.emeraldGreen,
                  ),
                );
              },
              label: 'ANTRENMAN GÜNÜNÜ TAMAMLA',
              icon: Icons.emoji_events_rounded,
              isPrimary: true,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableDayAccordion(Map<String, dynamic> day) {
    final List<Map<String, dynamic>> exercises =
        List<Map<String, dynamic>>.from(day['exercises']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
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
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.emeraldGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(day['icon'] ?? Icons.fitness_center_rounded,
                color: AppColors.emeraldGreen, size: 22),
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
          children: exercises.map((ex) => _buildExerciseCard(ex)).toList(),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    final int setsCount = exercise['sets'];

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
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
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      exercise['title'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.obsidianBlack,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => _showVideoGuideModal(exercise),
                icon: const Icon(Icons.play_circle_fill_rounded,
                    color: AppColors.emeraldGreen, size: 18),
                label: const Text(
                  'Form Video',
                  style: TextStyle(
                    color: AppColors.emeraldGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            exercise['tip'],
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppColors.emeraldGreen
                        : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDone
                          ? AppColors.emeraldGreen
                          : Colors.grey.shade400,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDone
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        size: 15,
                        color:
                            isDone ? Colors.white : AppColors.obsidianBlack,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$setNum. SET',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isDone
                              ? Colors.white
                              : AppColors.obsidianBlack,
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
