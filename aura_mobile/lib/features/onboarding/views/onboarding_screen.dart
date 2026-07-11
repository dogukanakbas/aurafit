import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptic_feedback_helper.dart';
import '../../../core/widgets/haptic_button.dart';
import '../models/trainer_match_model.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onCompleted;

  const OnboardingScreen({super.key, required this.onCompleted});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Adım 1 verileri
  String _selectedGoal = 'Kas Yap ve Güçlen';
  final TextEditingController _weightController = TextEditingController(text: '75');
  final TextEditingController _heightController = TextEditingController(text: '178');

  // Adım 2 verileri (AI Koç Eşleştirme)
  int _selectedTrainerIndex = 0;
  final List<TrainerMatch> _trainers = [
    TrainerMatch(
      id: '1',
      fullName: 'Atlas Demir',
      specialty: 'Hipertrofi & Güç Kondisyonu',
      bio: 'Olimpik ağırlık kaldırma ve elit atlet beslenmesinde 8 yıl tecrübe.',
      avatarUrl: 'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=600&q=80',
      aiMatchScore: 94,
      tag: 'Hedeflerinle %94 Eşleşiyor',
    ),
    TrainerMatch(
      id: '2',
      fullName: 'Selin Yılmaz',
      specialty: 'Yağ Yakımı & HIIT Uzmanı',
      bio: 'Metabolik yeniden yapılandırma ve postüral stabilizasyon.',
      avatarUrl: 'https://images.unsplash.com/photo-1548690312-e3b507d8c110?auto=format&fit=crop&w=600&q=80',
      aiMatchScore: 91,
      tag: 'Hedeflerinle %91 Eşleşiyor',
    ),
    TrainerMatch(
      id: '3',
      fullName: 'Caner Özkan',
      specialty: 'Dayanıklılık & Mobilite',
      bio: 'Maraton hazırlığı ve sakatlık önleyici antrenman periyodizasyonu.',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
      aiMatchScore: 88,
      tag: 'Hedeflerinle %88 Eşleşiyor',
    ),
  ];

  // Adım 3 verileri (KVKK)
  bool _kvkkApproved = false;

  void _nextPage() {
    HapticHelper.triggerLightImpact();
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      if (!_kvkkApproved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen KVKK ve Üyelik Sözleşmesini onaylayın.')),
        );
        return;
      }
      widget.onCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // İlerleme çubuğu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(3, (index) {
                  final isActive = index <= _currentStep;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 5,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Theme.of(context).primaryColor
                            : Colors.grey.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (idx) => setState(() => _currentStep = idx),
                children: [
                  _buildStep1GoalForm(),
                  _buildStep2TrainerSwipe(),
                  _buildStep3KvkkConsent(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: HapticButton(
                  onPressed: _nextPage,
                  child: Text(_currentStep == 2 ? 'AURA\'YI BAŞLAT' : 'DEVAM ET'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ADIM 1: Fiziksel özellikler ve hedef
  Widget _buildStep1GoalForm() {
    final goals = ['Kilo Ver & Yağ Yak', 'Kas Yap ve Güçlen', 'Dayanıklılık & Kondisyon', 'Formu Koru'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Hedefin Ne?', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 8),
          Text('Sana en uygun koçu ve AI programı belirleyelim.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Boy (cm)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Kilo (kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Birincil Odak', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, idx) {
                final goal = goals[idx];
                final selected = _selectedGoal == goal;
                return GestureDetector(
                  onTap: () {
                    HapticHelper.triggerLightImpact();
                    setState(() => _selectedGoal = goal);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.emeraldGreen.withOpacity(0.12)
                          : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? AppColors.emeraldGreen : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(goal,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                )),
                        if (selected)
                          const Icon(Icons.check_circle, color: AppColors.emeraldGreen),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ADIM 2: Yatay Kaydırmalı Koç Kartları
  Widget _buildStep2TrainerSwipe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('AI Koç Eşleşmen', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 6),
              Text('Seçtiğin hedeflerle uyumlu en iyi 3 uzman koç',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            onPageChanged: (idx) {
              HapticHelper.triggerLightImpact();
              setState(() => _selectedTrainerIndex = idx);
            },
            itemCount: _trainers.length,
            itemBuilder: (context, idx) {
              final trainer = _trainers[idx];
              final isSelected = _selectedTrainerIndex == idx;
              return AnimatedScale(
                scale: isSelected ? 1.0 : 0.93,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? AppColors.emeraldGreen : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Match Skor rozeti
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bolt, color: AppColors.emeraldGreen, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              trainer.tag,
                              style: const TextStyle(
                                color: AppColors.emeraldGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Koç adı ve uzmanlık
                      Text(trainer.fullName,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        trainer.specialty,
                        style: const TextStyle(
                          color: AppColors.limeGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(trainer.bio,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const Spacer(),
                      if (isSelected)
                        Row(
                          children: const [
                            Icon(Icons.check_circle, color: AppColors.emeraldGreen),
                            SizedBox(width: 8),
                            Text('Seçili Koç', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ADIM 3: KVKK ve Kayıt Tamamlama
  Widget _buildStep3KvkkConsent() {
    final chosenTrainer = _trainers[_selectedTrainerIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Son Adım', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 8),
          Text('${chosenTrainer.fullName} ile AURA yolculuğuna başlamak üzeresin.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Özet Bilgilerin', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Seçilen Hedef: $_selectedGoal'),
                Text('Koç: ${chosenTrainer.fullName} (${chosenTrainer.specialty})'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _kvkkApproved,
                activeColor: AppColors.emeraldGreen,
                onChanged: (val) {
                  HapticHelper.triggerLightImpact();
                  setState(() => _kvkkApproved = val ?? false);
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticHelper.triggerLightImpact();
                    setState(() => _kvkkApproved = !_kvkkApproved);
                  },
                  child: const Text(
                    'KVKK Aydınlatma Metni\'ni ve AURA Koçluk Hizmet Sözleşmesi\'ni okudum, onaylıyorum.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
