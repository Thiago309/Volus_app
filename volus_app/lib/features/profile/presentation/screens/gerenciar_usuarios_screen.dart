import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';
import 'volunteer_profile_details_screen.dart';

class GerenciarUsuariosScreen extends StatefulWidget {
  const GerenciarUsuariosScreen({super.key});

  @override
  State<GerenciarUsuariosScreen> createState() => _GerenciarUsuariosScreenState();
}

class _GerenciarUsuariosScreenState extends State<GerenciarUsuariosScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _allVolunteers = [
    {
      'name': 'João Silva',
      'role': 'Voluntário - Núcleo SP',
      'initials': 'JS',
      'avatarBg': '0xFFE0F2FE',
      'avatarText': '0xFF0369A1',
    },
    {
      'name': 'Maria Oliveira',
      'role': 'Voluntária - Núcleo SP',
      'initials': 'MO',
      'avatarBg': '0xFFF1EFFB',
      'avatarText': '0xFF4A3E8D',
    },
    {
      'name': 'Carlos Santos',
      'role': 'Voluntário - Núcleo SP',
      'initials': 'CS',
      'avatarBg': '0xFFE6F4EA',
      'avatarText': '0xFF137333',
    },
    {
      'name': 'Ana Clara Souza',
      'role': 'Voluntária - Logística',
      'initials': 'AC',
      'avatarBg': '0xFFFFF4E5',
      'avatarText': '0xFFB06000',
    },
    {
      'name': 'Bruno Martins',
      'role': 'Voluntário - Construção',
      'initials': 'BM',
      'avatarBg': '0xFFE8F0FE',
      'avatarText': '0xFF1A73E8',
    },
  ];

  late List<Map<String, String>> _filteredVolunteers;

  @override
  void initState() {
    super.initState();
    _filteredVolunteers = List.from(_allVolunteers);
    _searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterList);
    _searchController.dispose();
    super.dispose();
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredVolunteers = _allVolunteers
          .where((v) => v['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

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
          'Gerenciar Usuários',
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
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: TetoColors.textDark,
                ),
                decoration: InputDecoration(
                  hintText: 'Pesquisar voluntários...',
                  hintStyle: GoogleFonts.inter(
                    color: TetoColors.textMuted,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search, color: TetoColors.textMuted, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: Colors.white,
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
                ),
              ),
            ),

            // Volunteers List
            Expanded(
              child: _filteredVolunteers.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum voluntário encontrado.',
                        style: GoogleFonts.inter(
                          color: TetoColors.textMuted,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                      itemCount: _filteredVolunteers.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final v = _filteredVolunteers[index];
                        final avatarBg = Color(int.parse(v['avatarBg']!));
                        final avatarText = Color(int.parse(v['avatarText']!));

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const VolunteerProfileDetailsScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: TetoColors.borderSide.withOpacity(0.5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.01),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Avatar circle
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: avatarBg,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    v['initials']!,
                                    style: GoogleFonts.inter(
                                      color: avatarText,
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
                                      Text(
                                        v['name']!,
                                        style: GoogleFonts.inter(
                                          color: TetoColors.textDark,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        v['role']!,
                                        style: GoogleFonts.inter(
                                          color: TetoColors.textMuted,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
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
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
