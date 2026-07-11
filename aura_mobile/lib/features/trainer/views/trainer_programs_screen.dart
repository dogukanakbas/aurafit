import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';

class TrainerProgramsScreen extends StatefulWidget {
  const TrainerProgramsScreen({super.key});

  @override
  State<TrainerProgramsScreen> createState() => _TrainerProgramsScreenState();
}

class _TrainerProgramsScreenState extends State<TrainerProgramsScreen> {
  String _selectedClient = 'Erlik Han';
  int _selectedDayNumber = 1;
  bool _isWorkoutTab = true; // true: Workout Form, false: Diet Form
  bool _useTemplate = false; // Hazır Şablon kullanıp kullanmayacağı

  String _selectedTemplate = 'Hipertrofi Şablonu A (4 Günlük İtme/Çekme/Bacak)';

  final List<String> _workoutTemplates = [
    'Hipertrofi Şablonu A (4 Günlük İtme/Çekme/Bacak)',
    'Yağ Yakım & HIIT Şablonu (3 Günlük Tüm Vücut)',
    'Güç ve Powerlifting Şablonu (5 Günlük Pro)',
  ];

  final List<String> _dietTemplates = [
    'Definisyon & Yağ Yakımı (1800 Kcal / Yüksek Protein)',
    'Temiz Kas Kazanımı (2800 Kcal / Dengeli Makro)',
    'Ketojenik Diyet Şablonu (2100 Kcal)',
  ];

  final TextEditingController _workoutTitleController =
      TextEditingController(text: '1. Gün • İtme (Push) Antrenmanı');
  final TextEditingController _exerciseJsonController = TextEditingController(
    text: const JsonEncoder.withIndent('  ').convert([
      {
        'title': 'Barbell Bench Press',
        'sets': 4,
        'reps': '8 - 10 Tekrar',
        'rest': '90 sn',
        'tip': 'Tepe noktada göğsü sık, barı göğüs ucuna kontrollü indir.'
      },
      {
        'title': 'Incline Dumbbell Press',
        'sets': 3,
        'reps': '10 - 12 Tekrar',
        'rest': '60 sn',
        'tip': 'Sehpa açısını 30 dereceye ayarla.'
      }
    ]),
  );

  final TextEditingController _caloriesController =
      TextEditingController(text: '2450');
  final TextEditingController _proteinController =
      TextEditingController(text: '185');
  final TextEditingController _carbController =
      TextEditingController(text: '260');
  final TextEditingController _fatController =
      TextEditingController(text: '65');

  void _saveAssignedProgram() {
    HapticFeedback.heavyImpact();
    final String msg = _useTemplate
        ? '⚡ "$_selectedTemplate" şablonu $_selectedClient öğrencisine TEK TIKLA ATANDI!'
        : (_isWorkoutTab
            ? '✅ $_selectedClient için $_selectedDayNumber. Gün Özel Antrenman Programı Atandı!'
            : '✅ $_selectedClient için $_selectedDayNumber. Gün Özel Beslenme Programı Atandı!');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    _workoutTitleController.dispose();
    _exerciseJsonController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'PROGRAM & ŞABLON ATAMA MERKEZİ',
          style: TextStyle(
            fontSize: 18,
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
            // Danışan Seçimi Kartı
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROGRAM ATANACAK ÖĞRENCİ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedClient,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: ['Erlik Han', 'Zeynep Kaya', 'Mert Yılmaz']
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedClient = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'HAZIR KOÇ ŞABLONU KULLAN',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.obsidianBlack,
                        ),
                      ),
                      Switch(
                        value: _useTemplate,
                        activeThumbColor: AppColors.emeraldGreen,
                        onChanged: (val) {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _useTemplate = val;
                            _selectedTemplate = _isWorkoutTab
                                ? _workoutTemplates.first
                                : _dietTemplates.first;
                          });
                        },
                      ),
                    ],
                  ),
                  if (!_useTemplate) ...[
                    const SizedBox(height: 12),
                    Text(
                      'PROGRAM GÜNÜ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(7, (i) {
                          final day = i + 1;
                          final bool isSel = _selectedDayNumber == day;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text('Gün $day',
                                  style: TextStyle(
                                      color: isSel
                                          ? Colors.white
                                          : AppColors.obsidianBlack,
                                      fontWeight: FontWeight.w700)),
                              selected: isSel,
                              selectedColor: AppColors.emeraldGreen,
                              backgroundColor: AppColors.lightBackground,
                              onSelected: (_) {
                                HapticFeedback.lightImpact();
                                setState(() => _selectedDayNumber = day);
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Workout / Diet Sekmeleri
            Row(
              children: [
                Expanded(
                  child: _buildTabBtn('ANTRENMAN', _isWorkoutTab, () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _isWorkoutTab = true;
                      if (_useTemplate) {
                        _selectedTemplate = _workoutTemplates.first;
                      }
                    });
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTabBtn('BESLENME & MAKRO', !_isWorkoutTab, () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _isWorkoutTab = false;
                      if (_useTemplate) {
                        _selectedTemplate = _dietTemplates.first;
                      }
                    });
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (_useTemplate)
              _buildTemplatePickerSection()
            else if (_isWorkoutTab)
              _buildWorkoutForm()
            else
              _buildDietForm(),

            const SizedBox(height: 28),
            PremiumButton(
              onPressed: _saveAssignedProgram,
              label: _useTemplate
                  ? 'ŞABLONU ÖĞRENCİYE ATA'
                  : (_isWorkoutTab
                      ? 'ANTRENMANI DANIŞANA ATA'
                      : 'BESLENMEYİ DANIŞANA ATA'),
              icon: _useTemplate
                  ? Icons.bolt_rounded
                  : Icons.check_circle_rounded,
              isPrimary: true,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBtn(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.emeraldGreen : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color:
                  isActive ? AppColors.emeraldGreen : Colors.grey.shade200),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.obsidianBlack,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildTemplatePickerSection() {
    final list = _isWorkoutTab ? _workoutTemplates : _dietTemplates;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.emeraldGreen, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bookmark_rounded,
                  color: AppColors.emeraldGreen, size: 22),
              const SizedBox(width: 8),
              Text(
                _isWorkoutTab
                    ? 'KOÇ HAZIR ANTRENMAN ŞABLONLARI'
                    : 'KOÇ HAZIR BESLENME ŞABLONLARI',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.obsidianBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedTemplate,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.lightBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            items: list
                .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13)),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedTemplate = val);
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Tek tıkla atadığında tüm günlerin egzersiz setleri, molalar veya makro hedefleri öğrencinin takvimine otomatik yüklenir.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutForm() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ANTRENMAN BAŞLIGI',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted)),
          const SizedBox(height: 8),
          _buildInput(_workoutTitleController, 'Örn: İtme (Push) Günü'),
          const SizedBox(height: 18),
          Text('EGZERSİZ MİKROSKOPİSİ (JSON FORMATI)',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
            ),
            child: TextField(
              controller: _exerciseJsonController,
              maxLines: 10,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.35,
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietForm() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('GÜNLÜK KALORİ HEDEFİ (KCAL)',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted)),
          const SizedBox(height: 8),
          _buildInput(_caloriesController, '2450'),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PROTEİN (G)',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMuted)),
                    const SizedBox(height: 8),
                    _buildInput(_proteinController, '185'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('KARB (G)',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMuted)),
                    const SizedBox(height: 8),
                    _buildInput(_carbController, '260'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('YAĞ (G)',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMuted)),
                    const SizedBox(height: 8),
                    _buildInput(_fatController, '65'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF64748B)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
