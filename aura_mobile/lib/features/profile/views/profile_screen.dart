import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';
import '../../auth/views/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 1. ÖLÇÜM VERİLERİ VE GRAFİK NOKTALARI
  final List<FlSpot> _weightSpots = [
    const FlSpot(1, 84.0),
    const FlSpot(2, 82.5),
    const FlSpot(3, 81.2),
    const FlSpot(4, 79.8),
  ];

  final List<Map<String, dynamic>> _measurementLogs = [
    {
      'date': '11 Tem 2026',
      'weight': 79.8,
      'waist': 82.0,
      'chest': 105.0,
      'arm': 39.5,
      'fat': 13.8,
    },
    {
      'date': '04 Tem 2026',
      'weight': 81.2,
      'waist': 84.0,
      'chest': 104.5,
      'arm': 39.0,
      'fat': 14.5,
    },
  ];

  // 2. GELİŞİM FOTOĞRAFLARI
  final List<Map<String, dynamic>> _progressPhotos = [
    {
      'label': 'BEFORE (1. Ay)',
      'date': '11 Haz 2026',
      'url':
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=400&q=80',
      'isLocal': false,
    },
    {
      'label': 'AFTER (Güncel - Ön/Yan)',
      'date': '11 Tem 2026',
      'url':
          'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=400&q=80',
      'isLocal': false,
    },
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _takeProgressPhoto(String label) async {
    HapticFeedback.lightImpact();
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 85,
      );

      if (photo != null && mounted) {
        setState(() {
          _progressPhotos.insert(0, {
            'label': label,
            'date': 'Bugün',
            'url': photo.path,
            'isLocal': true,
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📸 "$label" etiketli gelişim fotoğrafınız kaydedildi!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kamera açılırken bir sorun oluştu. Simülatörde galeri kullanılabilir.'),
          ),
        );
      }
    }
  }

  void _showAddMeasurementModal() {
    final weightCtrl = TextEditingController(text: '79.2');
    final waistCtrl = TextEditingController(text: '81.5');
    final chestCtrl = TextEditingController(text: '105.5');
    final armCtrl = TextEditingController(text: '39.8');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.lightSurface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YENİ VÜCUT ÖLÇÜSÜ VE KİLO GİR',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.obsidianBlack,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _buildModalInput(
                            weightCtrl, 'Kilo (KG)', Icons.monitor_weight_rounded)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildModalInput(
                            waistCtrl, 'Bel (CM)', Icons.straighten_rounded)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _buildModalInput(
                            chestCtrl, 'Göğüs (CM)', Icons.accessibility_new_rounded)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildModalInput(
                            armCtrl, 'Kol (CM)', Icons.fitness_center_rounded)),
                  ],
                ),
                const SizedBox(height: 24),
                PremiumButton(
                  onPressed: () {
                    final double? newW = double.tryParse(weightCtrl.text);
                    if (newW != null) {
                      HapticFeedback.heavyImpact();
                      setState(() {
                        _weightSpots.add(
                            FlSpot((_weightSpots.length + 1).toDouble(), newW));
                        _measurementLogs.insert(0, {
                          'date': 'Bugün',
                          'weight': newW,
                          'waist': double.tryParse(waistCtrl.text) ?? 81.0,
                          'chest': double.tryParse(chestCtrl.text) ?? 105.0,
                          'arm': double.tryParse(armCtrl.text) ?? 39.5,
                          'fat': 13.5,
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              '📏 Yeni ölçüleriniz grafiğe eklendi ve koçunuza bildirildi!'),
                        ),
                      );
                    }
                  },
                  label: 'GRAFİĞİ GÜNCELLE & KAYDET',
                  icon: Icons.save_rounded,
                  isPrimary: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWeeklyCheckInModal() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Haftalık Check-in Gönderildi! 🎉'),
        content: const Text(
          'Antrenman uyumunuz (%94) ve uyku kaliteniz koçunuz Atlas Demir ile paylaşıldı.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('HARİKA',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.emeraldGreen)),
          ),
        ],
      ),
    );
  }

  void _logout() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'DANIŞAN PROFİLİ & GELİŞİM MERKEZİ',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppColors.obsidianBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.warning),
            tooltip: 'Çıkış Yap',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. KULLANICI DEMOGRAFİ & ÜYELİK BİTİŞ TARİHİ KARTI
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ERLİK HAN',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Hedef: Yağ Yak & Kas Kazan',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'PRO DANIŞAN',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildProfileStat('Üyelik Bitiş', '04 Ağu 2026'),
                        _buildProfileStat('Kalan Süre', '24 Gün'),
                        _buildProfileStat('Koçum', 'Atlas Demir'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. SÖZLEŞME ONAYLARI BİLGİ KARTI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.emeraldGreen, width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user_rounded,
                        color: AppColors.emeraldGreen, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KVKK & B2B2C HİZMET SÖZLEŞMESİ ONAYLI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.obsidianBlack,
                          ),
                        ),
                        Text(
                          'IP: 195.175.24.88 • Biyometrik Veri İzin Damgalı',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. FL_CHART KİLO / VÜCUT ÖLÇÜLERİ GRAFİĞİ & ÖLÇÜ EKLEME
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'VÜCUT KİLO GELİŞİM GRAFİĞİ (KG)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: AppColors.textMuted,
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddMeasurementModal,
                  icon: const Icon(Icons.add_circle_rounded,
                      size: 18, color: AppColors.emeraldGreen),
                  label: const Text(
                    'Ölçü Gir',
                    style: TextStyle(
                      color: AppColors.emeraldGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _weightSpots,
                            isCurved: true,
                            color: AppColors.emeraldGreen,
                            barWidth: 4,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.emeraldGreen
                                  .withValues(alpha: 0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. ÖLÇÜ DÖKÜMLERİ
            const Text(
              'SON GİRİLEN VÜCUT ÖLÇÜLERİ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            ..._measurementLogs.map((m) => _buildMeasurementRow(m)),
            const SizedBox(height: 24),

            // 5. GELİŞİM FOTOĞRAF ÇEK & YÜKLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'GELİŞİM FOTOĞRAFLARI (BEFORE/AFTER)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (val) => _takeProgressPhoto(val),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: 'ÖN GÖRÜNÜM (FRONT)',
                        child: Text('📸 Ön Görünüm Çek')),
                    const PopupMenuItem(
                        value: 'YAN GÖRÜNÜM (SIDE)',
                        child: Text('📸 Yan Görünüm Çek')),
                    const PopupMenuItem(
                        value: 'ARKA GÖRÜNÜM (BACK)',
                        child: Text('📸 Arka Görünüm Çek')),
                  ],
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_rounded,
                            size: 16, color: AppColors.emeraldGreen),
                        SizedBox(width: 4),
                        Text('Fotoğraf Çek',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.emeraldGreen)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _progressPhotos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (_, index) {
                  final item = _progressPhotos[index];
                  final bool isLocal = item['isLocal'] == true;
                  return Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(22)),
                            child: isLocal
                                ? Image.file(File(item['url']),
                                    fit: BoxFit.cover)
                                : Image.network(item['url'],
                                    fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['label'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.obsidianBlack)),
                              Text(item['date'],
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            PremiumButton(
              onPressed: _showWeeklyCheckInModal,
              label: 'CHECK-IN RAPORU GÖNDER',
              icon: Icons.send_rounded,
              isPrimary: true,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildModalInput(
      TextEditingController ctrl, String label, IconData icon) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: AppColors.emeraldGreen),
        filled: true,
        fillColor: AppColors.lightBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementRow(Map<String, dynamic> m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(m['date'],
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.obsidianBlack)),
          Text(
            '${m['weight']} KG • Bel: ${m['waist']} CM • Kol: ${m['arm']} CM',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
