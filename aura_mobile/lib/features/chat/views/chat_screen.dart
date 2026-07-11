import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();

  // 1. KOÇTAN GELEN SİSTEM VE HATIRLATMA BİLDİRİMLERİ (NOTIFICATIONS)
  final List<Map<String, String>> _coachAlerts = [
    {
      'title': 'Hidrasyon Uyarı 💧',
      'body': 'Günün 2. litre suyunu içmeyi unutma, antrenman öncesi önemli!',
    },
    {
      'title': 'Haftalık Ölçü Hatırlatması 📏',
      'body': 'Profil sekmesinden bu haftaki bel, kol ve kilo ölçülerini gir.',
    },
  ];

  // 2. MESAJ GEÇMİŞİ
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'sender': 'COACH',
      'type': 'TEXT',
      'text': 'Günaydın Erlik! Bugünkü İtme (Push) günü programını yükledim.',
      'time': '09:14',
    },
    {
      'id': '2',
      'sender': 'ME',
      'type': 'TEXT',
      'text': 'Günaydın hocam, teşekkürler! Bench press setini birazdan giriyorum.',
      'time': '09:20',
    },
    {
      'id': '3',
      'sender': 'ME',
      'type': 'VIDEO',
      'text': '🎥 [Form Kontrol Videosu - 15 sn Barbell Bench Press]',
      'time': '10:05',
    },
    {
      'id': '4',
      'sender': 'COACH',
      'type': 'TEXT',
      'text':
          'Harika form! Dirsek açıları çok iyi, 4. sette 2.5 kg artırabilirsin.',
      'time': '10:12',
    },
  ];

  void _sendMessage(String type, String content) {
    if (content.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'sender': 'ME',
        'type': type,
        'text': content,
        'time': 'Şimdi',
      });
    });
    _msgController.clear();
  }

  void _showMediaPickerSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
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
              children: [
                const Text(
                  'MEDYA VE FORM KONTROL GÖNDER',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.obsidianBlack,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentAction(
                      icon: Icons.camera_alt_rounded,
                      label: 'Fotoğraf Çek',
                      color: AppColors.emeraldGreen,
                      onTap: () {
                        Navigator.pop(context);
                        _sendMessage('IMAGE', '📷 [Öğün / Gelişim Fotoğrafı Paylaşıldı]');
                      },
                    ),
                    _buildAttachmentAction(
                      icon: Icons.videocam_rounded,
                      label: 'Form Videosu',
                      color: AppColors.warning,
                      onTap: () {
                        Navigator.pop(context);
                        _sendMessage('VIDEO',
                            '🎥 [Form Kontrol Kısa Video Kaydı Gönderildi]');
                      },
                    ),
                    _buildAttachmentAction(
                      icon: Icons.mic_rounded,
                      label: 'Ses Kaydı',
                      color: Colors.blue.shade600,
                      onTap: () {
                        Navigator.pop(context);
                        _sendMessage('AUDIO', '🎙️ [0:42 Sesli Koç Notu Gönderildi]');
                      },
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

  Widget _buildAttachmentAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.obsidianBlack,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightSurface,
        elevation: 0.8,
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80',
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.emeraldGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ATLAS DEMİR',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.obsidianBlack,
                  ),
                ),
                Text(
                  'Çevrimiçi • Pro Antrenör',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.emeraldGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. KOÇTAN GELEN UYARI & BİLDİRİMLER KUTUSU
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.emeraldGreen.withValues(alpha: 0.08),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications_active_rounded,
                        size: 16, color: AppColors.emeraldGreen),
                    const SizedBox(width: 6),
                    Text(
                      'KOÇ BİLDİRİMLERİ & HATIRLATMALAR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.emeraldGreen,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ..._coachAlerts.map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '⚡ ${a['title']}: ${a['body']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.obsidianBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. MESAJ BALONLARI (RIGHT/LEFT BUBBLES)
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final bool isMe = msg['sender'] == 'ME';
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? AppColors.emeraldGreen
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isMe ? 20 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 20),
                      ),
                      border: isMe
                          ? null
                          : Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'],
                          style: TextStyle(
                            color:
                                isMe ? Colors.white : AppColors.obsidianBlack,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'],
                          style: TextStyle(
                            color: isMe
                                ? Colors.white.withValues(alpha: 0.7)
                                : AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. ÇOKLU MEDYA DESTEKLİ MESAJ GİRİŞ ALANI
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.lightSurface,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded,
                        color: AppColors.emeraldGreen, size: 26),
                    onPressed: _showMediaPickerSheet,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          hintText: 'Koçuna soru sor, form kontrolü gönder...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (val) => _sendMessage('TEXT', val),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage('TEXT', _msgController.text),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.emeraldGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
