import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';

class ProjetosAtivosScreen extends StatefulWidget {
  const ProjetosAtivosScreen({super.key});

  @override
  State<ProjetosAtivosScreen> createState() => _ProjetosAtivosScreenState();
}

class _ProjetosAtivosScreenState extends State<ProjetosAtivosScreen> {
  String _selectedCategory = 'Todos';

  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'Construção de Banheiros Sustentáveis',
      'location': 'Comunidade Vila Nova',
      'category': 'Em andamento',
      'imageUrl': 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=500',
      'progress': 65,
    },
    {
      'title': 'Reforma da Sede Comunitária',
      'location': 'Jardim Esperança',
      'category': 'Planejamento',
      'imageUrl': 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=500',
      'startDate': '15 Outubro',
    },
    {
      'title': 'Coleta Nacional nas Ruas',
      'location': 'Múltiplas Cidades',
      'category': 'Captação de Recursos',
      'imageUrl': 'https://images.unsplash.com/photo-1530587191325-3db32d826c18?w=500',
      'financialProgress': 30,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProjects = _selectedCategory == 'Todos'
        ? _projects
        : _projects.where((p) => p['category'] == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TetoColors.primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Projetos Ativos',
          style: GoogleFonts.inter(
            color: TetoColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: TetoColors.primaryBlue),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
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
              // Header title and subtitle
              Text(
                'Impacto em ação',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: TetoColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Acompanhe os projetos sociais em andamento nas comunidades e veja onde sua ajuda faz a diferença.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: TetoColors.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterChip('Todos', hasCheckIcon: true),
                    const SizedBox(width: 8),
                    _buildFilterChip('Em andamento'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Planejamento'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Captação de Recursos'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Project Cards List
              ...filteredProjects.map((project) => _buildProjectCard(project)),

              const SizedBox(height: 24),

              // Engagement Call to Action Card
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EFFB).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color(0xFFE5E2F7),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5E2F7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.handshake_outlined,
                        color: Color(0xFF4A3E8D),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Quer fazer parte?',
                      style: GoogleFonts.inter(
                        color: TetoColors.textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Inscreva-se nas escalas de trabalho voluntário e ajude a transformar a realidade dessas comunidades.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: TetoColors.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Return indicator to navigate to Escala screen
                        Navigator.pop(context, 'go_to_escala');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0038A8), // Deep blue matching mockup
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Ver Escalas Disponíveis',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool hasCheckIcon = false}) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0038A8) : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? const Color(0xFF0038A8) : TetoColors.borderSide,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected && hasCheckIcon) ...[
              const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected ? Colors.white : TetoColors.textDark.withOpacity(0.8),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    final String category = project['category'];
    Color badgeBgColor;
    Color badgeTextColor;
    IconData badgeIcon;

    if (category == 'Em andamento') {
      badgeBgColor = const Color(0xFFDCFCE7); // light green
      badgeTextColor = const Color(0xFF166534); // dark green
      badgeIcon = Icons.sync_rounded;
    } else if (category == 'Planejamento') {
      badgeBgColor = const Color(0xFFF3E8FF); // light purple
      badgeTextColor = const Color(0xFF6B21A8); // dark purple
      badgeIcon = Icons.calendar_today_rounded;
    } else {
      badgeBgColor = const Color(0xFFF1F5F9); // light grey
      badgeTextColor = const Color(0xFF334155); // dark grey
      badgeIcon = Icons.campaign_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image and Tag Stack
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: Image.network(
                  project['imageUrl'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image_outlined, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
              ),
              // Category tag
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badgeIcon, color: badgeTextColor, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        category,
                        style: GoogleFonts.inter(
                          color: badgeTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Details content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['title'],
                  style: GoogleFonts.inter(
                    color: TetoColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: TetoColors.textMuted, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      project['location'],
                      style: GoogleFonts.inter(
                        color: TetoColors.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Specific widget depending on project variables
                if (project.containsKey('progress')) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progresso',
                            style: GoogleFonts.inter(
                              color: TetoColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${project['progress']}%',
                            style: GoogleFonts.inter(
                              color: TetoColors.primaryBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: LinearProgressIndicator(
                          value: project['progress'] / 100.0,
                          backgroundColor: TetoColors.borderSide,
                          color: const Color(0xFF0038A8),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ] else if (project.containsKey('startDate')) ...[
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: TetoColors.borderSide, width: 1.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined, color: TetoColors.textMuted, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Início previsto',
                              style: GoogleFonts.inter(
                                color: TetoColors.textMuted,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            project['startDate'],
                            style: GoogleFonts.inter(
                              color: const Color(0xFF6B21A8),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (project.containsKey('financialProgress')) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Meta Financeira',
                            style: GoogleFonts.inter(
                              color: TetoColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${project['financialProgress']}%',
                            style: GoogleFonts.inter(
                              color: TetoColors.primaryBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: LinearProgressIndicator(
                          value: project['financialProgress'] / 100.0,
                          backgroundColor: TetoColors.borderSide,
                          color: const Color(0xFF0038A8),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
