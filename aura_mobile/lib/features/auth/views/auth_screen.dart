import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';
import '../../navigation/views/main_navigation_screen.dart';
import '../../trainer/views/trainer_main_navigation_screen.dart';
import '../../admin/views/super_admin_dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'superadmin@aura.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'AuraSuperSecret2026!');

  String _selectedDemoRole = 'ADMIN'; // ADMIN, COACH, STUDENT
  bool _isCoachPendingApproval = false;

  void _handleSmartLogin() {
    HapticFeedback.mediumImpact();

    if (_selectedDemoRole == 'ADMIN') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SuperAdminDashboardScreen()),
      );
    } else if (_selectedDemoRole == 'COACH') {
      if (_isCoachPendingApproval) {
        _showPendingApprovalAlert();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const TrainerMainNavigationScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }

  void _showPendingApprovalAlert() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.hourglass_top_rounded, color: AppColors.warning),
            SizedBox(width: 8),
            Text('Admin Onayı Bekleniyor'),
          ],
        ),
        content: const Text(
          'Koç başvurunuz sistem yöneticileri tarafından incelenmektedir. '
          'IBAN ve belgeleriniz doğrulandıktan sonra hesabınız aktif hale getirilecektir.',
          style: TextStyle(height: 1.4, color: AppColors.obsidianBlack),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANLADIM',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.emeraldGreen)),
          ),
        ],
      ),
    );
  }

  void _openCoachRegistrationSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CoachRegistrationModal(),
    );
  }

  void _openStudentRegistrationSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const StudentRegistrationStepperModal(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO HEADER
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.emeraldGreen,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'A U R A',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0,
                    color: AppColors.obsidianBlack,
                  ),
                ),
                const Text(
                  'B2B2C SAAS FITNESS PLATFORMU',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 24),

                // 1. ORTAK GİRİŞ YAP (LOGIN) KARTI
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.grey.shade200, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ORTAK GÜVENLİ GİRİŞ YAP (LOGIN)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.obsidianBlack,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // DEMO/TEST İÇİN ROL SEÇİCİ
                      Row(
                        children: [
                          Expanded(
                              child: _buildRoleChip('ADMIN', 'Süper Admin',
                                  Icons.admin_panel_settings_rounded)),
                          const SizedBox(width: 6),
                          Expanded(
                              child: _buildRoleChip('COACH', 'Spor Koçu',
                                  Icons.fitness_center_rounded)),
                          const SizedBox(width: 6),
                          Expanded(
                              child: _buildRoleChip(
                                  'STUDENT', 'Öğrenci', Icons.person_rounded)),
                        ],
                      ),
                      if (_selectedDemoRole == 'COACH') ...[
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Koç Onay Bekliyor Testi:',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textMuted)),
                            Switch(
                              value: _isCoachPendingApproval,
                              activeThumbColor: AppColors.warning,
                              onChanged: (val) {
                                setState(() => _isCoachPendingApproval = val);
                              },
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),

                      Text('E-POSTA ADRESİ',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textMuted)),
                      const SizedBox(height: 6),
                      _buildInput(_emailController, 'ornek@aura.com',
                          Icons.email_outlined),
                      const SizedBox(height: 14),

                      Text('ŞİFRE',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textMuted)),
                      const SizedBox(height: 6),
                      _buildInput(_passwordController, '••••••••',
                          Icons.lock_outline_rounded,
                          isPassword: true),
                      const SizedBox(height: 22),

                      // TAŞMA YAPMAYAN YÜKSEK KONTRASTLI GİRİŞ BUTONU
                      SizedBox(
                        width: double.infinity,
                        child: PremiumButton(
                          onPressed: _handleSmartLogin,
                          label: 'GİRİŞ YAP & YÖNLENDİR',
                          icon: Icons.login_rounded,
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // 2. KAYIT OL & BAŞVURU SEÇENEKLERİ
                const Text(
                  'YENİ HESAP OLUŞTUR VEYA BAŞVUR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMuted,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildRegisterOptionCard(
                        title: 'Öğrenci Kaydı',
                        subtitle: 'Koç Seçimi ile Başla',
                        icon: Icons.person_add_alt_1_rounded,
                        color: AppColors.emeraldGreen,
                        onTap: _openStudentRegistrationSheet,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRegisterOptionCard(
                        title: 'Koç Başvurusu',
                        subtitle: 'Paket & IBAN Tanımı',
                        icon: Icons.workspace_premium_rounded,
                        color: AppColors.warning,
                        onTap: _openCoachRegistrationSheet,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleChip(String role, String label, IconData icon) {
    final bool isSel = _selectedDemoRole == role;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedDemoRole = role);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSel
              ? AppColors.emeraldGreen.withValues(alpha: 0.14)
              : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSel ? AppColors.emeraldGreen : Colors.grey.shade300,
            width: isSel ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 18,
                color: isSel ? AppColors.emeraldGreen : AppColors.textMuted),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSel ? FontWeight.w900 : FontWeight.w600,
                  color:
                      isSel ? AppColors.emeraldGreen : AppColors.obsidianBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
      TextEditingController ctrl, String hint, IconData icon,
      {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white, // Yüksek kontrastlı net beyaz arka plan
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isPassword,
        style: const TextStyle(
          color: Color(0xFF0F172A), // NET KOYU SİYAH YAZI RENGİ
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.emeraldGreen, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF64748B), // Okunaklı net hint rengi
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildRegisterOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade300, width: 1.2),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.obsidianBlack)),
            const SizedBox(height: 2),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// 2. SPOR KOÇU KAYIT PANELİ (Coach Registration UI - Net Yüksek Kontrast & Butonlar)
class CoachRegistrationModal extends StatefulWidget {
  const CoachRegistrationModal({super.key});

  @override
  State<CoachRegistrationModal> createState() => _CoachRegistrationModalState();
}

class _CoachRegistrationModalState extends State<CoachRegistrationModal> {
  String _selectedPackage = 'PRO';
  bool _kvkkConsent = false;
  bool _serviceConsent = false;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _ibanCtrl = TextEditingController();
  final TextEditingController _refCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SPOR KOÇU BAŞVURU & KAYIT',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.obsidianBlack)),
              IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.obsidianBlack),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildLabel('KOÇ PAKET SEÇİMİ'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildPkgCard('BASIC', 'Temel', '₺500/ay')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildPkgCard('PRO', 'Orta', '₺1200/ay')),
                      const SizedBox(width: 8),
                      Expanded(
                          child:
                              _buildPkgCard('PREMIUM', 'Premium', '₺2500/ay')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('AD SOYAD'),
                  _buildTextField(_nameCtrl, 'Atlas Demir'),
                  const SizedBox(height: 12),
                  _buildLabel('E-POSTA ADRESİ'),
                  _buildTextField(_emailCtrl, 'atlas@aura.com'),
                  const SizedBox(height: 12),
                  _buildLabel('TELEFON NUMARASI'),
                  _buildTextField(_phoneCtrl, '+90 532 000 00 00'),
                  const SizedBox(height: 12),
                  _buildLabel('IBAN (KOMİSYON VE GELİR ÖDEMELERİ İÇİN)'),
                  _buildTextField(
                      _ibanCtrl, 'TR00 0000 0000 0000 0000 0000 00'),
                  const SizedBox(height: 12),
                  _buildLabel('DAVET / REFERANS KODU (İSTEĞE BAĞLI)'),
                  _buildTextField(_refCtrl, 'AURA-REFERRAL-CODE'),
                  const SizedBox(height: 16),

                  CheckboxListTile(
                    title: const Text(
                        'KVKK & Biyometrik Veri Metnini okudum, onaylıyorum.',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.obsidianBlack)),
                    value: _kvkkConsent,
                    activeColor: AppColors.emeraldGreen,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) =>
                        setState(() => _kvkkConsent = val ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text(
                        'Koçluk Hizmet ve White-Label Sözleşmesini kabul ediyorum.',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.obsidianBlack)),
                    value: _serviceConsent,
                    activeColor: AppColors.emeraldGreen,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) =>
                        setState(() => _serviceConsent = val ?? false),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: PremiumButton(
                      onPressed: () {
                        if (_kvkkConsent && _serviceConsent) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  '⏳ Koç başvurunuz alındı! Durum: PENDING_APPROVAL. Admin onayından sonra giriş yapabileceksiniz.'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Lütfen KVKK ve Sözleşmeleri onaylayın.')),
                          );
                        }
                      },
                      label: 'BAŞVURUYU TAMAMLA & GÖNDER',
                      icon: Icons.check_circle_rounded,
                      isPrimary: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPkgCard(String pkg, String label, String price) {
    final bool isSel = _selectedPackage == pkg;
    return GestureDetector(
      onTap: () => setState(() => _selectedPackage = pkg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSel
              ? AppColors.emeraldGreen.withValues(alpha: 0.14)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSel ? AppColors.emeraldGreen : const Color(0xFFCBD5E1),
              width: isSel ? 1.8 : 1.0),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                    color: isSel
                        ? AppColors.emeraldGreen
                        : AppColors.obsidianBlack)),
            const SizedBox(height: 4),
            Text(price,
                style: TextStyle(
                    fontSize: 11,
                    color:
                        isSel ? AppColors.emeraldGreen : AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted)),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
      ),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
            fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF64748B)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

