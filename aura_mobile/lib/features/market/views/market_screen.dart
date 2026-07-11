import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_button.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _selectedCategory = 'Tümü';
  final List<Map<String, dynamic>> _cart = [];

  final List<String> _categories = [
    'Tümü',
    'Takviye & Supplement',
    'Ekipman & Aksesuar',
    'Koçluk & E-Kitap',
  ];

  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': 'p1',
      'title': 'Aura İzole Whey Protein (2000g)',
      'category': 'Takviye & Supplement',
      'price': 1650,
      'oldPrice': 1950,
      'rating': 4.9,
      'reviews': 128,
      'badge': 'KOÇ ÖNERİSİ',
      'image':
          'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f?auto=format&fit=crop&w=500&q=80',
      'desc':
          'Mikrofiltre edilmiş %90 saf protein oranı. Her porsiyonda 27g protein ve 6.5g BCAA.',
    },
    {
      'id': 'p2',
      'title': 'Aura Micronized Kreatin Monohidrat (300g)',
      'category': 'Takviye & Supplement',
      'price': 690,
      'oldPrice': 850,
      'rating': 4.8,
      'reviews': 94,
      'badge': '%18 İNDİRİM',
      'image':
          'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?auto=format&fit=crop&w=500&q=80',
      'desc':
          'Patlayıcı güç ve kas hacmi artışı için %100 saf mikronize kreatin.',
    },
    {
      'id': 'p3',
      'title': 'Pro Lifting Strap & Bileklik Seti',
      'category': 'Ekipman & Aksesuar',
      'price': 420,
      'oldPrice': 550,
      'rating': 4.9,
      'reviews': 210,
      'badge': 'ÇOK SATAN',
      'image':
          'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?auto=format&fit=crop&w=500&q=80',
      'desc':
          'Ağır deadlift ve barfiks setlerinde tutuş gücünüzü 2 katına çıkaran dayanıklı pamuk strap.',
    },
    {
      'id': 'p4',
      'title': 'Paslanmaz Çelik Termos Shaker (750ml)',
      'category': 'Ekipman & Aksesuar',
      'price': 480,
      'oldPrice': 600,
      'rating': 4.7,
      'reviews': 67,
      'badge': 'YENİ',
      'image':
          'https://images.unsplash.com/photo-1523362628745-0c100150b504?auto=format&fit=crop&w=500&q=80',
      'desc':
          'Topaklanma önleyici süzgeçli ve koku yapmayan paslanmaz çelik gövde.',
    },
    {
      'id': 'p5',
      'title': 'İleri Seviye Hipertrofi E-Kitabı',
      'category': 'Koçluk & E-Kitap',
      'price': 350,
      'oldPrice': 500,
      'rating': 5.0,
      'reviews': 312,
      'badge': 'DİJİTAL REHBER',
      'image':
          'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=500&q=80',
      'desc':
          'Kas protein sentezini maksimuma çıkaran bilime dayalı 12 haftalık periyotlama rehberi.',
    },
    {
      'id': 'p6',
      'title': 'Pre-Workout Enerji ve Odaklanma (30 Servis)',
      'category': 'Takviye & Supplement',
      'price': 890,
      'oldPrice': 1100,
      'rating': 4.8,
      'reviews': 145,
      'badge': 'GÜÇ PATLAMASI',
      'image':
          'https://images.unsplash.com/photo-1550345332-09e3ac987658?auto=format&fit=crop&w=500&q=80',
      'desc':
          'Sitrulin malat ve beta alanin destekli antrenman öncesi nitrik oksit formülü.',
    },
  ];

  void _addToCart(Map<String, dynamic> product) {
    HapticFeedback.mediumImpact();
    setState(() {
      _cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['title']} sepete eklendi!'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'SEPETE GİT',
          textColor: AppColors.emeraldGreen,
          onPressed: _openCartModal,
        ),
      ),
    );
  }

  void _openCartModal() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildCartSheet(),
    );
  }

  void _showProductDetail(Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildProductDetailSheet(product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _selectedCategory == 'Tümü'
        ? _allProducts
        : _allProducts
            .where((p) => p['category'] == _selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightSurface,
        elevation: 0.8,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AURA MAĞAZA & MARKET',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.obsidianBlack,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Koç Onaylı Supplement, Ekipman & Rehberler',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_rounded,
                      color: AppColors.obsidianBlack, size: 26),
                  onPressed: _openCartModal,
                ),
                if (_cart.isNotEmpty)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppColors.emeraldGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_cart.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. KATEGORİ SEKMELERİ
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final cat = _categories[idx];
                final isSel = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedCategory = cat);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel
                          ? AppColors.emeraldGreen
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSel
                            ? AppColors.emeraldGreen
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSel ? FontWeight.w900 : FontWeight.w700,
                          color:
                              isSel ? Colors.white : AppColors.obsidianBlack,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. ÜRÜN LİSTESİ / IZGARASI
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final item = filteredProducts[idx];
                return _buildProductCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () => _showProductDetail(product),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // RESİM
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                product['image'],
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),

            // BİLGİLER
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product['badge'],
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: AppColors.emeraldGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.obsidianBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.warning, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${product['rating']} (${product['reviews']} değerlendirme)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '₺${product['price']}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: AppColors.obsidianBlack,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '₺${product['oldPrice']}',
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _addToCart(product),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.emeraldGreen,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            'SEPETE EKLE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetailSheet(Map<String, dynamic> product) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.obsidianBlack,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.network(
              product['image'],
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product['desc'],
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fiyat: ₺${product['price']}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.obsidianBlack,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _addToCart(product);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emeraldGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.add_shopping_cart_rounded,
                    color: Colors.white),
                label: const Text(
                  'SEPETE EKLE',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCartSheet() {
    final int total = _cart.fold<int>(
        0, (sum, item) => sum + (item['price'] as int? ?? 0));

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
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
                  Text(
                    'ALIŞVERİŞ SEPETİM (${_cart.length} Ürün)',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.obsidianBlack,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              if (_cart.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'Sepetiniz henüz boş. Mağazadan ürün ekleyebilirsiniz.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              else ...[
                Expanded(
                  child: ListView.separated(
                    itemCount: _cart.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, idx) {
                      final item = _cart[idx];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(item['image'],
                              width: 50, height: 50, fit: BoxFit.cover),
                        ),
                        title: Text(
                          item['title'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                        subtitle: Text(
                          '₺${item['price']}',
                          style: const TextStyle(
                            color: AppColors.emeraldGreen,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: Colors.red),
                          onPressed: () {
                            setModalState(() {
                              setState(() {
                                _cart.removeAt(idx);
                              });
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOPLAM TUTAR',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMuted)),
                    Text(
                      '₺$total',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.obsidianBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: PremiumButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _cart.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              '🎉 Ödemeniz başarıyla alındı! Siparişiniz hazırlanıyor.'),
                        ),
                      );
                    },
                    label: 'GÜVENLİ ÖDEMEYİ TAMAMLA (₺$total)',
                    icon: Icons.verified_user_rounded,
                    isPrimary: true,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
