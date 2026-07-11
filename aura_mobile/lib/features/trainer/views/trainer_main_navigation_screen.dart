import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import 'trainer_dashboard_screen.dart';
import 'trainer_programs_screen.dart';
import 'trainer_finance_referral_screen.dart';
import 'trainer_inbox_screen.dart';

class TrainerMainNavigationScreen extends StatefulWidget {
  const TrainerMainNavigationScreen({super.key});

  @override
  State<TrainerMainNavigationScreen> createState() =>
      _TrainerMainNavigationScreenState();
}

class _TrainerMainNavigationScreenState
    extends State<TrainerMainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TrainerDashboardScreen(),
    TrainerProgramsScreen(),
    TrainerFinanceReferralScreen(),
    TrainerInboxScreen(),
  ];

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      HapticFeedback.lightImpact();
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.people_alt_rounded, 'Danışanlar'),
                _buildNavItem(1, Icons.assignment_rounded, 'Programlar'),
                _buildNavItem(2, Icons.account_balance_wallet_rounded, 'Finans'),
                _buildNavItem(3, Icons.chat_bubble_rounded, 'Mesajlar'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.emeraldGreen.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isSelected ? AppColors.emeraldGreen : AppColors.textMuted,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.emeraldGreen,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