/// 3. ÖĞRENCİ KAYIT PANELİ (Yüksek Kontrastlı Özel İlerleme Butonlu Stepper UI)
class StudentRegistrationStepperModal extends StatefulWidget {
  const StudentRegistrationStepperModal({super.key});

  @override
  State<StudentRegistrationStepperModal> createState() =>
      _StudentRegistrationStepperModalState();
}

class _StudentRegistrationStepperModalState
    extends State<StudentRegistrationStepperModal> {
  int _currentStep = 0;
  bool _hasInviteCode = false;
  bool _membershipConsent = false;
  bool _healthDeclarationConsent = false;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _inviteCtrl = TextEditingController();
  final TextEditingController _ageCtrl = TextEditingController(text: '24');
  final TextEditingController _heightCtrl = TextEditingController(text: '178');
  final TextEditingController _weightCtrl = TextEditingController(text: '79.5');

  String _selectedGoal = 'Kas Kazan & Yağ Yak';
  String _selectedCoach = 'Atlas Demir (Pro Koç)';

  void _nextStep() {
    HapticFeedback.lightImpact();
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    } else {
      if (_membershipConsent && _healthDeclarationConsent) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Lütfen Üyelik Sözleşmesi ve Sağlık Beyanını onaylayın.')),
        );
      }
    }
  }

  void _prevStep() {
    HapticFeedback.lightImpact();
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ÖĞRENCİ KAYIT & SİHİRBAZ',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.obsidianBlack)),
              IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.obsidianBlack),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: _nextStep,
              onStepCancel: _prevStep,
              // ÖZEL KONTROL BUTONLARI (GÖRÜNÜR & ŞIK İLERLEME/GERİ BUTONLARI)
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: PremiumButton(
                          onPressed: _nextStep,
                          label: _currentStep == 2
                              ? 'KAYDI TAMAMLA & BAŞLA'
                              : 'SONRAKİ ADIM ➔',
                          icon: _currentStep == 2
                              ? Icons.check_circle_rounded
                              : Icons.arrow_forward_rounded,
                          isPrimary: true,
                        ),
                      ),
                      if (_currentStep > 0) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: _prevStep,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                  color: Colors.grey.shade400, width: 1.4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text(
                              'GERİ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.obsidianBlack,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
              steps: [
                Step(
                  title: const Text('Koç Seçimi',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                  content: _buildStep1CoachLink(),
                  isActive: _currentStep >= 0,
                ),
                Step(
                  title: const Text('Biyometri',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                  content: _buildStep2Biometrics(),
                  isActive: _currentStep >= 1,
                ),
                Step(
                  title: const Text('Sözleşme',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                  content: _buildStep3Consent(),
                  isActive: _currentStep >= 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1CoachLink() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('BİR KOÇUN DAVET KODUN VAR MI?',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.obsidianBlack)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _hasInviteCode = true),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: _hasInviteCode
                        ? AppColors.emeraldGreen
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: _hasInviteCode
                            ? AppColors.emeraldGreen
                            : const Color(0xFFCBD5E1)),
                  ),
                  child: Center(
                    child: Text(
                      'Davet Kodum Var',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _hasInviteCode
                            ? Colors.white
                            : AppColors.obsidianBlack,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _hasInviteCode = false),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: !_hasInviteCode
                        ? AppColors.emeraldGreen
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: !_hasInviteCode
                            ? AppColors.emeraldGreen
                            : const Color(0xFFCBD5E1)),
                  ),
                  child: Center(
                    child: Text(
                      'Koç Listesinden Seç',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: !_hasInviteCode
                            ? Colors.white
                            : AppColors.obsidianBlack,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (_hasInviteCode) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
            ),
            child: TextField(
              controller: _inviteCtrl,
              style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Koç Davet Kodu (Örn: AURA-ATLAS-2026)',
                labelStyle: TextStyle(color: Color(0xFF64748B)),
                border: InputBorder.none,
              ),
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedCoach,
              style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                  fontSize: 14),
              dropdownColor: Colors.white,
              decoration: const InputDecoration(
                labelText: 'Aktif Antrenör Seçin',
                labelStyle: TextStyle(color: Color(0xFF64748B)),
                border: InputBorder.none,
              ),
              items: [
                'Atlas Demir (Pro Koç)',
                'Selin Yener (Pro Koç)',
                'Mert Can Demir (Basic Koç)'
              ]
                  .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c,
                          style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontWeight: FontWeight.w700))))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCoach = val!),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStep2Biometrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCleanInput(_nameCtrl, 'Ad Soyad'),
        const SizedBox(height: 10),
        _buildCleanInput(_emailCtrl, 'E-Posta Adresi'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildCleanInput(_ageCtrl, 'Yaş')),
            const SizedBox(width: 8),
            Expanded(child: _buildCleanInput(_heightCtrl, 'Boy (CM)')),
            const SizedBox(width: 8),
            Expanded(child: _buildCleanInput(_weightCtrl, 'Kilo (KG)')),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedGoal,
            style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
                fontSize: 14),
            dropdownColor: Colors.white,
            decoration: const InputDecoration(
              labelText: 'Ana Hedef',
              labelStyle: TextStyle(color: Color(0xFF64748B)),
              border: InputBorder.none,
            ),
            items: [
              'Kas Kazan & Yağ Yak',
              'Definisyon & Kilo Ver',
              'Güç ve Kondisyon'
            ]
                .map((g) => DropdownMenuItem(
                    value: g,
                    child: Text(g,
                        style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.w700))))
                .toList(),
            onChanged: (val) => setState(() => _selectedGoal = val!),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3Consent() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Öğrenci Üyelik Sözleşmesini okudum, kabul ediyorum.',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.obsidianBlack)),
          value: _membershipConsent,
          activeColor: AppColors.emeraldGreen,
          onChanged: (val) => setState(() => _membershipConsent = val ?? false),
        ),
        CheckboxListTile(
          title: const Text(
              'Sağlık Beyanını (egzersiz yapmama engel bir sağlık durumum olmadığını) kabul ediyorum.',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.obsidianBlack)),
          value: _healthDeclarationConsent,
          activeColor: AppColors.emeraldGreen,
          onChanged: (val) =>
              setState(() => _healthDeclarationConsent = val ?? false),
        ),
      ],
    );
  }

  Widget _buildCleanInput(TextEditingController ctrl, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
      ),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
            fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF64748B)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
