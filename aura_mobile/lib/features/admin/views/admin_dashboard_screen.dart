import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/views/auth_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Yeni Kayıt Olan ve Onay Bekleyen Antrenörler
  final List<Map<String, dynamic>> _pendingTrainers = [
    {
      'id': 't_101',
      'name': 'Kaan Öztürk',
      'specialty': 'Hipertrofi & Vücut Geliştirme',
      'experience': '6 Yıl',
      'email': 'kaan@aura.com',
      'status': 'PENDING',
    },
    {
      'id': 't_102',
      'name': 'Selin Yener',
      'specialty': 'Fonksiyonel Antrenman & Pilates',
      'experience': '4 Yıl',
      'email': 'selin@aura.com',
      'status': 'PENDING',
    },
  ];

  final List<Map<String, dynamic>> _allUsers = [
    {'name': 'Atlas Demir', 'role': 'TRAINER', 'status': 'ONAYLI', 'email': 'atlas@aura.com'},
    {'name': 'Erlik Han', 'role': 'CLIENT', 'status': 'AKTİF', 'email': 'erlikhan@aura.com'},
    {'name': 'Zeynep Kaya', 'role': 'CLIENT', 'status': 'AKTİF', 'email': 'zeynep@aura.com'},
    {'name': 'Mert Yılmaz', 'role': 'CLIENT', 'status': 'AKTİF', 'email': 'mert@aura.com'},
  ];

  void _handleTrainerAction(Map<String, dynamic> trainer, bool approve) {
    HapticFeedback.heavyImpact();
    setState(() {
      _pendingTrainers.remove(trainer);
      if (approve) {
        _allUsers.insert(0, {
          'name': trainer['name'],
          'role': 'TRAINER',
          'status': 'ONAYLI',
          'email': trainer['email'],
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          approve
              ? '✅ ${trainer['name']} koç olarak onaylandı ve sisteme eklendi!'
              : '❌ ${trainer['name']} başvurusu reddedildi.',
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _marketProducts = [
    {
      'id': 'p1',
      'name': 'Aura İzole Whey Protein (2.3kg)',
      'category': 'Takviye',
      'price': '₺1,450',
      'stock': '42 Adet',
      'badge': '%18 İNDİRİM',
    },
    {
      'id': 'p2',
      'name': 'Mikronize Kreatin Monohidrat',
      'category': 'Takviye',
      'price': '₺680',
      'stock': '85 Adet',
      'badge': 'ÇOK SATAN',
    },
    {
      'id': 'p3',
      'name': 'Aura Pro Lifting Straps',
      'category': 'Ekipman',
      'price': '₺320',
      'stock': '19 Adet',
      'badge': 'KOÇ ÖNERİSİ',
    },
  ];

  void _openProductModal({Map<String, dynamic>? editItem}) {
    HapticFeedback.mediumImpact();
    final nameCtrl = TextEditingController(text: editItem?['name'] ?? '');
    final priceCtrl = TextEditingController(text: editItem?['price'] ?? '₺');
    final stockCtrl = TextEditingController(text: editItem?['stock'] ?? '50 Adet');
    final badgeCtrl = TextEditingController(text: editItem?['badge'] ?? 'YENİ ÜRÜN');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                editItem == null ? '🛒 YENİ MARKET ÜRÜNÜ EKLE' : '✏️ ÜRÜNÜ DÜZENLE',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.obsidianBlack,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ürün Adı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Fiyat (örn: ₺850)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: stockCtrl,
                decoration: const InputDecoration(
                  labelText: 'Stok Miktarı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: badgeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Rozet (örn: KAMPANYA)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('İptal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emeraldGreen,
                    ),
                    onPressed: () {
                      if (nameCtrl.text.isNotEmpty) {
                        setState(() {
                          if (editItem != null) {
                            editItem['name'] = nameCtrl.text;
                            editItem['price'] = priceCtrl.text;
                            editItem['stock'] = stockCtrl.text;
                            editItem['badge'] = badgeCtrl.text;
                          } else {
                            _marketProducts.insert(0, {
                              'id': 'p_${DateTime.now().millisecondsSinceEpoch}',
                              'name': nameCtrl.text,
                              'category': 'Takviye',
                              'price': priceCtrl.text,
                              'stock': stockCtrl.text,
                              'badge': badgeCtrl.text,
                            });
                          }
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(editItem == null
                                ? '🎉 Ürün markete başarıyla eklendi!'
                                : '✅ Ürün güncellendi.'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      editItem == null ? 'ÜRÜNÜ EKLE' : 'GÜNCELLE',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteProduct(Map<String, dynamic> item) {
    HapticFeedback.heavyImpact();
    setState(() => _marketProducts.remove(item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🗑️ ${item['name']} marketten silindi.')),
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
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        title: const Text(
          'AURA YÖNETİCİ KONTROL PANELİ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.obsidianBlack,
          ),
        ),
        actions: [
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
            // 1. İstatistik Kartları
            Row(
              children: [
                Expanded(
                  child: _buildAdminStat(
                    'Aktif Danışanlar',
                    '1,248',
                    Icons.people_rounded,
                    AppColors.emeraldGreen,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildAdminStat(
                    'Onaylı Antrenörler',
                    '34 Koç',
                    Icons.fitness_center_rounded,
                    AppColors.limeGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. fl_chart Kullanıcı Dağılım Grafiği
            _buildChartSection(),
            const SizedBox(height: 24),

            // 3. ONAY BEKLEYEN ANTRENÖRLER LİSTESİ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ONAY BEKLEYEN YENİ ANTRENÖRLER',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: AppColors.obsidianBlack,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_pendingTrainers.length} Başvuru',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_pendingTrainers.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Center(
                  child: Text(
                    'Onay bekleyen antrenör başvurusu bulunmuyor ✅',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              )
            else
              ..._pendingTrainers.map((t) => _buildTrainerApprovalCard(t)),

            const SizedBox(height: 28),

            const Text(
              'SİSTEMDEKİ KULLANICILAR & ROLLER',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),

            ..._allUsers.map((u) => _buildUserRow(u)),
            const SizedBox(height: 32),

            // 4. MAĞAZA / MARKET ÜRÜN YÖNETİMİ (EKLE / DÜZENLE / ÇIKAR)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'MARKET & ÜRÜN KATALOG YÖNETİMİ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: AppColors.obsidianBlack,
                  ),
                ),
                GestureDetector(
                  onTap: () => _openProductModal(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldGreen,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'YENİ ÜRÜN EKLE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            ..._marketProducts.map((p) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.emeraldGreen
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    p['badge'],
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.emeraldGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  p['price'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.obsidianBlack,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              p['name'],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.obsidianBlack,
                              ),
                            ),
                            Text(
                              'Stok Durumu: ${p['stock']}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded,
                                color: Colors.blueAccent, size: 20),
                            onPressed: () => _openProductModal(editItem: p),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: Colors.redAccent, size: 20),
                            onPressed: () => _deleteProduct(p),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminStat(String label, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            val,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.obsidianBlack),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SİSTEM KULLANICI DAĞILIMI (fl_chart)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.obsidianBlack,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        final titles = [
                          'Danışan\n(CLIENT)',
                          'Antrenör\n(TRAINER)',
                          'Yönetici\n(ADMIN)'
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            titles[val.toInt()],
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(
                        toY: 1248,
                        color: AppColors.emeraldGreen,
                        width: 32,
                        borderRadius: BorderRadius.circular(8))
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(
                        toY: 34,
                        color: AppColors.limeGreen,
                        width: 32,
                        borderRadius: BorderRadius.circular(8))
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(
                        toY: 3,
                        color: const Color(0xFF10B981),
                        width: 32,
                        borderRadius: BorderRadius.circular(8))
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerApprovalCard(Map<String, dynamic> trainer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.warning, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainer['name'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.obsidianBlack,
                    ),
                  ),
                  Text(
                    '${trainer['specialty']} • Deneyim: ${trainer['experience']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'ONAY BEKLİYOR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleTrainerAction(trainer, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emeraldGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('ONAYLA',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handleTrainerAction(trainer, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: const BorderSide(color: AppColors.warning),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: const Text('REDDET',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(Map<String, dynamic> u) {
    final bool isTrainer = u['role'] == 'TRAINER';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(u['name'],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.obsidianBlack)),
              Text(u['email'],
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isTrainer
                  ? AppColors.emeraldGreen.withValues(alpha: 0.12)
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              u['role'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isTrainer
                    ? AppColors.emeraldGreen
                    : AppColors.obsidianBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
