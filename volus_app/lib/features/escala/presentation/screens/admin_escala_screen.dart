import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';
import 'package:volus_app/features/home/presentation/screens/admin_navigation_screen.dart';

enum VolunteerScaleStatus {
  requestedSwap, // Orange dot
  confirmed,     // Green dot
  present,       // Blue dot
  notNotified,   // Yellow dot
  unavailable    // Red (Camila Ribeiro case)
}

class AdminEscalaScreen extends StatefulWidget {
  const AdminEscalaScreen({super.key});

  @override
  State<AdminEscalaScreen> createState() => _AdminEscalaScreenState();
}

class _AdminEscalaScreenState extends State<AdminEscalaScreen> {
  // Hardcoded volunteer scale list matching prototype
  late List<Map<String, dynamic>> _volunteers;

  // Controllers for event details
  late final TextEditingController _eventNameController;
  late final TextEditingController _eventLocationController;
  late final TextEditingController _eventDateController;
  late final TextEditingController _eventTimeController;

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController(text: 'Construção Comunitária - Vila Nova');
    _eventLocationController = TextEditingController(text: 'Comunidade Vila Nova, Setor B');
    _eventDateController = TextEditingController(text: '25/05/2024');
    _eventTimeController = TextEditingController(text: '08:00');

