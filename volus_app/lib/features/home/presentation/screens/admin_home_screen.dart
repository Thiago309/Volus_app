import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';
import 'package:volus_app/features/home/presentation/widgets/teto_drawer.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _assistedFamilies = 150;
  bool _isEditingFamilies = false;
  late final TextEditingController _familiesController;

  double _campaignValue = 45000.0;
  final double _campaignTarget = 50000.0;
  bool _isEditingCampaign = false;

  String _formatCurrency(double val) {
    final integerPart = val.toInt();
    if (integerPart >= 1000) {
      final thousands = integerPart ~/ 1000;
      final remainder = integerPart % 1000;
      final remainderStr = remainder.toString().padLeft(3, '0');
      return 'R\$ $thousands.$remainderStr';
    }
    return 'R\$ $integerPart';
  }

  @override
  void initState() {
    super.initState();
    _familiesController = TextEditingController(text: _assistedFamilies.toString());
  }

  @override
  void dispose() {
    _familiesController.dispose();
    super.dispose();
  }

  // Testimonials list with interactive approval
  List<Map<String, String>> _pendingTestimonials = [
    {
      'id': '1',
      'initial': 'M',
      'name': 'Maria Oliveira',
      'text': '"O novo centro comunit..."',
      'avatarBg': '0xFFE0F2FE',
      'avatarText': '0xFF0369A1',
    },
    {
      'id': '2',
      'initial': 'C',
      'name': 'Carlos Santos',
      'text': '"Ser voluntário aqui me d..."',
      'avatarBg': '0xFFF1EFFB',
      'avatarText': '0xFF4A3E8D',
    },
  ];

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
          'Painel Administrativo',
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
              // Welcome Header
              Text(
                'Bem-vindo, Admin',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TetoColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Gerencie projetos, avisos e impacto comunitário.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: TetoColors.textMuted,
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Formulário "Adicionar Projeto" em desenvolvimento.',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                            ),
                            backgroundColor: TetoColors.primaryGreen,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TetoColors.primaryGreen,
                        foregroundColor: Colors.white,
                        fixedSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Adicionar\nProjeto',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Painel "Postar Aviso" em desenvolvimento.',
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
                        fixedSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.campaign_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Postar Aviso',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Impact Card
              _buildImpactCard(),
              const SizedBox(height: 20),

              // Campaign Meta Card
              _buildCampaignCard(),
              const SizedBox(height: 20),

              // Urgent Alerts Card
              _buildUrgentAlertsCard(),
              const SizedBox(height: 20),

              // Pending Testimonials Card
              _buildTestimonialsCard(),
              const SizedBox(height: 20),

              // Active Projects Card
              _buildActiveProjectsCard(),
              const SizedBox(height: 20),

              // Manage Gallery Card
              _buildManageGalleryCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImpactCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white,
            const Color(0xFFC4E87F).withOpacity(0.06),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite_border, color: TetoColors.primaryGreen, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Impacto este Mês',
                    style: GoogleFonts.inter(
                      color: TetoColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_isEditingFamilies) {
                      final parsedValue = int.tryParse(_familiesController.text);
                      if (parsedValue != null) {
                        _assistedFamilies = parsedValue;
                      } else {
                        _familiesController.text = _assistedFamilies.toString();
                      }
                      _isEditingFamilies = false;
                    } else {
                      _isEditingFamilies = true;
                    }
                  });
                },
                child: Icon(
                  _isEditingFamilies ? Icons.check : Icons.mode_edit_outlined,
                  color: _isEditingFamilies ? TetoColors.primaryGreen : TetoColors.textMuted,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _isEditingFamilies
              ? SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _familiesController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    style: GoogleFonts.inter(
                      color: TetoColors.primaryBlue,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                )
              : Text(
                  _assistedFamilies.toString(),
                  style: GoogleFonts.inter(
                    color: TetoColors.primaryBlue,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: 4),
          Text(
            'Famílias Assistidas',
            style: GoogleFonts.inter(
              color: TetoColors.textMuted,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.analytics_outlined, color: TetoColors.primaryBlue, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Meta da Campanha',
                    style: GoogleFonts.inter(
                      color: TetoColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEditingCampaign = !_isEditingCampaign;
                  });
                },
                child: Icon(
                  _isEditingCampaign ? Icons.check : Icons.mode_edit_outlined,
                  color: _isEditingCampaign ? TetoColors.primaryGreen : TetoColors.textMuted,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatCurrency(_campaignValue),
                style: GoogleFonts.inter(
                  color: TetoColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'de R\$ 50k',
                style: GoogleFonts.inter(
                  color: TetoColors.textMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _isEditingCampaign
              ? SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 8,
                    activeTrackColor: TetoColors.primaryBlue,
                    inactiveTrackColor: TetoColors.borderSide,
                    thumbColor: TetoColors.primaryBlue,
                    overlayColor: TetoColors.primaryBlue.withOpacity(0.2),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    trackShape: const RoundedRectSliderTrackShape(),
                  ),
                  child: SizedBox(
                    height: 24,
                    child: Slider(
                      value: _campaignValue,
                      min: 0.0,
                      max: _campaignTarget,
                      onChanged: (newValue) {
                        setState(() {
                          _campaignValue = newValue;
                        });
                      },
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: _campaignValue / _campaignTarget,
                    backgroundColor: TetoColors.borderSide,
                    color: TetoColors.primaryBlue,
                    minHeight: 8,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildUrgentAlertsCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFC53030), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Avisos Urgentes',
                    style: GoogleFonts.inter(
                      color: TetoColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.add, color: TetoColors.primaryBlue, size: 24),
            ],
          ),
          const SizedBox(height: 16),
          // Sub-card 1: Meteorológico
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFCA5A5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alerta Meteorológico: Checagem de Ferramentas',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF991B1B),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Certifique-se de que todas as lonas estão presas para a construção do fim de semana.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF7F1D1D),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Sub-card 2: Reunião
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TetoColors.borderSide),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reunião Reagendada',
                  style: GoogleFonts.inter(
                    color: TetoColors.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Reunião com líderes comunitários alterada para as 14:00.',
                  style: GoogleFonts.inter(
                    color: TetoColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Depoimentos Pendentes',
                style: GoogleFonts.inter(
                  color: TetoColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Ver Todos',
                style: GoogleFonts.inter(
                  color: TetoColors.textLink,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_pendingTestimonials.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                child: Text(
                  'Nenhum depoimento pendente!',
                  style: GoogleFonts.inter(color: TetoColors.textMuted, fontSize: 14),
                ),
              ),
            )
          else
            ..._pendingTestimonials.map((t) => Column(
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Color(int.parse(t['avatarBg']!)),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            t['initial']!,
                            style: GoogleFonts.inter(
                              color: Color(int.parse(t['avatarText']!)),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Text column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t['name']!,
                                style: GoogleFonts.inter(
                                  color: TetoColors.textDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                t['text']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: TetoColors.textMuted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Actions
                        Row(
                          children: [
                            // Approved button
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _pendingTestimonials.removeWhere((item) => item['id'] == t['id']);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Depoimento de ${t['name']} aprovado!',
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                    ),
                                    backgroundColor: TetoColors.primaryGreen,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check, color: TetoColors.primaryGreen, size: 18),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFDCFCE7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Edit button
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.mode_edit_outlined, color: TetoColors.textMuted, size: 18),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFF1F5F9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                )),
        ],
      ),
    );
  }

  Widget _buildActiveProjectsCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Projetos Ativos',
                style: GoogleFonts.inter(
                  color: TetoColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.filter_alt_outlined, color: TetoColors.textMuted, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'Filtrar',
                    style: GoogleFonts.inter(
                      color: TetoColors.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Table layout or list of project rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Nome do Projeto',
                  style: GoogleFonts.inter(
                    color: TetoColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  'Localização Status',
                  style: GoogleFonts.inter(
                    color: TetoColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Ação',
                    style: GoogleFonts.inter(
                      color: TetoColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: TetoColors.borderSide),

          // Project Row 1: Vila Esperança
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Vila Esperança\nBuild',
                  style: GoogleFonts.inter(
                    color: TetoColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'São Paulo, SP',
                      style: GoogleFonts.inter(
                        color: TetoColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Text(
                        'Em Andamento',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF166534),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mode_edit_outlined, color: TetoColors.textMuted, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Project Row 2: Jardim Angela
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Jardim Angela\nSurvey',
                  style: GoogleFonts.inter(
                    color: TetoColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'São Paulo, SP',
                      style: GoogleFonts.inter(
                        color: TetoColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Text(
                        'Planejamento',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF3730A3),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mode_edit_outlined, color: TetoColors.textMuted, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManageGalleryCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: TetoColors.borderSide.withOpacity(0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gerenciar Galeria',
                style: GoogleFonts.inter(
                  color: TetoColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: TetoColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Grid layout of images
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=350',
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=350',
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
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
