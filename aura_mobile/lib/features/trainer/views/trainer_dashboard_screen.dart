import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';
import '../../auth/views/auth_screen.dart';
import 'trainer_notification_broadcast_screen.dart';
import '../../notifications/views/notifications_screen.dart';

class TrainerDashboardScreen extends StatefulWidget {
  const TrainerDashboardScreen({super.key});

  @override
  State<TrainerDashboardScreen> createState() => _TrainerDashboardScreenState();
}

class _TrainerDashboardScreenState extends State<TrainerDashboardScreen> {
  final List<Map<String, dynamic>> _students = [
    {
      'id': 's_1',
      'name': 'Erlik Han',
      'goal': 'Yağ Yak & Kas Kazan',
      'compliance': 92,
      'remainingDays': 24,
      'isActive': true,
      'avatar':
          'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80',
      'lastCheckIn': 'Bugün',
      'weightHistory': [84.0, 82.5, 81.2, 79.8],
      'beforePhoto':
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=400&q=80',
      'afterPhoto':
          'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=400&q=80',
    },
    {
      'id': 's_2',
      'name': 'Zeynep Kaya',
      'goal': 'Hipertrofi & Güç',
      'compliance': 88,
      'remainingDays': 15,
      'isActive': true,
      'avatar':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      'lastCheckIn': 'Dün',
      'weightHistory': [58.0, 59.2, 60.1, 61.0],
      'beforePhoto':
          'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=400&q=80',
      'afterPhoto':
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=400&q=80',
    },
    {
      'id': 's_3',
      'name': 'Mert Yılmaz',
      'goal': 'Kondisyon & Dayanıklılık',
      'compliance': 74,
      'remainingDays': 4,
      'isActive': false,
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      'lastCheckIn': '3 gün önce',
      'weightHistory': [92.0, 91.0, 90.5, 89.9],
      'beforePhoto':
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=400&q=80',
      'afterPhoto':
          'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=400&q=80',
    },
  ];