    _volunteers = [
      {
        'id': '1',
        'name': 'Ana Clara Souza',
        'role': 'Logística',
        'initials': 'AC',
        'status': VolunteerScaleStatus.present,
      },
      {
        'id': '2',
        'name': 'Bruno Martins',
        'role': 'Construção',
        'initials': 'BM',
        'status': VolunteerScaleStatus.present,
      },
      {
        'id': '3',
        'name': 'Camila Ribeiro',
        'role': 'Avisou indisponibilidade',
        'initials': 'CR',
        'status': VolunteerScaleStatus.unavailable,
      },
      {
        'id': '4',
        'name': 'Diego Fernandes',
        'role': 'Construção',
        'initials': 'DF',
        'status': VolunteerScaleStatus.requestedSwap,
      },
      {
        'id': '5',
        'name': 'Eduardo Lima',
        'role': 'Alimentação',
        'initials': 'EL',
        'status': VolunteerScaleStatus.present,
      },
    ];
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2024, 5, 25),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: TetoColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: TetoColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final day = picked.day.toString().padLeft(2, '0');
        final month = picked.month.toString().padLeft(2, '0');
        final year = picked.year;
        _eventDateController.text = '$day/$month/$year';
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: TetoColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: TetoColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        _eventTimeController.text = '$hour:$minute';
      });
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventLocationController.dispose();
    _eventDateController.dispose();
    _eventTimeController.dispose();
    super.dispose();
  }

  void _showStatusPicker(Map<String, dynamic> volunteer) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Alterar status de ${volunteer['name']}',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TetoColors.textDark,
                  ),
                ),
                const SizedBox(height: 20),
                _buildStatusTile(volunteer, VolunteerScaleStatus.present, 'Presente', const Color(0xFF3B82F6)),
                _buildStatusTile(volunteer, VolunteerScaleStatus.confirmed, 'Confirmado', const Color(0xFF22C55E)),
                _buildStatusTile(volunteer, VolunteerScaleStatus.requestedSwap, 'Troca solicitada', const Color(0xFFD97706)),
                _buildStatusTile(volunteer, VolunteerScaleStatus.notNotified, 'Não notificado', const Color(0xFFEAB308)),
                _buildStatusTile(volunteer, VolunteerScaleStatus.unavailable, 'Avisou indisponibilidade (Indisponível)', const Color(0xFFDC2626)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusTile(Map<String, dynamic> volunteer, VolunteerScaleStatus status, String label, Color color) {
    return ListTile(
      leading: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: TetoColors.textDark,
        ),
      ),
      onTap: () {
        setState(() {
          volunteer['status'] = status;
          if (status == VolunteerScaleStatus.unavailable) {
            volunteer['role'] = 'Avisou indisponibilidade';
          } else if (volunteer['role'] == 'Avisou indisponibilidade') {
            volunteer['role'] = 'Construção'; // fallback to a role
          }
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Status de ${volunteer['name']} alterado para "$label"',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            backgroundColor: TetoColors.primaryBlue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: TetoColors.borderSide, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person,
                      size: 20,
                      color: TetoColors.primaryBlue,
                    ),
                  ),
                ),
              ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Page Header
              Text(
                'Gerenciar Escala',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: TetoColors.textDark,
                ),
              ),
              const SizedBox(height: 24),

              // Action button 1: Concluir escala
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Escala concluída! Voluntários notificados por e-mail e push.',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: TetoColors.primaryBlue,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TetoColors.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Concluir escala e Notificar voluntários',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),

              // Action button 2: Gerar escalas automaticamente
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      Future.delayed(const Duration(seconds: 1), () {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Escala gerada automaticamente com sucesso!',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                              backgroundColor: TetoColors.primaryGreen,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      });
                      return const Center(
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(TetoColors.primaryGreen),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TetoColors.primaryGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Gerar escalas automaticamente',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              // Legend Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildLegendItem(const Color(0xFFD97706), 'Troca solicitada'),
                        _buildLegendItem(const Color(0xFF22C55E), 'Confirmado'),
                        _buildLegendItem(const Color(0xFF3B82F6), 'Presente'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildLegendItem(const Color(0xFFEAB308), 'Não notificado'),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Section List Header
              Text(
                'Escala de Voluntários (${_volunteers.length})',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TetoColors.textDark,
                ),
              ),
              const SizedBox(height: 12),

              // Volunteer Cards List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _volunteers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final volunteer = _volunteers[index];
                  return _buildVolunteerCard(volunteer);
                },
              ),
              const SizedBox(height: 28),

              // Event Details Header
              Text(
                'Detalhes do Evento',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TetoColors.textDark,
                ),
              ),
              const SizedBox(height: 12),

              // Event Details Form Card
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEventField(
                      'Nome do Evento',
                      _eventNameController,
                      readOnly: false,
                    ),
                    const SizedBox(height: 16),
                    _buildEventField(
                      'Local do Evento',
                      _eventLocationController,
                      suffixIcon: Icons.location_on_outlined,
                      readOnly: false,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildEventField(
                            'Data',
                            _eventDateController,
                            suffixIcon: Icons.calendar_today_outlined,
                            readOnly: true,
                            onTap: _selectDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildEventField(
                            'Hora',
                            _eventTimeController,
                            suffixIcon: Icons.access_time_outlined,
                            readOnly: true,
                            onTap: _selectTime,
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
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: TetoColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildVolunteerCard(Map<String, dynamic> volunteer) {
    final VolunteerScaleStatus status = volunteer['status'];
    final String initials = volunteer['initials'];
    final String name = volunteer['name'];
    final String role = volunteer['role'];

    Color cardBgColor = Colors.white;
    Color textColor = TetoColors.textDark;
    Color subtitleColor = TetoColors.textMuted;
    Color avatarBgColor = TetoColors.primaryBlue;
    Color avatarTextColor = Colors.white;
    Widget? trailingWidget;

    if (status == VolunteerScaleStatus.unavailable) {
      cardBgColor = const Color(0xFFFFF1F1);
      textColor = const Color(0xFF991B1B);
      subtitleColor = const Color(0xFFC53030);
      avatarBgColor = const Color(0xFFFEE2E2);
      avatarTextColor = const Color(0xFF991B1B);
      trailingWidget = const Icon(Icons.description_outlined, color: Color(0xFFC53030), size: 18);
    } else if (status == VolunteerScaleStatus.requestedSwap) {
      cardBgColor = const Color(0xFFFFFBEB);
      textColor = const Color(0xFFD97706);
      subtitleColor = TetoColors.textMuted;
      avatarBgColor = const Color(0xFFE2E8F0);
      avatarTextColor = TetoColors.textMuted;
      trailingWidget = const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 18);
    } else if (status == VolunteerScaleStatus.confirmed) {
      avatarBgColor = const Color(0xFF22C55E);
      avatarTextColor = Colors.white;
    } else if (status == VolunteerScaleStatus.notNotified) {
      avatarBgColor = const Color(0xFFEAB308);
      avatarTextColor = Colors.white;
    }

    return InkWell(
      onTap: () => _showStatusPicker(volunteer),
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: status == VolunteerScaleStatus.unavailable
                ? const Color(0xFFFCA5A5)
                : status == VolunteerScaleStatus.requestedSwap
                    ? const Color(0xFFFDE68A)
                    : TetoColors.borderSide.withOpacity(0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: avatarBgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: GoogleFonts.inter(
                    color: avatarTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.inter(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        if (status == VolunteerScaleStatus.requestedSwap) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (status == VolunteerScaleStatus.unavailable) ...[
                          const Icon(Icons.assignment_outlined, color: Color(0xFFC53030), size: 14),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          role,
                          style: GoogleFonts.inter(
                            color: subtitleColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
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
      ),
    );
  }

  Widget _buildEventField(
    String label,
    TextEditingController controller, {
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: TetoColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: TetoColors.textDark,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: readOnly && onTap == null ? const Color(0xFFF1F5F9).withOpacity(0.6) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: TetoColors.borderSide.withOpacity(0.8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: TetoColors.borderSide.withOpacity(0.8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: TetoColors.primaryBlue, width: 1.5),
            ),
            suffixIcon: suffixIcon != null
                ? (onTap != null
                    ? IconButton(
                        icon: Icon(suffixIcon, color: TetoColors.textDark, size: 20),
                        onPressed: onTap,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                    : Icon(suffixIcon, color: TetoColors.textDark, size: 20))
                : null,
          ),
        ),
      ],
    );
  }
}
