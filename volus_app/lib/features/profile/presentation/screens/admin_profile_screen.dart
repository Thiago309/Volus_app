import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';
import 'package:volus_app/features/auth/presentation/screens/login_screen.dart';
import 'package:volus_app/features/home/presentation/widgets/teto_drawer.dart';
import 'gerenciar_usuarios_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TetoDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: TetoColors.primaryBlue),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'Perfil Administrador',
          style: GoogleFonts.inter(
            color: TetoColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none_rounded, color: TetoColors.primaryBlue, size: 26),
                Positioned(
                  right: 3,
                  top: 3,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
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
              // Admin photo, name, and subtitle
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: TetoColors.borderSide, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.person,
                            size: 60,
                            color: TetoColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ricardo Mendes',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: TetoColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Coordenador Geral - Núcleo SP',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: TetoColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats Cards
              _buildStatsCard(
                icon: Icons.people_outline,
                iconColor: TetoColors.primaryBlue,
                label: 'Voluntários sob gestão',
                value: '145',
                valueColor: TetoColors.primaryBlue,
              ),
              const SizedBox(height: 12),
              _buildStatsCard(
                icon: Icons.volunteer_activism_outlined,
                iconColor: TetoColors.primaryGreen,
                label: 'Projetos Ativos',
                value: '12',
                valueColor: TetoColors.primaryGreen,
              ),
              const SizedBox(height: 12),
              _buildStatsCard(
                icon: Icons.construction_outlined,
                iconColor: TetoColors.primaryBlue,
                label: 'Construções Finalizadas',
                value: '34',
                valueColor: TetoColors.primaryBlue,
              ),
              const SizedBox(height: 28),

              // ADMINISTRATION TOOLS
              Text(
                'FERRAMENTAS DE ADMINISTRAÇÃO',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: TetoColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GerenciarUsuariosScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5EDFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.manage_accounts_outlined,
                          color: TetoColors.primaryBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Gerenciar Usuários',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: TetoColors.textDark,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: TetoColors.textMuted,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // PERSONAL INFO CARD
              Text(
                'INFORMAÇÕES PESSOAIS',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: TetoColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
                ),
                child: Column(
                  children: [
                    _buildPersonalRow('CPF', '***.123.456-**'),
                    const Divider(height: 1, color: TetoColors.borderSide),
                    _buildPersonalRow('Cargo', 'Coordenador Regional'),
                    const Divider(height: 1, color: TetoColors.borderSide),
                    _buildPersonalRow('E-mail', 'ricardo.mendes@teto.org.br'),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Logout Button
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Sessão encerrada com sucesso.',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: TetoColors.primaryBlue,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.logout, size: 18, color: Color(0xFFC53030)),
                label: Text(
                  'Sair da Conta',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFC53030),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFCA5A5), width: 1.2),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
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
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: TetoColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: TetoColors.textMuted,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TetoColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
