import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';

class VolunteerProfileDetailsScreen extends StatelessWidget {
  const VolunteerProfileDetailsScreen({super.key});

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
          'Perfil do Voluntário',
          style: GoogleFonts.inter(
            color: TetoColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
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
              // Profile Summary Card
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: TetoColors.borderSide, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.person,
                            size: 50,
                            color: TetoColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'João Silva',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: TetoColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.business_center_outlined,
                          color: TetoColors.textMuted,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Voluntário - Núcleo SP',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: TetoColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Term active badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F4EA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF137333),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Termo de Voluntariado: Ativo',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF137333),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Personal Info Card
              _buildSectionCard(
                title: 'Informações Pessoais',
                icon: Icons.person_outline,
                rows: [
                  _buildDetailRow('CPF', '***.456.789-**'),
                  _buildDetailRow('Idade', '28 anos'),
                  _buildDetailRow('Data de Nascimento', '15/08/1995'),
                ],
              ),
              const SizedBox(height: 20),

              // Contact & Location Card
              _buildSectionCard(
                title: 'Contato e Localização',
                icon: Icons.contact_mail_outlined,
                rows: [
                  _buildDetailRow('Localização', 'São Paulo, SP', icon: Icons.location_on_outlined),
                  _buildDetailRow(
                    'Contato de Emergência',
                    '(11) 98765-4321\nMãe',
                    icon: Icons.phone_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> rows,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: TetoColors.primaryBlue, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: TetoColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: TetoColors.borderSide),
          const SizedBox(height: 4),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: TetoColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, color: TetoColors.textMuted, size: 16),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TetoColors.textDark,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
