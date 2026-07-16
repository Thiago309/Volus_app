import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volus_app/core/theme/teto_colors.dart';
import 'package:volus_app/core/services/supabase_service.dart';
import 'volunteer_profile_details_screen.dart';

class GerenciarUsuariosScreen extends StatefulWidget {
  const GerenciarUsuariosScreen({super.key});

  @override
  State<GerenciarUsuariosScreen> createState() => _GerenciarUsuariosScreenState();
}

class _GerenciarUsuariosScreenState extends State<GerenciarUsuariosScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allVolunteers = [];
  List<Map<String, dynamic>> _filteredVolunteers = [];
  bool _isLoading = false;

  // Cores de avatar alternadas
  static const List<List<int>> _avatarColors = [
    [0xFFE0F2FE, 0xFF0369A1],
    [0xFFF1EFFB, 0xFF4A3E8D],
    [0xFFE6F4EA, 0xFF137333],
    [0xFFFFF4E5, 0xFFB06000],
    [0xFFE8F0FE, 0xFF1A73E8],
    [0xFFFCE4EC, 0xFFC62828],
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterList);
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterList);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final dbUsers = await SupabaseService.getVolunteers();
      final mapped = dbUsers.asMap().entries.map((entry) {
        final i = entry.key;
        final u = entry.value;
        return _mapUserToDisplay(u, i);
      }).toList();

      setState(() {
        _allVolunteers = mapped;
        _filteredVolunteers = List.from(mapped);
      });
    } catch (e) {
      debugPrint('Erro ao buscar usuários: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic> _mapUserToDisplay(Map<String, dynamic> u, int index) {
    final name = u['name'] ?? 'Voluntário';
    final nucleus = u['nucleus'] ?? 'Núcleo SP';
    final role = u['role'] ?? 'voluntario';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'V';
    final parts = name.split(' ');
    final secondInitial = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0].toUpperCase() : '';
    final initials = '$initial$secondInitial';
    final colorPair = _avatarColors[index % _avatarColors.length];

    return {
      'id': u['id']?.toString() ?? '',
      'name': name,
      'email': u['email'] ?? '',
      'role': '${role == 'admin' ? 'Administrador' : 'Voluntário'} - $nucleus',
      'raw_role': role,
      'nucleus': nucleus,
      'initials': initials,
      'avatarBg': colorPair[0],
      'avatarText': colorPair[1],
      'cpf': u['cpf'] ?? '',
      'birth_date': u['birth_date'] ?? '',
      'emergency_contact': u['emergency_contact'] ?? '',
      'photo_url': u['photo_url'] ?? '',
      'is_available': u['is_available'] ?? true,
      'raw': u,
    };
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredVolunteers = _allVolunteers
          .where((v) => (v['name'] as String).toLowerCase().contains(query))
          .toList();
    });
  }

  // ==========================================
  // DIALOGS: ADICIONAR / EDITAR / EXCLUIR
  // ==========================================

  void _showAddUserDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final cpfCtrl = TextEditingController();
    final nucleusCtrl = TextEditingController(text: 'Núcleo SP');
    final birthDateCtrl = TextEditingController();
    final emergencyCtrl = TextEditingController();
    String selectedRole = 'voluntario';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.person_add, color: TetoColors.primaryBlue, size: 24),
                const SizedBox(width: 10),
                Text('Novo Usuário', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: TetoColors.primaryBlue)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogField('Nome completo *', nameCtrl),
                  const SizedBox(height: 12),
                  _dialogField('E-mail *', emailCtrl, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  _dialogField('CPF', cpfCtrl),
                  const SizedBox(height: 12),
                  _dialogField('Núcleo', nucleusCtrl),
                  const SizedBox(height: 12),
                  _dialogField('Data de Nascimento (AAAA-MM-DD)', birthDateCtrl),
                  const SizedBox(height: 12),
                  _dialogField('Contato de Emergência', emergencyCtrl),
                  const SizedBox(height: 12),
                  // Role selector
                  Row(
                    children: [
                      Text('Tipo:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: TetoColors.textDark)),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: Text('Voluntário', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        selected: selectedRole == 'voluntario',
                        selectedColor: TetoColors.primaryBlue.withOpacity(0.15),
                        onSelected: (_) => setDialogState(() => selectedRole = 'voluntario'),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text('Admin', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        selected: selectedRole == 'admin',
                        selectedColor: TetoColors.primaryBlue.withOpacity(0.15),
                        onSelected: (_) => setDialogState(() => selectedRole = 'admin'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancelar', style: GoogleFonts.inter(color: TetoColors.textMuted, fontWeight: FontWeight.w600)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameCtrl.text.trim().isEmpty || emailCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Nome e E-mail são obrigatórios.', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  Navigator.pop(ctx);
                  setState(() => _isLoading = true);

                  final result = await SupabaseService.createUser(
                    name: nameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    role: selectedRole,
                    nucleus: nucleusCtrl.text.trim(),
                    cpf: cpfCtrl.text.trim(),
                    birthDate: birthDateCtrl.text.trim(),
                    emergencyContact: emergencyCtrl.text.trim(),
                  );

                  if (result != null) {
                    await _loadUsers();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Usuário "${nameCtrl.text.trim()}" criado com sucesso!', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          backgroundColor: TetoColors.primaryBlue,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  } else {
                    setState(() => _isLoading = false);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao criar usuário. Verifique se o e-mail já existe.', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TetoColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Salvar', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
      },
    );
  }

  void _showEditUserDialog(Map<String, dynamic> volunteer) {
    final nameCtrl = TextEditingController(text: volunteer['name']);
    final emailCtrl = TextEditingController(text: volunteer['email']);
    final cpfCtrl = TextEditingController(text: volunteer['cpf']);
    final nucleusCtrl = TextEditingController(text: volunteer['nucleus']);
    final birthDateCtrl = TextEditingController(text: volunteer['birth_date']);
    final emergencyCtrl = TextEditingController(text: volunteer['emergency_contact']);
    String selectedRole = volunteer['raw_role'] ?? 'voluntario';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.edit, color: TetoColors.primaryBlue, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Editar Usuário', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: TetoColors.primaryBlue)),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogField('Nome completo', nameCtrl),
                  const SizedBox(height: 12),
                  _dialogField('E-mail', emailCtrl, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  _dialogField('CPF', cpfCtrl),
                  const SizedBox(height: 12),
                  _dialogField('Núcleo', nucleusCtrl),
                  const SizedBox(height: 12),
                  _dialogField('Data de Nascimento (AAAA-MM-DD)', birthDateCtrl),
                  const SizedBox(height: 12),
                  _dialogField('Contato de Emergência', emergencyCtrl),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Tipo:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: TetoColors.textDark)),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: Text('Voluntário', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        selected: selectedRole == 'voluntario',
                        selectedColor: TetoColors.primaryBlue.withOpacity(0.15),
                        onSelected: (_) => setDialogState(() => selectedRole = 'voluntario'),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text('Admin', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                        selected: selectedRole == 'admin',
                        selectedColor: TetoColors.primaryBlue.withOpacity(0.15),
                        onSelected: (_) => setDialogState(() => selectedRole = 'admin'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancelar', style: GoogleFonts.inter(color: TetoColors.textMuted, fontWeight: FontWeight.w600)),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  setState(() => _isLoading = true);

                  final success = await SupabaseService.updateUser(
                    id: volunteer['id'],
                    name: nameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    role: selectedRole,
                    nucleus: nucleusCtrl.text.trim(),
                    cpf: cpfCtrl.text.trim(),
                    birthDate: birthDateCtrl.text.trim(),
                    emergencyContact: emergencyCtrl.text.trim(),
                  );

                  if (success) {
                    await _loadUsers();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Usuário atualizado com sucesso!', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          backgroundColor: TetoColors.primaryBlue,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TetoColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Salvar', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
      },
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> volunteer) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
              const SizedBox(width: 10),
              Text('Excluir Usuário', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
          content: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 14, color: TetoColors.textDark, height: 1.5),
              children: [
                const TextSpan(text: 'Tem certeza que deseja excluir '),
                TextSpan(text: volunteer['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: '?\n\nEssa ação não pode ser desfeita.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancelar', style: GoogleFonts.inter(color: TetoColors.textMuted, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                setState(() => _isLoading = true);

                final success = await SupabaseService.deleteUser(volunteer['id']);

                if (success) {
                  await _loadUsers();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Usuário "${volunteer['name']}" excluído.', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        backgroundColor: TetoColors.primaryBlue,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Excluir', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: TetoColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(fontSize: 13, color: TetoColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: TetoColors.borderSide.withOpacity(0.8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: TetoColors.primaryBlue, width: 1.5),
        ),
      ),
    );
  }

  // ==========================================
  // BUILD
  // ==========================================

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
      // FAB para adicionar novo usuário
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUserDialog,
        backgroundColor: TetoColors.primaryBlue,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: Text('Novo', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
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

            // Counter badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: TetoColors.primaryBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_filteredVolunteers.length} usuário${_filteredVolunteers.length == 1 ? '' : 's'}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: TetoColors.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Volunteers List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: TetoColors.primaryBlue))
                  : _filteredVolunteers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.people_outline, color: TetoColors.textMuted, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                'Nenhum voluntário encontrado.',
                                style: GoogleFonts.inter(
                                  color: TetoColors.textMuted,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Toque em "+ Novo" para adicionar.',
                                style: GoogleFonts.inter(
                                  color: TetoColors.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                          itemCount: _filteredVolunteers.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final v = _filteredVolunteers[index];
                            final avatarBg = Color(v['avatarBg'] as int);
                            final avatarText = Color(v['avatarText'] as int);

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VolunteerProfileDetailsScreen(
                                      volunteerData: v,
                                    ),
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
                                        v['initials'] as String,
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
                                            v['name'] as String,
                                            style: GoogleFonts.inter(
                                              color: TetoColors.textDark,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            v['role'] as String,
                                            style: GoogleFonts.inter(
                                              color: TetoColors.textMuted,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Action buttons: Edit + Delete
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: TetoColors.primaryBlue, size: 20),
                                      onPressed: () => _showEditUserDialog(v),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      tooltip: 'Editar',
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                      onPressed: () => _showDeleteConfirmation(v),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      tooltip: 'Excluir',
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