  void _logout() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  void _toggleStudentStatus(Map<String, dynamic> student) {
    HapticFeedback.mediumImpact();
    setState(() {
      student['isActive'] = !(student['isActive'] as bool);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          student['isActive']
              ? '✅ ${student['name']} hesabı aktif edildi.'
              : '⏸️ ${student['name']} hesabı pasife alındı.',
        ),
      ),
    );
  }

  void _deleteStudent(Map<String, dynamic> student) {
    HapticFeedback.heavyImpact();
    setState(() {
      _students.remove(student);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🗑️ ${student['name']} öğrenci listesinden çıkarıldı.'),
      ),
    );
  }

  void _showAddStudentModal() {
    final nameCtrl = TextEditingController();
    final goalCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.lightSurface,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('YENİ ÖĞRENCİ EKLE',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.obsidianBlack)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Öğrenci Adı Soyadı',
                    filled: true,
                    fillColor: AppColors.lightBackground,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: goalCtrl,
                  decoration: InputDecoration(
                    labelText: 'Hedef (Örn: Yağ Yak & Kas Kazan)',
                    filled: true,
                    fillColor: AppColors.lightBackground,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                PremiumButton(
                  onPressed: () {
                    if (nameCtrl.text.isNotEmpty) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _students.insert(0, {
                          'id': 's_${DateTime.now().millisecondsSinceEpoch}',
                          'name': nameCtrl.text,
                          'goal': goalCtrl.text.isEmpty
                              ? 'Genel Fitness'
                              : goalCtrl.text,
                          'compliance': 100,
                          'remainingDays': 30,
                          'isActive': true,
                          'avatar':
                              'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80',
                          'lastCheckIn': 'Şimdi',
                          'weightHistory': [75.0, 75.0],
                          'beforePhoto':
                              'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=400&q=80',
                          'afterPhoto':
                              'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=400&q=80',
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  label: 'SİSTEME KAYDET & DAVET GÖNDER',
                  icon: Icons.person_add_alt_1_rounded,
                  isPrimary: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStudentAnalysisModal(Map<String, dynamic> student) {
    HapticFeedback.lightImpact();
    final List<double> weights =
        (student['weightHistory'] as List<dynamic>).cast<double>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
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
              const SizedBox(height: 18),
              Row(
                children: [
                  CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(student['avatar'])),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student['name'],
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.obsidianBlack)),
                        Text(
                            'Hedef: ${student['goal']} • Uyum: %${student['compliance']}',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 14),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kilo Gelişim Grafiği
                      const Text('KİLO GELİŞİM GRAFİĞİ (KG)',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.obsidianBlack)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 160,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                                show: true,
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false))),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                    weights.length,
                                    (i) =>
                                        FlSpot(i.toDouble(), weights[i])),
                                isCurved: true,
                                color: AppColors.emeraldGreen,
                                barWidth: 4,
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(
                                    show: true,
                                    color: AppColors.emeraldGreen
                                        .withValues(alpha: 0.15)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Gelişim Fotoğrafları (BEFORE / AFTER)
                      const Text('GELİŞİM FOTOĞRAFLARI (BEFORE / AFTER)',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.obsidianBlack)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                      student['beforePhoto'],
                                      height: 160,
                                      fit: BoxFit.cover),
                                ),
                                const SizedBox(height: 6),
                                const Text('BEFORE (1. Ay)',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.warning)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                      student['afterPhoto'],
                                      height: 160,
                                      fit: BoxFit.cover),
                                ),
                                const SizedBox(height: 6),
                                const Text('AFTER (Güncel)',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.emeraldGreen)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Aktiflik ve Silme Kontrolleri
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _toggleStudentStatus(student);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: student['isActive']
                                    ? AppColors.warning
                                    : AppColors.emeraldGreen,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16)),
                              ),
                              icon: Icon(
                                  student['isActive']
                                      ? Icons.pause_circle_filled_rounded
                                      : Icons.play_circle_fill_rounded,
                                  size: 18),
                              label: Text(
                                  student['isActive']
                                      ? 'ÜYELİĞİ PASİFE AL'
                                      : 'AKTİF HALE GETİR',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _deleteStudent(student);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red.shade700,
                                side: BorderSide(color: Colors.red.shade300),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16)),
                              ),
                              icon: const Icon(Icons.delete_rounded,
                                  size: 18),
                              label: const Text('ÖĞRENCİYİ SİL',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'KOÇ ÖĞRENCİ YÖNETİMİ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.obsidianBlack,
              ),
            ),
            Text(
              'Atlas Demir • ${_students.length} Kayıtlı Öğrenci',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Danışanlara Bildirim Gönder',
            icon: const Icon(Icons.campaign_rounded, color: AppColors.emeraldGreen),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TrainerNotificationBroadcastScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Gelen Bildirimler',
            icon: const Icon(Icons.notifications_active_rounded, color: AppColors.emeraldGreen),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.warning),
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
            // Üst Özet Kartları
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Ort. Uyum',
                    value: '%89',
                    icon: Icons.trending_up_rounded,
                    color: AppColors.emeraldGreen,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatCard(
                    title: 'Aktif Üyelikler',
                    value:
                        '${_students.where((s) => s['isActive'] == true).length} Öğrenci',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.limeGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ÖĞRENCİLERİM & ANALİZLERİ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: AppColors.textMuted,
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddStudentModal,
                  icon: const Icon(Icons.person_add_rounded,
                      size: 18, color: AppColors.emeraldGreen),
                  label: const Text(
                    'Öğrenci Ekle',
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

            ..._students.map((student) => _buildStudentCard(student)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.obsidianBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final bool isActive = student['isActive'] == true;

    return GestureDetector(
      onTap: () => _showStudentAnalysisModal(student),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200, width: 1.2),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(student['avatar']),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            student['name'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.obsidianBlack,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.emeraldGreen
                                      .withValues(alpha: 0.12)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isActive ? 'AKTİF' : 'PASİF',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: isActive
                                    ? AppColors.emeraldGreen
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hedef: ${student['goal']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Uyum %${student['compliance']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.emeraldGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Üyelik Kalan Süre: ${student['remainingDays']} Gün',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: student['remainingDays'] < 7
                        ? AppColors.warning
                        : AppColors.obsidianBlack,
                  ),
                ),
                Row(
                  children: [
                    const Text('Analizi İncele',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.emeraldGreen)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_rounded,
                        color: AppColors.emeraldGreen, size: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
