import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/haptic_button.dart';
import 'features/auth/views/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: AuraMobileApp(),
    ),
  );
}

class AuraMobileApp extends StatelessWidget {
  const AuraMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AURA • Premium Fitness & Coaching',
      debugShowCheckedModeBanner: false,

      // Clean Studio Light ve Obsidian Dark Tema Konfigürasyonu
      theme: AppTheme.cleanStudioLight,
      darkTheme: AppTheme.obsidianDark,
      themeMode: ThemeMode.system, // Cihazın temasını dinler (Light veya Dark)

      // Sayfa geçişlerinde global Haptic Feedback tetikleyicisi
      navigatorObservers: [HapticNavigatorObserver()],

      // Uygulama Giriş Ekranı (Login / Kayıt Ol & Rol Seçimi) ile Başlar
      home: const AuthScreen(),
    );
  }
}
