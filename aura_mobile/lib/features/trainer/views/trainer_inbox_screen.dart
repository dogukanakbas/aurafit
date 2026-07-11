import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/local_storage_service.dart';

class TrainerInboxScreen extends StatefulWidget {
  const TrainerInboxScreen({super.key});

  @override
  State<TrainerInboxScreen> createState() => _TrainerInboxScreenState();
}

class _TrainerInboxScreenState extends State<TrainerInboxScreen> {
  List<Map<String, dynamic>> _chatMessages = [];

  final List<Map<String, dynamic>> _students = [
    {
      'id': 'client_me',
      'name': 'Erlik Han',
      'goal': 'Yağ Yak & Kas Kazan',
      'avatar': 'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80',
      'unread': 1,
      'lastActive': 'Şimdi',
    },
    {
      'id': 'client_zeynep',
      'name': 'Zeynep Kaya',
      'goal': 'Hipertrofi & Güç',
      'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      'unread': 0,
      'lastActive': '24 dk önce',
    },
    {
      'id': 'client_mert',
      'name': 'Mert Yılmaz',
      'goal': 'Kondisyon & Dayanıklılık',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      'unread': 0,
      'lastActive': '3 saat önce',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final list = await LocalStorageService.getChatMessages();
    if (mounted) {
      setState(() {
        _chatMessages = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String latestSnippet = 'Henüz mesaj yok';
    if (_chatMessages.isNotEmpty) {
      latestSnippet = _chatMessages.last['content'] ?? 'Yeni mesaj';
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightSurface,
        elevation: 0.8,
        title: const Text(
          'DANIŞAN MESAJ KUTUSU',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.obsidianBlack,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Mesajları Yenile',
            icon: const Icon(Icons.refresh_rounded, color: AppColors.emeraldGreen),
            onPressed: () {
              HapticFeedback.lightImpact();
              _loadMessages();
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          final isPrimary = student['id'] == 'client_me';

          return GestureDetector(
            onTap: () async {
              HapticFeedback.mediumImpact();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrainerStudentChatDetailScreen(
                    student: student,
                  ),
                ),
              );
              _loadMessages();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isPrimary ? AppColors.emeraldGreen : Colors.grey.shade200,
                  width: isPrimary ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(student['avatar']),
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              student['name'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: AppColors.obsidianBlack,
                              ),
                            ),
                            Text(
                              student['lastActive'],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isPrimary ? latestSnippet : 'Son antrenman formumu yükledim hocam 💪',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isPrimary ? FontWeight.w800 : FontWeight.w500,
                            color: isPrimary ? AppColors.obsidianBlack : AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TrainerStudentChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> student;
  const TrainerStudentChatDetailScreen({super.key, required this.student});

  @override
  State<TrainerStudentChatDetailScreen> createState() =>
      _TrainerStudentChatDetailScreenState();
}

class _TrainerStudentChatDetailScreenState
    extends State<TrainerStudentChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final list = await LocalStorageService.getChatMessages();
    if (mounted) {
      setState(() {
        _messages = list;
      });
      _scrollToBottom();
    }
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

  void _sendTrainerReply({
    required String content,
    String messageType = 'TEXT',
    String? thumbnailUrl,
  }) {
    if (content.trim().isEmpty && messageType == 'TEXT') return;

    HapticFeedback.lightImpact();
    final newMsg = {
      'id': 'msg_trainer_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': 'trainer_atlas',
      'senderName': 'Atlas Demir (Koç)',
      'isMe': false, // Öğrenci tarafında sol (koç), antrenör tarafında sağ
      'messageType': messageType,
      'content': content,
      'thumbnailUrl': thumbnailUrl,
      'time':
          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    };

    setState(() {
      _messages.add(newMsg);
    });

    LocalStorageService.addChatMessage(newMsg);
    _messageController.clear();
    _scrollToBottom();
  }

  void _startTrainerVoiceRecordingModal() {
    HapticFeedback.mediumImpact();
    int elapsedSeconds = 0;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            Future.delayed(const Duration(seconds: 1), () {
              if (ctx.mounted) {
                setModalState(() {
                  elapsedSeconds++;
                });
              }
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic_rounded, color: Colors.redAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'ANTRENÖR SES KAYDI ALINIYOR...',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    durationStr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white38),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('İPTAL',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emeraldGreen,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _sendTrainerReply(
                              content:
                                  'Koç Sesli Mesaj • ${mins > 0 ? '$mins dk ' : ''}$secs sn',
                              messageType: 'AUDIO',
                            );
                          },
                          child: const Text('GÖNDER',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900)),
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

  void _sendTrainerPhotoModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Öğrencinize Görsel veya Şablon Gönderin',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.image_rounded, color: AppColors.emeraldGreen),
              title: const Text('Egzersiz Doğru Form Görseli',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () {
                Navigator.pop(ctx);
                _sendTrainerReply(
                  content: 'Egzersiz Form Şablonu (Görsel)',
                  messageType: 'IMAGE',
                  thumbnailUrl:
                      'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=600&q=80',
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.restaurant_menu_rounded, color: AppColors.emeraldGreen),
              title: const Text('Beslenme Tabağı Örnek Fotoğrafı',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () {
                Navigator.pop(ctx);
                _sendTrainerReply(
                  content: 'Hedef Beslenme Örneği',
                  messageType: 'IMAGE',
                  thumbnailUrl:
                      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleContent(Map<String, dynamic> msg, bool isTrainerSent) {
    final String type = msg['messageType'] ?? 'TEXT';
    final String content = msg['content'] ?? '';
    final String? thumb = msg['thumbnailUrl'];

    if (type == 'IMAGE' && thumb != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              thumb,
              width: 220,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          Text(content,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isTrainerSent ? Colors.white : AppColors.obsidianBlack)),
        ],
      );
    } else if (type == 'AUDIO') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_circle_fill_rounded,
              color: isTrainerSent ? Colors.white : AppColors.emeraldGreen,
              size: 28),
          const SizedBox(width: 8),
          Text(content,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isTrainerSent ? Colors.white : AppColors.obsidianBlack)),
        ],
      );
    } else {
      return Text(
        content,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isTrainerSent ? Colors.white : AppColors.obsidianBlack,
        ),
      );
    }
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
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.student['avatar']),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.student['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.obsidianBlack,
                  ),
                ),
                Text(
                  widget.student['goal'],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            icon: const Icon(Icons.refresh_rounded, color: AppColors.emeraldGreen),
            onPressed: () {
              HapticFeedback.lightImpact();
              _loadMessages();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final bool isTrainerSent = msg['senderId'] == 'trainer_atlas';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: isTrainerSent
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isTrainerSent) ...[
                        CircleAvatar(
                          radius: 13,
                          backgroundImage:
                              NetworkImage(widget.student['avatar']),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isTrainerSent
                                ? AppColors.emeraldGreen
                                : AppColors.lightSurface,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(isTrainerSent ? 20 : 4),
                              bottomRight: Radius.circular(isTrainerSent ? 4 : 20),
                            ),
                            border: isTrainerSent
                                ? null
                                : Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: isTrainerSent
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              _buildBubbleContent(msg, isTrainerSent),
                              const SizedBox(height: 4),
                              Text(
                                msg['time'] ?? '',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isTrainerSent
                                      ? Colors.white70
                                      : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lightSurface,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Görsel Yükle',
                  icon: const Icon(Icons.add_photo_alternate_rounded,
                      color: AppColors.emeraldGreen),
                  onPressed: _sendTrainerPhotoModal,
                ),
                IconButton(
                  tooltip: 'Ses Kaydı Al',
                  icon: const Icon(Icons.mic_rounded,
                      color: AppColors.emeraldGreen),
                  onPressed: _startTrainerVoiceRecordingModal,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Öğrencinize yanıt, not veya program yazın...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (val) => _sendTrainerReply(content: val),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded,
                      color: AppColors.emeraldGreen),
                  onPressed: () =>
                      _sendTrainerReply(content: _messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
