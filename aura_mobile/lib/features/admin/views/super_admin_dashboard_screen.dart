import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';
import '../../auth/views/auth_screen.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  State<SuperAdminDashboardScreen> createState() =>
      _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 1. Sisteme Kayıtlı Koçlar Listesi
  final List<Map<String, dynamic>> _coaches = [
    {
      'id': 'c_101',
      'name': 'Atlas Demir',
      'email': 'atlas@aura.com',
      'package': 'PREMIUM',
      'studentsCount': 42,
      'commissionRate': 15.0,
      'fixedMonthlyFee': 2500,
      'revenueShare': 18400,
      'isActive': true,
      'avatar':
          'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80',
      'customAppName': 'ATLAS FIT PRO',
      'primaryColor': '#65A30D',
    },
    {
      'id': 'c_102',
      'name': 'Selin Yener',
      'email': 'selin@aura.com',
      'package': 'PRO',
      'studentsCount': 24,
      'commissionRate': 18.0,
      'fixedMonthlyFee': 1200,
      'revenueShare': 9600,
      'isActive': true,
      'avatar':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      'customAppName': null,
      'primaryColor': null,
    },
    {
      'id': 'c_103',
      'name': 'Kaan Öztürk',
      'email': 'kaan@aura.com',
      'package': 'BASIC',
      'studentsCount': 11,
      'commissionRate': 20.0,
      'fixedMonthlyFee': 500,
      'revenueShare': 3200,
      'isActive': false,
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      'customAppName': null,
      'primaryColor': null,
    },
  ];

  // 2. Finans & Komisyon İşlemleri
  final List<Map<String, dynamic>> _financialTransactions = [
    {
      'id': 'pay_1',
      'coachName': 'Atlas Demir',
      'amount': 18400,
      'type': 'COMMISSION',
      'status': 'PAID',
      'date': '11 Tem 2026 • 14:30',
    },
    {
      'id': 'pay_2',
      'coachName': 'Selin Yener',
      'amount': 9600,
      'type': 'COMMISSION',
      'status': 'PENDING',
      'date': '10 Tem 2026 • 11:15',
    },
    {
      'id': 'pay_3',
      'coachName': 'Atlas Demir',
      'amount': 2500,
      'type': 'SUBSCRIPTION (PREMIUM)',
      'status': 'PAID',
      'date': '01 Tem 2026 • 09:00',
    },
  ];

  // 3. Denetim & Sözleşme Logları
  final List<Map<String, dynamic>> _auditLogs = [
    {
      'user': 'Atlas Demir (Koç)',
      'documentType': 'B2B_SaaS_HIZMET_SOZLESMESI',
      'ipAddress': '195.175.24.88',
      'date': '11 Tem 2026 • 08:12',
    },
    {
      'user': 'Selin Yener (Koç)',
      'documentType': 'KVKK & BİYOMETRİK VERİ İZİN METNİ',
      'ipAddress': '88.241.112.44',
      'date': '09 Tem 2026 • 16:45',
    },
    {
      'user': 'Kaan Öztürk (Koç)',
      'documentType': 'WHITE_LABEL_LISANS_SOZLESMESI',
      'ipAddress': '78.188.19.105',
      'date': '05 Tem 2026 • 12:00',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleCoachActiveStatus(Map<String, dynamic> coach) {
    HapticFeedback.mediumImpact();
    setState(() {
      coach['isActive'] = !(coach['isActive'] as bool);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          coach['isActive']
              ? '✅ ${coach['name']} hesabı AKTİF duruma getirildi.'
              : '⏸️ ${coach['name']} hesabı PASİFE alındı.',
        ),
      ),
    );
  }

  void _deleteCoach(Map<String, dynamic> coach) {
    HapticFeedback.heavyImpact();
    setState(() {
      _coaches.remove(coach);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🗑️ ${coach['name']} koç profili sistemden silindi.'),
      ),
    );
  }

  void _showCoachDetailModal(Map<String, dynamic> coach) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
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
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(coach['avatar']),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coach['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.obsidianBlack,
                            ),
                          ),
                          Text(
                            coach['email'],
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'PAKET: ${coach['package']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.emeraldGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailCard(
                        'Öğrenci Sayısı',
                        '${coach['studentsCount']} Danışan',
                        Icons.people_alt_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailCard(
                        'Komisyon Oranı',
                        '%${coach['commissionRate']}',
                        Icons.percent_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailCard(
                        'Aylık Sabit Ücret',
                        '₺${coach['fixedMonthlyFee']}',
                        Icons.monetization_on_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailCard(
                        'Şirket Gelir Payı',
                        '₺${coach['revenueShare']}',
                        Icons.trending_up_rounded,
                      ),
                    ),
                  ],
                ),
                if (coach['package'] == 'PREMIUM') ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WHITE-LABEL ÖZELLEŞTİRME DETAYLARI',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Özel Uygulama Adı: ${coach['customAppName']}\nAna Renk Kodu: ${coach['primaryColor']}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.obsidianBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _toggleCoachActiveStatus(coach);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: coach['isActive']
                              ? AppColors.warning
                              : AppColors.emeraldGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: Icon(
                          coach['isActive']
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          size: 20,
                        ),
                        label: Text(
                          coach['isActive'] ? 'PASİFE AL' : 'AKTİF YAP',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteCoach(coach);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade300),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.delete_rounded, size: 20),
                        label: const Text(
                          'KOÇU SİL',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
        elevation: 0.8,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AURA SÜPER ADMİN PANELİ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.obsidianBlack,
              ),
            ),
            Text(
              'B2B2C SaaS Yönetim & Finans Merkezi',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.warning),
            tooltip: 'Sistemden Çıkış',
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.emeraldGreen,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          indicatorColor: AppColors.emeraldGreen,
          indicatorWeight: 3,
          onTap: (_) => HapticFeedback.lightImpact(),
          tabs: const [
            Tab(icon: Icon(Icons.people_alt_rounded), text: 'Koçlar'),
            Tab(icon: Icon(Icons.account_balance_rounded), text: 'Finans'),
            Tab(icon: Icon(Icons.verified_user_rounded), text: 'Sözleşmeler'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildCoachesTab(),
          _buildFinanceTab(),
          _buildAuditLogsTab(),
        ],
      ),
    );
  }

  /// SEKME 1: KOÇLAR YÖNETİMİ
  Widget _buildCoachesTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SİSTEME KAYITLI TÜM KOÇLAR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: AppColors.textMuted,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_coaches.length} Koç Aktif',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.emeraldGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._coaches.map((coach) => _buildCoachCard(coach)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCoachCard(Map<String, dynamic> coach) {
    final bool isActive = coach['isActive'] == true;
    return GestureDetector(
      onTap: () => _showCoachDetailModal(coach),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200, width: 1.2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(coach['avatar']),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        coach['name'],
                        style: const TextStyle(
                          fontSize: 16,
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
                              ? AppColors.emeraldGreen.withValues(alpha: 0.12)
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
                    'Paket: ${coach['package']} • ${coach['studentsCount']} Danışan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 24),
          ],
        ),
      ),
    );
  }

  /// SEKME 2: FİNANS VE GELİR-GİDER
  Widget _buildFinanceTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFinanceCard(
                  'Sistem Toplam Gelir',
                  '₺312,200',
                  Icons.account_balance_wallet_rounded,
                  AppColors.emeraldGreen,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildFinanceCard(
                  'Ödenmiş Komisyon',
                  '₺204,900',
                  Icons.check_circle_rounded,
                  AppColors.limeGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'FİNANSAL KOMİSYON VE ABONELİK İŞLEMLERİ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          ..._financialTransactions.map((t) => _buildTxCard(t)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFinanceCard(
      String title, String val, IconData icon, Color color) {
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted),
          ),
          const SizedBox(height: 4),
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

  Widget _buildTxCard(Map<String, dynamic> tx) {
    final bool isPaid = tx['status'] == 'PAID';
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
              Text(
                tx['coachName'],
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.obsidianBlack),
              ),
              Text(
                '${tx['type']} • ${tx['date']}',
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₺${tx['amount']}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.obsidianBlack),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isPaid
                      ? AppColors.emeraldGreen.withValues(alpha: 0.12)
                      : AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isPaid ? 'ÖDENDİ (PAID)' : 'BEKLİYOR (PENDING)',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: isPaid ? AppColors.emeraldGreen : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// SEKME 3: SÖZLEŞME DENETİM İZİ & LOGLAR
  Widget _buildAuditLogsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ONAYLANAN SÖZLEŞMELER VE AUDIT TRAIL LOGLARI',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          ..._auditLogs.map((log) => _buildLogItem(log)),
        ],
      ),
    );
  }

  Widget _buildLogItem(Map<String, dynamic> log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.emeraldGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_rounded,
                color: AppColors.emeraldGreen, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log['user'],
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.obsidianBlack),
                ),
                Text(
                  '${log['documentType']} • IP: ${log['ipAddress']}',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Text(
            log['date'],
            style: TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.emeraldGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted),
                ),
                Text(
                  val,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.obsidianBlack),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
