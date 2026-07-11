import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _cachedWorkoutKey = 'aura_cached_workout_today';
  static const String _chatMessagesKey = 'aura_real_chat_messages_v1';
  static const String _currentUserKey = 'aura_current_logged_user_v1';
  static const String _currentCoachKey = 'aura_current_assigned_coach_v1';

  static Future<void> cacheWorkout(Map<String, dynamic> workoutData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedWorkoutKey, json.encode(workoutData));
  }

  static Future<Map<String, dynamic>?> getCachedWorkout() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cachedWorkoutKey);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  // Gerçek Sohbet Mesajlarını Veritabanı (SharedPreferences JSON) üzerinde saklama
  static Future<List<Map<String, dynamic>>> getChatMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_chatMessagesKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    // Varsayılan gerçek koç ilk mesajı
    return [
      {
        'id': 'msg_init_1',
        'senderId': 'trainer_atlas',
        'senderName': 'Atlas Demir',
        'isMe': false,
        'messageType': 'TEXT',
        'content': 'Merhaba Erlik Han! Ben koçun Atlas Demir. Antrenman programını, beslenmeni veya sormak istediğin her şeyi buradan bana gerçek zamanlı yazabilir veya ses kaydı atabilirsin.',
        'time': '09:00',
      }
    ];
  }

  static Future<void> saveChatMessages(List<Map<String, dynamic>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chatMessagesKey, json.encode(messages));
  }

  static Future<void> addChatMessage(Map<String, dynamic> message) async {
    final list = await getChatMessages();
    list.add(message);
    await saveChatMessages(list);
  }

  // Aktif Koç Bilgisi
  static Future<Map<String, dynamic>> getAssignedCoach() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_currentCoachKey);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return {
      'id': 'coach_atlas',
      'name': 'Atlas Demir',
      'title': 'Hipertrofi & Biyomekanik Koçu',
      'avatarUrl': 'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80',
      'isOnline': true,
    };
  }

  static Future<void> saveAssignedCoach(Map<String, dynamic> coach) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentCoachKey, json.encode(coach));
  }

  static const String _notificationsKey = 'aura_persistent_notifications_v1';

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_notificationsKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      final List<dynamic> decoded = json.decode(jsonStr);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [
      {
        'id': 'notif_1',
        'title': 'Su Hatırlatması 💧',
        'body': 'Koçunuz Atlas Demir günlük 3.0 litre su hedefinizi hatırlatıyor.',
        'time': '14:30',
        'type': 'SU',
        'targetStudent': 'ALL',
      },
      {
        'id': 'notif_2',
        'title': 'Yeni Antrenman Programı 💪',
        'body': '3. Hafta Hipertrofi ve Güç programınız sisteme tanımlandı.',
        'time': 'Dün',
        'type': 'PROGRAM',
        'targetStudent': 'ALL',
      },
      {
        'id': 'notif_3',
        'title': 'Haftalık Check-In Ölçüleri 📏',
        'body': 'Pazar günü kilo ve gelişim fotoğraflarınızı sisteme girmeyi unutmayın.',
        'time': '2 gün önce',
        'type': 'UYARI',
        'targetStudent': 'ALL',
      },
    ];
  }

  static Future<void> addNotification(Map<String, dynamic> notif) async {
    final list = await getNotifications();
    list.insert(0, notif);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notificationsKey, json.encode(list));
  }
}
