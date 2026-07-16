import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';

class VolunteerProfileDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> volunteerData;

  const VolunteerProfileDetailsScreen({
    super.key,
    required this.volunteerData,
  });

  String _formatBirthDate(String rawDate) {
    if (rawDate.isEmpty) return 'Não informado';
    // Format from yyyy-MM-dd to dd/MM/yyyy
    if (rawDate.contains('-')) {
      final parts = rawDate.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    }
    return rawDate;
  }

  String _maskCpf(String cpf) {
    if (cpf.isEmpty) return 'Não informado';
    // Mask middle digits: ***.456.789-**
    if (cpf.length >= 11) {
      final clean = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      if (clean.length >= 11) {
        return '***. ${clean.substring(3, 6)}.${clean.substring(6, 9)}-**';
      }
    }
    return cpf;
  }

  String _calculateAge(String rawDate) {
    if (rawDate.isEmpty) return 'Não informado';
    try {
      final date = DateTime.parse(rawDate);
      final now = DateTime.now();
      int age = now.year - date.year;
      if (now.month < date.month || (now.month == date.month && now.day < date.day)) {
        age--;
      }
      return '$age anos';
    } catch (_) {
      return 'Não informado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = volunteerData['name'] ?? 'Voluntário';
    final role = volunteerData['role'] ?? 'Voluntário';
    final cpf = volunteerData['cpf'] ?? '';
    final birthDate = volunteerData['birth_date'] ?? '';
    final emergencyContact = volunteerData['emergency_contact'] ?? '';
    final photoUrl = volunteerData['photo_url'] ?? '';
    final isAvailable = volunteerData['is_available'] ?? true;
    final nucleus = volunteerData['nucleus'] ?? 'Núcleo SP';

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
                        child: photoUrl.isNotEmpty
                            ? Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildAvatarFallback(name),
                              )
                            : _buildAvatarFallback(name),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
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
                        Flexible(
                          child: Text(
                            role,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: TetoColors.textMuted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Availability badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isAvailable ? const Color(0xFFE6F4EA) : const Color(0xFFFFF1F1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isAvailable ? Icons.check_circle : Icons.cancel,
                            color: isAvailable ? const Color(0xFF137333) : const Color(0xFF991B1B),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isAvailable ? 'Disponível para Escalas' : 'Indisponível',
                            style: GoogleFonts.inter(
                              color: isAvailable ? const Color(0xFF137333) : const Color(0xFF991B1B),
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
                  _buildDetailRow('CPF', _maskCpf(cpf)),
                  _buildDetailRow('Idade', _calculateAge(birthDate)),
                  _buildDetailRow('Data de Nascimento', _formatBirthDate(birthDate)),
                  _buildDetailRow('Núcleo', nucleus),
                ],
              ),
              const SizedBox(height: 20),

              // Contact & Location Card
              _buildSectionCard(
                title: 'Contato e Localização',
                icon: Icons.contact_mail_outlined,
                rows: [
                  _buildDetailRow(
                    'E-mail',
                    volunteerData['email'] ?? 'Não informado',
                    icon: Icons.email_outlined,
                  ),
                  _buildDetailRow(
                    'Contato de Emergência',
                    emergencyContact.isNotEmpty ? emergencyContact : 'Não informado',
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

  Widget _buildAvatarFallback(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'V';
    return Container(
      color: TetoColors.primaryBlue.withOpacity(0.1),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.inter(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: TetoColors.primaryBlue,
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
