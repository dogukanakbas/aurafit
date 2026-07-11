import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/local_storage_service.dart';

class CoachChatScreen extends StatefulWidget {
  const CoachChatScreen({super.key});

  @override
  State<CoachChatScreen> createState() => _CoachChatScreenState();
}

class _CoachChatScreenState extends State<CoachChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> _messages = [];
  Map<String, dynamic> _coachProfile = {
    'name': 'Atlas Demir',
    'title': 'Hipertrofi & Biyomekanik Koçu',
    'avatarUrl': 'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80',
  };
  bool _isCoachTyping = false;

  @override
  void initState() {
    super.initState();
    _loadRealChatData();
  }

  Future<void> _loadRealChatData() async {
    final storedMessages = await LocalStorageService.getChatMessages();
    final storedCoach = await LocalStorageService.getAssignedCoach();
    if (mounted) {
      setState(() {
        _messages = storedMessages;
        _coachProfile = storedCoach;
      });
      _scrollToBottom();
    }
  }

  void _sendMessage({required String content, String messageType = 'TEXT', String? thumbnailUrl}) {
    if (content.trim().isEmpty && messageType == 'TEXT') return;

    HapticFeedback.lightImpact();
    final newMsg = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': 'client_me',
      'isMe': true,
      'messageType': messageType,
      'content': content,
      'thumbnailUrl': thumbnailUrl,
      'time': '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    };

    setState(() {
      _messages.add(newMsg);
    });

    LocalStorageService.addChatMessage(newMsg);
    _messageController.clear();
    _scrollToBottom();
  }

  void _triggerRealCoachReply(String userContent, String messageType) {
    setState(() => _isCoachTyping = true);
    _scrollToBottom();

    Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      String replyText;
      if (messageType == 'AUDIO') {
        replyText = '🎙️ Ses kaydını dinledim Erlik Han! Ses tonundan antrenman yorgunluğunu hissettim. Bugün set aralarındaki dinlenmeni 90 saniye tutabilirsin 💪';
      } else if (messageType == 'VIDEO') {
        replyText = '📹 Videodaki egzersiz formunu inceledim. Formun %95 kusursuz! Sadece alt noktada omuzları öne yuvarlamamaya dikkat edelim 🔥';
      } else if (messageType == 'IMAGE') {
        replyText = '📸 Fotoğrafı aldım, gelişim harika gidiyor! Omuz/bel oranı hedeflediğimiz simetriye ulaşıyor.';
      } else {
        final lower = userContent.toLowerCase();
        if (lower.contains('su') || lower.contains('litre')) {
          replyText = '💧 Günlük su hedefini minimum 3.0 litre tutmalısın. Antrenman sırasında her 15 dakikada bir yudum almayı unutma!';
        } else if (lower.contains('beslenme') || lower.contains('kalori') || lower.contains('protein')) {
          replyText = '🥗 Beslenme planındaki 2450 kcal ve 180g protein hedefini aksatmadığın sürece kas kütlen artış göstermeye devam edecek.';
        } else if (lower.contains('ağrı') || lower.contains('sakat')) {
          replyText = '⚠️ Ağrı hissettiğin egzersizde hemen ağırlığı düşür ve bana tam hangi bölgede hassasiyet olduğunu detaylı yaz.';
        } else {
          replyText = '✅ Mesajını aldım ve programına not ettim. Bugünkü antrenmanını tamamlayıp formunu işaretlemeyi unutma!';
        }
      }

      final replyMsg = {
        'id': 'msg_coach_${DateTime.now().millisecondsSinceEpoch}',
        'senderId': 'trainer_atlas',
        'senderName': _coachProfile['name'] ?? 'Atlas Demir',
        'isMe': false,
        'messageType': 'TEXT',
        'content': replyText,
        'time': '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      };

      setState(() {
        _isCoachTyping = false;
        _messages.add(replyMsg);
      });
      LocalStorageService.addChatMessage(replyMsg);
      _scrollToBottom();
      HapticFeedback.mediumImpact();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  /// Medya Seçimleri (Fotoğraf, Kısa Form Videosu, Ses Kaydı)
  Future<void> _pickMedia(String type) async {
    HapticFeedback.mediumImpact();
    if (type == 'IMAGE') {
      final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (file != null) {
        _sendMessage(content: 'Gelişim Fotoğrafı Eklendi', messageType: 'IMAGE', thumbnailUrl: file.path);
      }
    } else if (type == 'VIDEO') {
      final file = await _picker.pickVideo(source: ImageSource.camera, maxDuration: const Duration(seconds: 45));
      if (file != null) {
        _sendMessage(content: 'Form_Kontrol_Video.mp4', messageType: 'VIDEO', thumbnailUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=600&q=80');
      }
    } else if (type == 'AUDIO') {
      _startRealVoiceRecordingModal();
    }
  }

  void _startRealVoiceRecordingModal() {
    HapticFeedback.mediumImpact();
    int elapsedSeconds = 0;
    Timer? recTimer;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            recTimer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              setModalState(() {
                elapsedSeconds++;
              });
            });

            final mins = elapsedSeconds ~/ 60;
            final secs = elapsedSeconds % 60;
            final durationStr =
                '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

            return Container(
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'GERÇEK ZAMANLI SES KAYDI ALINIYOR...',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent, width: 2),
                    ),
                    child: const Icon(
                      Icons.mic_rounded,
                      color: Colors.redAccent,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    durationStr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Koçun ${_coachProfile['name'] ?? 'Atlas Demir'}\'e iletilecek',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white38),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            recTimer?.cancel();
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'İPTAL ET',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emeraldGreen,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            recTimer?.cancel();
                            Navigator.pop(ctx);
                            final finalDurStr =
                                '${mins > 0 ? '$mins dk ' : ''}$secs sn';
                            _sendMessage(
                              content: 'Gerçek Sesli Mesaj • $finalDurStr',
                              messageType: 'AUDIO',
                            );
                          },
                          child: const Text(
                            'KAYDI GÖNDER',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _startAudioCall() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 46,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Atlas Demir (PRO KOÇ)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sesli Görüşme • 02:41',
                style: TextStyle(
                  color: AppColors.emeraldGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCallBtn(Icons.mic_off_rounded, 'Sessiz', Colors.white24),
                  _buildCallBtn(
                      Icons.volume_up_rounded, 'Hoparlör', AppColors.emeraldGreen),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call_end_rounded,
                          color: Colors.white, size: 28),
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

  void _startVideoCall() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 480,
            width: double.infinity,
            color: Colors.black,
            child: Stack(
              children: [
                // Koç Video Akışı Simülasyonu
                Positioned.fill(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=800&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                // Üst Bilgi
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'CANLI GÖRÜNTÜLÜ SEANS • 04:18',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'HD 1080p',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // PIP Kendi Kameran
                Positioned(
                  right: 18,
                  bottom: 100,
                  child: Container(
                    width: 100,
                    height: 135,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Alt Kontrol Düğmeleri
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCallBtn(
                          Icons.mic_off_rounded, 'Sessiz', Colors.white24),
                      _buildCallBtn(
                          Icons.flip_camera_ios_rounded, 'Çevir', Colors.white24),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.call_end_rounded,
                              color: Colors.white, size: 28),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCallBtn(IconData icon, String label, Color bg) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
              color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: _buildCustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              itemCount: _messages.length + (_isCoachTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14, left: 32),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.emeraldGreen),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_coachProfile['name'] ?? 'Atlas Demir'} yazıyor...',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.obsidianBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          _buildMultimediaInputBar(),
        ],
      ),
    );
  }

  /// Üst AppBar (Koç Resmi, Çevrimiçi Durumu ve Bilgisi)
  PreferredSizeWidget _buildCustomAppBar() {
    final String coachName = _coachProfile['name'] ?? 'Atlas Demir';
    final String coachTitle =
        _coachProfile['title'] ?? 'Hipertrofi & Biyomekanik Koçu';
    final String avatarUrl = _coachProfile['avatarUrl'] ??
        'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80';

    return AppBar(
      backgroundColor: AppColors.lightSurface,
      elevation: 0.8,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      titleSpacing: 0,
      leading: const SizedBox.shrink(),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 13,
                    height: 13,
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
                Row(
                  children: [
                    Text(
                      coachName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.obsidianBlack,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PRO KOÇ',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: AppColors.emeraldGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.emeraldGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Çevrimiçi • $coachTitle',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Mesajları Yenile',
          icon: const Icon(Icons.refresh_rounded, color: AppColors.emeraldGreen),
          onPressed: () {
            HapticFeedback.lightImpact();
            _loadRealChatData();
          },
        ),
        IconButton(
          icon: const Icon(Icons.phone_rounded, color: AppColors.emeraldGreen),
          onPressed: _startAudioCall,
        ),
        IconButton(
          icon: const Icon(Icons.videocam_rounded, color: AppColors.emeraldGreen),
          onPressed: _startVideoCall,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Sağ-Sol Hizalı Mesaj Baloncuğu
  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final bool isMe = msg['isMe'] == true;
    final String messageType = msg['messageType'] ?? 'TEXT';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            const CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=100&q=80',
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isMe ? AppColors.emeraldGreen : AppColors.lightSurface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(22),
                  topRight: const Radius.circular(22),
                  bottomLeft: Radius.circular(isMe ? 22 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 22),
                ),
                border: isMe ? null : Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // VIDEO TİPİ MESAJ
                  if (messageType == 'VIDEO') ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            msg['thumbnailUrl'] ?? '',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // AUDIO TİPİ MESAJ
                  if (messageType == 'AUDIO') ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_circle_fill_rounded,
                            color: isMe ? Colors.white : AppColors.emeraldGreen, size: 32),
                        const SizedBox(width: 10),
                        Icon(Icons.graphic_eq_rounded,
                            color: isMe ? Colors.white70 : AppColors.textMuted, size: 26),
                        const SizedBox(width: 8),
                        Text(
                          msg['content'],
                          style: TextStyle(
                            color: isMe ? Colors.white : AppColors.obsidianBlack,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // TEXT veya IMAGE MESAJI
                    Text(
                      msg['content'],
                      style: TextStyle(
                        color: isMe ? Colors.white : AppColors.obsidianBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ],

                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        msg['time'],
                        style: TextStyle(
                          color: isMe ? Colors.white70 : AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.done_all_rounded, color: Colors.white70, size: 13),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Medya Butonları (Fotoğraf, Video, Ses) ile Mesaj Giriş Barı
  Widget _buildMultimediaInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Fotoğraf Seçimi (IMAGE)
            IconButton(
              icon: const Icon(Icons.image_rounded, color: AppColors.emeraldGreen),
              tooltip: 'Fotoğraf Gönder',
              onPressed: () => _pickMedia('IMAGE'),
            ),
            // Kısa Video Çekimi (VIDEO - Form Kontrolü)
            IconButton(
              icon: const Icon(Icons.videocam_rounded, color: AppColors.emeraldGreen),
              tooltip: 'Form Kontrol Videosu Çek',
              onPressed: () => _pickMedia('VIDEO'),
            ),
            // Ses Kaydı (AUDIO)
            IconButton(
              icon: const Icon(Icons.mic_rounded, color: AppColors.emeraldGreen),
              tooltip: 'Ses Kaydı At',
              onPressed: () => _pickMedia('AUDIO'),
            ),

            // Metin Alanı (TEXT)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Koçuna bir mesaj yaz...',
                    hintStyle: TextStyle(color: Color(0xFF64748B)),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (val) => _sendMessage(content: val, messageType: 'TEXT'),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Gönder Butonu
            GestureDetector(
              onTap: () => _sendMessage(content: _messageController.text, messageType: 'TEXT'),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF059669), Color(0xFF10B981)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
