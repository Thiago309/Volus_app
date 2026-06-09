import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';
import '../widgets/teto_drawer.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TetoDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Menu burger icon triggering drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: TetoColors.primaryBlue),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'Voluts TETO',
          style: GoogleFonts.inter(
            color: TetoColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: TetoColors.primaryBlue),
            onPressed: () {
              // Notification action
            },
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Resumo das Atividades
            Text(
              'Resumo das Atividades',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: TetoColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Bem-vindo de volta! Aqui está o impacto da comunidade hoje.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TetoColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),

            // Two stats cards side-by-side
            Row(
              children: [
                // Card 1: Horas Doadas
                Expanded(
                  child: _buildStatsCard(
                    icon: Icons.volunteer_activism,
                    iconBgColor: TetoColors.primaryBlue,
                    iconColor: Colors.white,
                    value: '124h',
                    valueColor: TetoColors.primaryBlue,
                    label: 'Horas doadas (mês)',
                  ),
                ),
                const SizedBox(width: 16),
                // Card 2: Voluntários Ativos
                Expanded(
                  child: _buildStatsCard(
                    icon: Icons.people_outline_rounded,
                    iconBgColor: const Color(0xFFC4E87F).withOpacity(0.4),
                    iconColor: TetoColors.primaryGreen,
                    value: '18',
                    valueColor: TetoColors.primaryGreen,
                    label: 'Voluntários ativos',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Section 2: Equipe Disponível
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Equipe Disponível',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: TetoColors.primaryBlue,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.green, size: 8),
                    const SizedBox(width: 4),
                    Text(
                      'Agora',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Horizontal list of team members
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildTeamMember(
                    name: 'Ana C.',
                    imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
                  ),
                  _buildTeamMember(
                    name: 'Marcos T.',
                    imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                  ),
                  _buildTeamMember(
                    name: 'Laura B.',
                    initials: 'LB',
                    bgColor: TetoColors.primaryBlue,
                    textColor: Colors.white,
                  ),
                  _buildTeamMember(
                    name: 'João P.',
                    icon: Icons.person_outline_rounded,
                    bgColor: TetoColors.socialButtonBg,
                    textColor: TetoColors.socialButtonIcon,
                  ),
                  _buildTeamMember(
                    name: 'Sofia M.',
                    imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Section 3: Agenda Futura
            Text(
              'Agenda Futura',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: TetoColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),

            // Agenda List
            _buildAgendaItem(
              month: 'OUT',
              day: '24',
              dateBgColor: const Color(0xFFE2EAF8),
              dateTextColor: TetoColors.primaryBlue,
              title: 'Construção Emergencial',
              time: '08:00 - 18:00',
              location: 'Comunidade Esperança, SP',
              locationIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 12),
            _buildAgendaItem(
              month: 'OUT',
              day: '28',
              dateBgColor: const Color(0xFFF1F1F4),
              dateTextColor: TetoColors.textDark,
              title: 'Reunião de Alocação',
              time: '19:30 - 21:00',
              location: 'Online (Meet)',
              locationIcon: Icons.videocam_outlined,
            ),
            const SizedBox(height: 20),

            // Outline Button: Ver Agenda Completa
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  // View full agenda
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: TetoColors.primaryBlue, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: TetoColors.primaryBlue,
                ),
                child: Text(
                  'Ver Agenda Completa',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: TetoColors.primaryBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper builder for stats card
  Widget _buildStatsCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String value,
    required Color valueColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TetoColors.borderSide.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: TetoColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // Helper builder for team members
  Widget _buildTeamMember({
    required String name,
    String? imageUrl,
    String? initials,
    IconData? icon,
    Color? bgColor,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 18),
      child: Column(
        children: [
          Stack(
            children: [
              // Avatar container
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bgColor ?? Colors.grey.shade200,
                  border: Border.all(color: TetoColors.borderSide, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              name.substring(0, 1),
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: TetoColors.primaryBlue,
                              ),
                            ),
                          ),
                        )
                      : initials != null
                          ? Center(
                              child: Text(
                                initials,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor ?? TetoColors.primaryBlue,
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                icon ?? Icons.person,
                                color: textColor ?? TetoColors.primaryBlue,
                                size: 24,
                              ),
                            ),
                ),
              ),
              // Status green dot
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: TetoColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  // Helper builder for agenda items
  Widget _buildAgendaItem({
    required String month,
    required String day,
    required Color dateBgColor,
    required Color dateTextColor,
    required String title,
    required String time,
    required String location,
    required IconData locationIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TetoColors.borderSide.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date block on the left
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: dateBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: dateTextColor.withOpacity(0.7),
                  ),
                ),
                Text(
                  day,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: dateTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Detail blocks on the right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: TetoColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: TetoColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: TetoColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(locationIcon, size: 14, color: TetoColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      location,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: TetoColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
