import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';
import 'package:volus_app/features/auth/presentation/screens/login_screen.dart';
import 'package:volus_app/features/home/presentation/widgets/teto_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isAvailable = true;
  int _selectedReasonIndex = -1;

  final List<String> _reasons = ['Viagem', 'Trabalho/Estudos', 'Saúde/Pessoal'];

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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header
              Text(
                'Meu Perfil',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: TetoColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Gerencie suas informações pessoais e disponibilidade.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: TetoColors.textMuted,
                ),
              ),
              const SizedBox(height: 20),

              // "Editar Perfil" Button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Edit Profile action
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18, color: TetoColors.primaryBlue),
                  label: Text(
                    'Editar Perfil',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TetoColors.primaryBlue,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: TetoColors.borderSide, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Main User Info Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                  children: [
                    // Top header offset banner
                    SizedBox(
                      height: 120,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE2EAF8), // light gray-blue banner
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Stack(
                                children: [
                                  // User Avatar Image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.network(
                                        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: Colors.grey.shade300,
                                          child: const Icon(Icons.person, color: Colors.grey, size: 40),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Camera icon overlay badge
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: TetoColors.primaryBlue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // User name & role
                    Text(
                      'João Silva',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TetoColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Voluntário - Núcleo SP',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: TetoColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Form Fields List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          _buildInfoField('Data de Nascimento', '15/08/1995'),
                          const SizedBox(height: 16),
                          _buildInfoField('Idade', '28 anos'),
                          const SizedBox(height: 16),
                          _buildInfoField('CPF', '***.456.789-**'),
                          const SizedBox(height: 16),
                          _buildInfoField('Contato de Emergência', '(11) 98765-4321 (Mãe)'),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Termo de Voluntariado Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC4E87F).withOpacity(0.35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC4E87F).withOpacity(0.6)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: TetoColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Termo de Voluntariado',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: TetoColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ativo e regularizado. Você está apto para participar das atividades.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: TetoColors.primaryGreen.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Disponibilidade Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TetoColors.borderSide.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, color: TetoColors.primaryBlue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Disponibilidade',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: TetoColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Atualize seu status para facilitar o planejamento das escalas da equipe.',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: TetoColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // "Estou disponível" toggle card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: TetoColors.borderSide.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estou disponível',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: TetoColors.textDark,
                            ),
                          ),
                          Switch(
                            value: _isAvailable,
                            onChanged: (v) {
                              setState(() {
                                _isAvailable = v;
                                if (_isAvailable) {
                                  _selectedReasonIndex = -1; // reset unavailablity reason
                                }
                              });
                            },
                            activeColor: TetoColors.primaryGreen,
                            activeTrackColor: const Color(0xFFC4E87F).withOpacity(0.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Reasons section
                    Text(
                      'Motivo da indisponibilidade (Opcional)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _isAvailable ? TetoColors.textMuted.withOpacity(0.4) : TetoColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Horizontal selection chips
                    Row(
                      children: List.generate(_reasons.length, (index) {
                        final isSelected = _selectedReasonIndex == index;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: index == _reasons.length - 1 ? 0 : 8.0),
                            child: InkWell(
                              onTap: _isAvailable
                                  ? null
                                  : () {
                                      setState(() {
                                        _selectedReasonIndex = isSelected ? -1 : index;
                                      });
                                    },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFE2EAF8) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? TetoColors.primaryBlue
                                        : _isAvailable
                                            ? TetoColors.borderSide.withOpacity(0.3)
                                            : TetoColors.borderSide,
                                    width: isSelected ? 1.5 : 1.0,
                                  ),
                                ),
                                child: Text(
                                  _reasons[index],
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected
                                        ? TetoColors.primaryBlue
                                        : _isAvailable
                                            ? TetoColors.textMuted.withOpacity(0.3)
                                            : TetoColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // "Sair da Conta" Logout Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Navigate back to LoginScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
                  label: Text(
                    'Sair da Conta',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFCA5A5), width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Info field row item helper
  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: TetoColors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC), // very light gray/blue
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: TetoColors.borderSide),
          ),
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
    );
  }
}
