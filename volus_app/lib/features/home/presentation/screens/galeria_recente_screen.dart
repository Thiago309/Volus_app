import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';

class GaleriaRecenteScreen extends StatefulWidget {
  const GaleriaRecenteScreen({super.key});

  @override
  State<GaleriaRecenteScreen> createState() => _GaleriaRecenteScreenState();
}

class _GaleriaRecenteScreenState extends State<GaleriaRecenteScreen> {
  final List<Map<String, String>> _photos = [
    {
      'imageUrl': 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600',
      'tag': 'Outubro 2023',
      'title': 'Construção Setor B – Mutirão Principal',
      'subtitle': 'Nossa equipe principal finalizando as estruturas da casa modelo para a...',
      'tagColor': '0xFF3F7202', // Olive green
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1562259949-e8e7689d7828?w=600',
      'tag': 'Setembro 2023',
      'title': 'Equipe de Pintura',
      'tagColor': '0xFF082366', // Navy Blue
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=600',
      'tag': 'Setembro 2023',
      'title': 'Reunião Comunitária',
      'tagColor': '0xFF082366',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=600',
      'tag': 'Agosto 2023',
      'title': 'Alegria Pós-Entrega',
      'subtitle': 'A emoção de finalizar mais uma moradia com sucesso e segurança.',
      'tagColor': '0xFF3F7202',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1509099836639-18ba1795216d?w=600',
      'tag': 'Agosto 2023',
      'title': 'Logística e Transporte',
      'tagColor': '0xFF082366',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=600',
      'tag': 'Agosto 2023',
      'title': 'Pausa Merecida',
      'tagColor': '0xFF082366',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TetoColors.primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Galeria Recente',
          style: GoogleFonts.inter(
            color: TetoColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TetoColors.primaryBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.pin_drop_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: TetoColors.borderSide.withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF9FBFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Subtitle
              Text(
                'Momentos inesquecíveis das nossas últimas ações comunitárias.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: TetoColors.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              // Filter Button
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list_rounded, size: 18),
                  label: Text(
                    'Filtrar por Evento',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TetoColors.textDark,
                    side: const BorderSide(color: TetoColors.borderSide, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Gallery Feed Cards
              ..._photos.map((photo) => _buildPhotoCard(photo)),

              const SizedBox(height: 16),

              // Bottom Button "Carregar Mais Fotos"
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Todas as fotos recentes foram carregadas!',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: TetoColors.primaryBlue,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4A3E8D),
                  backgroundColor: const Color(0xFFF1EFFB),
                  side: const BorderSide(color: Color(0xFFE5E2F7), width: 1.5),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Carregar Mais Fotos',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoCard(Map<String, String> photo) {
    final hasSubtitle = photo.containsKey('subtitle');
    final tagColor = Color(int.parse(photo['tagColor']!));

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: TetoColors.borderSide.withOpacity(0.8),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          children: [
            // Image
            Image.network(
              photo['imageUrl']!,
              height: 340,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 340,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.image_outlined, color: Colors.grey, size: 40),
                ),
              ),
            ),
            // Bottom Gradient Overlay for text readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Content text overlaid on bottom
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: tagColor,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      photo['tag']!,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    photo['title']!,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  if (hasSubtitle) ...[
                    const SizedBox(height: 6),
                    // Subtitle
                    Text(
                      photo['subtitle']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
