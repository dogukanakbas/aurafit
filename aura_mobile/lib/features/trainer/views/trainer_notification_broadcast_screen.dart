import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';
import '../../../core/services/local_storage_service.dart';

class TrainerNotificationBroadcastScreen extends StatefulWidget {
  const TrainerNotificationBroadcastScreen({super.key});

  @override
  State<TrainerNotificationBroadcastScreen> createState() =>
      _TrainerNotificationBroadcastScreenState();
}

class _TrainerNotificationBroadcastScreenState
    extends State<TrainerNotificationBroadcastScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String _selectedType = 'SU';
  bool _sendToAll = true;
  final Set<String> _selectedStudentIds = {'s_1', 's_2', 's_3'};

  final List<Map<String, dynamic>> _students = [
    {
      'id': 's_1',
      'name': 'Erlik Han',
      'goal': 'Yağ Yak & Kas Kazan',
      'avatar':
          'https://images.unsplash.com/photo-1567013127542-490d757e51fc?auto=format&fit=crop&w=200&q=80',
    },
    {
      'id': 's_2',
      'name': 'Zeynep Kaya',
      'goal': 'Hipertrofi & Güç',
      'avatar':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
    },
    {
      'id': 's_3',
      'name': 'Mert Yılmaz',
      'goal': 'Kondisyon & Dayanıklılık',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
    },
  ];

  void _sendNotification() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bildirim başlığı ve içeriği giriniz.')),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    final newNotif = {
      'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
      'title': title,
      'body': body,
      'time': 'Az önce',
      'type': _selectedType,
      'targetStudent': _sendToAll ? 'ALL' : _selectedStudentIds.join(','),
    };

    await LocalStorageService.addNotification(newNotif);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _sendToAll
              ? 'Toplu Bildirim Tüm Üyelere İletildi ✅'
              : 'Seçili Üyelere Bildirim İletildi ✅',
        ),
        backgroundColor: AppColors.emeraldGreen,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightSurface,
        elevation: 0.8,
        title: const Text(
          'DANIŞANLARA BİLDİRİM GÖNDER',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: AppColors.obsidianBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hedef Üye Seçimi
            const Text(
              'HEDEF ÜYE SEÇİMİ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.textMuted,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: AppColors.emeraldGreen,
                    title: const Text(
                      'Tüm Danışanlarıma Gönder (Toplu Bildirim)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    value: _sendToAll,
                    onChanged: (val) {
                      setState(() {
                        _sendToAll = val;
                      });
                    },
                  ),
                  if (!_sendToAll) ...[
                    const Divider(height: 1),
                    ..._students.map((student) {
                      final bool isSelected =
                          _selectedStudentIds.contains(student['id']);
                      return CheckboxListTile(
                        activeColor: AppColors.emeraldGreen,
                        secondary: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(student['avatar']),
                        ),
                        title: Text(
                          student['name'],
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(student['goal'],
                            style: const TextStyle(fontSize: 11)),
                        value: isSelected,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedStudentIds.add(student['id']);
                            } else {
                              _selectedStudentIds.remove(student['id']);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Bildirim Türü
            const Text(
              'BİLDİRİM KATEGORİSİ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.textMuted,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildTypeChip('SU', 'Su Hatırlatması', Icons.water_drop_rounded),
                const SizedBox(width: 8),
                _buildTypeChip('PROGRAM', 'Program Güncellemesi',
                    Icons.fitness_center_rounded),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTypeChip('UYARI', 'Acil Uyarı',
                    Icons.notification_important_rounded),
                const SizedBox(width: 8),
                _buildTypeChip(
                    'BİLGİ', 'Genel Bilgi', Icons.info_outline_rounded),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Başlık ve İçerik
            const Text(
              'BİLDİRİM BAŞLIĞI',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.textMuted,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Örn: Su Hatırlatması veya Program Yenilendi',
                filled: true,
                fillColor: AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 18),

            const Text(
              'BİLDİRİM İÇERİĞİ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.textMuted,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bodyController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Danışanlarınıza iletmek istediğiniz bildirimi yazın...',
                filled: true,
                fillColor: AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 32),

            PremiumButton(
              onPressed: _sendNotification,
              label: 'BİLDİRİMİ GÖNDER',
              icon: Icons.send_rounded,
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String key, String label, IconData icon) {
    final isSelected = _selectedType == key;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _selectedType = key);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.emeraldGreen.withValues(alpha: 0.15)
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.emeraldGreen : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color:
                      isSelected ? AppColors.emeraldGreen : AppColors.textMuted,
                  size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? AppColors.emeraldGreen
                        : AppColors.obsidianBlack,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
