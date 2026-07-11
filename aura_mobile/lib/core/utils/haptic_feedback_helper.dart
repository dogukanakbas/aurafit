import 'package:flutter/services.dart';

class HapticHelper {
  /// Hafif dokunma hissi (Buton tıklamaları ve sayfa geçişleri için)
  static Future<void> triggerLightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Orta şiddette titreşim (Önemli aksiyonlar)
  static Future<void> triggerMediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Başarı bildirim titreşimi (Antrenman bitişi vb.)
  static Future<void> triggerSuccessFeedback() async {
    await HapticFeedback.heavyImpact();
  }
}
