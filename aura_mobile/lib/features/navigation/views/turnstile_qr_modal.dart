import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';

class TurnstileQrModal extends StatefulWidget {
  const TurnstileQrModal({super.key});

  @override
  State<TurnstileQrModal> createState() => _TurnstileQrModalState();
}

class _TurnstileQrModalState extends State<TurnstileQrModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _scannerAnimController;
  late Animation<double> _scannerAnimation;

  @override
  void initState() {
    super.initState();
    _scannerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scannerAnimation =
        Tween<double>(begin: 0.0, end: 180.0).animate(_scannerAnimController);
  }

  @override
  void dispose() {
    _scannerAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AURA PRO TURNİKE KARTI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.obsidianBlack,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'QR Kodu veya Barcode ile Hızlı Geçiş',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // QR Kodu Kutu & Tarayıcı Lazer Çizgisi
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 230,
                  height: 230,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.emeraldGreen, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emeraldGreen.withValues(alpha: 0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // QR kod sembolü
                      const Icon(
                        Icons.qr_code_2_rounded,
                        size: 170,
                        color: AppColors.obsidianBlack,
                      ),
                      // Merkez kulüp logosu pırıltısı
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.emeraldGreen
                                  .withValues(alpha: 0.4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fitness_center_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                // Lazer tarayıcı çizgisi
                AnimatedBuilder(
                  animation: _scannerAnimation,
                  builder: (context, child) {
                    return Positioned(
                      top: 25 + _scannerAnimation.value,
                      child: Container(
                        width: 200,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.emeraldGreen,
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.emeraldGreen
                                  .withValues(alpha: 0.8),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
            // Barkod Numarası
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.qr_code_scanner_rounded,
                      color: AppColors.emeraldGreen, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'AURA-ID: 88942-019',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.obsidianBlack,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Turnike veya kapı sensörüne bu QR kodu yaklaştırın. Kod her 60 saniyede bir otomatik yenilenir.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PremiumButton(
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Turnike geçiş onayı alındı! İyi antrenmanlar Şampiyon!'),
                    backgroundColor: AppColors.emeraldGreen,
                  ),
                );
              },
              label: 'GEÇİŞİ ONAYLA & KAPAT',
              icon: Icons.check_circle_rounded,
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }
}
